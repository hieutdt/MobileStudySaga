//
//  FeedsView.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 20/06/2021.
//

import Foundation
import UIKit
import Masonry
import AlamofireImage

protocol FeedsViewDelegate: NSObject {
    
    func didSelectFeed(_ feed: FeedModel)
}

class FeedsView: UIView {
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    var models: [FeedModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    weak var delegate: FeedsViewDelegate? = nil
    
    func commonInit() {
        self.isSkeletonable = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 260, height: 280)
        
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.collectionView.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.register(FeedCollectionCell.self, forCellWithReuseIdentifier: FeedCollectionCell.reuseId)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        self.addSubview(self.collectionView)
        self.collectionView.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
        }
    }
}

extension FeedsView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(
                withReuseIdentifier: FeedCollectionCell.reuseId,
                for: indexPath) as? FeedCollectionCell else {
            fatalError()
        }
        
        cell.model = self.models[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let feed = self.models[index]
        
        if let delegate = self.delegate {
            delegate.didSelectFeed(feed)
        }
    }
}
