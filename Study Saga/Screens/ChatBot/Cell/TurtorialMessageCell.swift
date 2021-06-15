//
//  TurtorialMessageCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 15/06/2021.
//

import Foundation
import UIKit
import Combine
import Masonry


class TutorialMessageCell: UITableViewCell {
    
    static let reuseId = "TurtorialMessageCellReuseId"
    
    var avatarImgView = UIImageView()
    var titleLabel = UILabel()
    var descLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customInit()
        self.contentView.transform = CGAffineTransform(scaleX: -1, y: -1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(avatarImgView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descLabel)
        
        avatarImgView.image = UIImage(named: "chatbot")
        avatarImgView.mas_makeConstraints { make in
            make?.top.equalTo()(self.contentView.mas_top)?.offset()(10)
            make?.size.equalTo()(100)
            make?.centerX.equalTo()(self.contentView.mas_centerX)
        }
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.text = "Chào mừng bạn đã đến với Chatbot hỗ trợ học tập"
        titleLabel.numberOfLines = 10
        titleLabel.textAlignment = .center
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(avatarImgView.mas_bottom)?.offset()(5)
            make?.leading.equalTo()(self.contentView.mas_leading)?.offset()(30)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.offset()(-30)
        }
        
        descLabel.font = .systemFont(ofSize: 12)
        descLabel.numberOfLines = 10
        descLabel.textColor = .darkGray
        descLabel.textAlignment = .center
        descLabel.text = "Đây là nơi mà bạn có thể đặt câu hỏi và Chatbot của chúng tôi sẽ thay mặt Giáo vụ khoa trả lời cho bạn. Nhưng câu hỏi mà Chatbot của chúng tôi chưa thể trả lời được sẽ tự động chuyển cho Giáo vụ khoa trả lời."
        descLabel.mas_makeConstraints { make in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(5)
            make?.leading.equalTo()(self.contentView.mas_leading)?.offset()(20)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.offset()(-20)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.offset()(-25)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarImgView.clipsToBounds = true
        self.avatarImgView.layer.cornerRadius = 50
    }
}
