//
//  RecommendTableCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 13/06/2021.
//

import Foundation
import UIKit
import AlamofireImage
import Masonry


class RecommendTableCell: UITableViewCell {
    
    static let reuseId = "RecommendTableCellReuseId"
    
    var model: Subject? {
        didSet {
            if let model = self.model {
                self.titleLabel.text = model.name
                if model.isLearned {
                    self.checkIconImage.image = UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
                    self.checkIconImage.tintColor = .primary
                } else {
                    self.checkIconImage.image = UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate)
                    self.checkIconImage.tintColor = .lightGray
                }
            }
        }
    }
    
    var checkIconImage = UIImageView()
    var titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        self.contentView.addSubview(checkIconImage)
        self.contentView.addSubview(titleLabel)
        
        checkIconImage.mas_makeConstraints { make in
            make?.leading.equalTo()(self.contentView.mas_leading)?.offset()(10)
            make?.centerY.equalTo()(self.contentView.mas_centerY)
            make?.size.equalTo()(30)
        }
        
        titleLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 16)
        titleLabel.numberOfLines = 3
        titleLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(checkIconImage.mas_trailing)?.offset()(20)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.offset()(-10)
            make?.centerY.equalTo()(checkIconImage.mas_centerY)
        }
    }
}
