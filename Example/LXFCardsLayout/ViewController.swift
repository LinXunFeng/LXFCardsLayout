//
//  ViewController.swift
//  LXFCardsLayout
//
//  Created by 林洵锋 on 01/07/2022.
//  Copyright (c) 2022 林洵锋. All rights reserved.
//

import UIKit
import LXFCardsLayout

class ViewController: UIViewController {
    
    struct Macro {
        static let cellId: String = "cellid"
    }
    
    // MARK: - Private Property
    fileprivate let colors: [UIColor] = [
        .randomColor(),
        .randomColor(),
        .randomColor(),
        .randomColor(),
        .randomColor()
    ]
    
    fileprivate lazy var listViewLayout: LXFCardsLayout = {
        $0.spacing = 15
        $0.itemSize = CGSize(width: 250, height: 120)
        return $0
    }(LXFCardsLayout())
    
    fileprivate lazy var listView: UICollectionView = { [unowned self] in
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Macro.cellId)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: listViewLayout))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
    }

}

extension ViewController {
    fileprivate func initUI() {
        self.view.addSubview(self.listView)
        
        self.listView.frame = self.view.bounds
        self.listView.dataSource = self
        self.listView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Macro.cellId, for: indexPath)
        cell.layer.cornerRadius = 7.0
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath -- \(indexPath)")
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(
            red: CGFloat(arc4random() % 256) / 255.0,
            green: CGFloat(arc4random() % 256) / 255.0,
            blue: CGFloat(arc4random() % 256) / 255.0,
            alpha: 1
        )
    }
}
