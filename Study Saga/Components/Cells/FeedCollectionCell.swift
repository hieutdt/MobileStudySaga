//
//  FeedCollectionCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 20/06/2021.
//

import Foundation
import UIKit
import Masonry


class FeedCollectionCell: UICollectionViewCell {
    
    static let reuseId = "FeedCollectionCellReuseId"
    
    var model: FeedModel? = nil {
        didSet {
            if let model = self.model {
                if let url = URL(string: model.thumb) {
                    self.thumbImgView.af.setImage(withURL: url)
                }
                self.label.text = model.title
                self.timeLabel.text = Date(timeIntervalSince1970: model.time)
                    .getFormattedDate(format: "HH:mm dd/MM/yyyy")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var thumbImgView = UIImageView()
    var label = UILabel()
    var timeLabel = UILabel()
    
    func customInit() {
        self.contentView.backgroundColor = .white
        
        thumbImgView.contentMode = .scaleAspectFill
        thumbImgView.backgroundColor = .selectedBackground
        self.contentView.addSubview(thumbImgView)
        thumbImgView.mas_makeConstraints { make in
            make?.leading.equalTo()(self.contentView.mas_leading)?.offset()(2)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.offset()(-2)
            make?.top.equalTo()(self.contentView.mas_top)
            make?.height.equalTo()(180)
        }
        
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        self.contentView.addSubview(label)
        label.mas_makeConstraints { make in
            make?.leading.equalTo()(self.contentView.mas_leading)
            make?.trailing.equalTo()(self.contentView.mas_trailing)
            make?.top.equalTo()(thumbImgView.mas_bottom)?.offset()(5)
        }
        
        timeLabel.numberOfLines = 1
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = .gray
        self.contentView.addSubview(timeLabel)
        timeLabel.mas_makeConstraints { make in
            make?.top.equalTo()(label.mas_bottom)?.offset()(5)
            make?.leading.equalTo()(self.contentView.mas_leading)
            make?.trailing.equalTo()(self.contentView.mas_trailing)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.thumbImgView.clipsToBounds = true
        self.thumbImgView.layer.cornerRadius = 10
    }
}
