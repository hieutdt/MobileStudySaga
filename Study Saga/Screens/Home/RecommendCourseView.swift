//
//  RecommendCourseView.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 12/06/2021.
//

import Foundation
import UIKit
import Masonry
import AlamofireImage

protocol RecommendCourseViewDelegate: NSObject {
    
    func didSelectMajor(_ major: Major)
}


class RecommendCourseView: UIView {
    
    var collectionView: UICollectionView!
    
    var courses: [Major] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    weak var delegate: RecommendCourseViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        
        self.isSkeletonable = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 260, height: 150)
        
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(RecommendMajorCell.self,
                                     forCellWithReuseIdentifier: RecommendMajorCell.reuseId)
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.addSubview(self.collectionView)
        self.collectionView.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
        }
    }
}

extension RecommendCourseView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendMajorCell.reuseId,
                for: indexPath) as? RecommendMajorCell else {
            fatalError()
        }
        
        cell.model = self.courses[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let major = self.courses[index]
        
        if let delegate = self.delegate {
            delegate.didSelectMajor(major)
        }
    }
}
