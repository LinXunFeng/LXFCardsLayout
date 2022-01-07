//
//  LXFCardsLayout.swift
//  LXFCardsLayout
//
//  Created by linxunfeng on 2022/1/7.
//

import UIKit

open class LXFCardsLayout: UICollectionViewLayout {
    
    // MARK: - Layout configuration
    public var itemSize: CGSize = CGSize(width: 200, height: 300) {
        didSet { invalidateLayout() }
    }

    public var spacing: CGFloat = 10.0 {
        didSet { invalidateLayout() }
    }

    public var maximumVisibleItems: Int = 4 {
        didSet { invalidateLayout() }
    }
    
    // MARK: UICollectionViewLayout

    override open var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return .zero }
        let itemsCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        return CGSize(
            width: collectionView.bounds.width * itemsCount,
            height: collectionView.bounds.height
        )
    }

    override open func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        assert(collectionView.numberOfSections == 1, "Multiple sections aren't supported!")
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        
        let totalItemsCount = collectionView.numberOfItems(inSection: 0)

        let minVisibleIndex = max(Int(collectionView.contentOffset.x) / Int(collectionView.bounds.width), 0)
        let maxVisibleIndex = min(minVisibleIndex + maximumVisibleItems, totalItemsCount)

        let contentCenterX = collectionView.contentOffset.x + (collectionView.bounds.width / 2.0)

        let deltaOffset = Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width)

        let percentageDeltaOffset = CGFloat(deltaOffset) / collectionView.bounds.width

        let visibleIndices = stride(from: minVisibleIndex, to: maxVisibleIndex, by: 1)

        let attributes: [UICollectionViewLayoutAttributes] = visibleIndices.map { index in
            let indexPath = IndexPath(item: index, section: 0)
            return computeLayoutAttributesForItem(
                indexPath: indexPath,
                minVisibleIndex: minVisibleIndex,
                contentCenterX: contentCenterX,
                deltaOffset: CGFloat(deltaOffset),
                percentageDeltaOffset: percentageDeltaOffset
            )
        }

        return attributes
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}


// MARK: - Layout computations

fileprivate extension LXFCardsLayout {
    
    private func scale(at index: Int) -> CGFloat {
        let translatedCoefficient = CGFloat(index) - CGFloat(self.maximumVisibleItems) / 2
        return CGFloat(pow(0.95, translatedCoefficient))
    }

    private func transform(atCurrentVisibleIndex visibleIndex: Int, percentageOffset: CGFloat) -> CGAffineTransform {
        var rawScale = visibleIndex < maximumVisibleItems ? scale(at: visibleIndex) : 1.0

        if visibleIndex != 0 {
            let previousScale = scale(at: visibleIndex - 1)
            let delta = (previousScale - rawScale) * percentageOffset
            rawScale += delta
        }
        
        return CGAffineTransform(scaleX: rawScale, y: rawScale)
    }

    func computeLayoutAttributesForItem(
        indexPath: IndexPath,
        minVisibleIndex: Int,
        contentCenterX: CGFloat,
        deltaOffset: CGFloat,
        percentageDeltaOffset: CGFloat
    ) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith:indexPath)
        guard let collectionView = self.collectionView else { return attributes }
        
        let visibleIndex = indexPath.row - minVisibleIndex
        attributes.size = itemSize
        let midY = collectionView.bounds.midY
        attributes.center = CGPoint(
            x: contentCenterX + spacing * CGFloat(visibleIndex),
            y: midY
        )
        attributes.zIndex = maximumVisibleItems - visibleIndex

        attributes.transform = transform(
            atCurrentVisibleIndex: visibleIndex,
            percentageOffset: percentageDeltaOffset
        )
        
        switch visibleIndex {
        case 0:
            if deltaOffset < 0 { break }
            attributes.center.x -= deltaOffset
            break
        case 1..<maximumVisibleItems:
            attributes.center.x -= spacing * percentageDeltaOffset
            if visibleIndex == maximumVisibleItems - 1 {
                attributes.alpha = percentageDeltaOffset
            }
            break
        default:
            attributes.alpha = 0
            break
        }
        return attributes
    }
}
