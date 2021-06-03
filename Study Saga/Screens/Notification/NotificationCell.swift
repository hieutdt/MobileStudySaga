//
//  NotificationCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 03/06/2021.
//

import Foundation
import UIKit


class NotificationCell: UITableViewCell {
    
    static var reuseId = "NotificationCellReuseId"
    
    var mainStackView = UIStackView()
    var thumbImageView = UIImageView()
    var courseNameLabel = UILabel()
    var contentLabel = UILabel()
    var teacherFooterLabel = UILabel()
    var timeFooterLabel = UILabel()
    
    var model: NotificationModel? {
        didSet {
            if let model = self.model {
                if let url = URL(string: model.thumbImgUrl) {
                    self.thumbImageView.af.setImage(withURL: url)
                }
                self.courseNameLabel.text = model.courseName
                self.contentLabel.text = model.content
                self.teacherFooterLabel.text = model.fromTeacherName
                self.timeFooterLabel.text = Date(timeIntervalSince1970: model.ts/1000)
                    .getFormattedDate(format: "hh:mm - dd/MM/yyyy")
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customInit() {
        
        thumbImageView.image = UIImage(named: "")
        thumbImageView.layer.cornerRadius = 15
        self.contentView.addSubview(thumbImageView)
        thumbImageView.mas_makeConstraints { make in
            make?.size.equalTo()(60)
            make?.centerY.equalTo()(self.contentView.mas_centerY)
            make?.leading.equalTo()(self.contentView.mas_leading)?.offset()(10)
        }
        
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.alignment = .center
        self.contentView.addSubview(mainStackView)
        mainStackView.mas_makeConstraints { make in
            make?.leading.equalTo()(thumbImageView.mas_trailing)?.offset()(5)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.offset()(-10)
            make?.top.equalTo()(self.contentView.mas_top)?.offset()(5)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.offset()(-5)
        }
        
        courseNameLabel.numberOfLines = 3
        courseNameLabel.font = .boldSystemFont(ofSize: 15)
        courseNameLabel.textColor = .black
        mainStackView.addArrangedSubview(courseNameLabel)
        
        contentLabel.numberOfLines = 10
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.textColor = .darkText
        mainStackView.addArrangedSubview(contentLabel)
        
        teacherFooterLabel.numberOfLines = 1
        teacherFooterLabel.font = .systemFont(ofSize: 12)
        teacherFooterLabel.textColor = .lightGray
        mainStackView.addArrangedSubview(contentLabel)
        
        timeFooterLabel.numberOfLines = 1
        timeFooterLabel.font = .systemFont(ofSize: 12)
        timeFooterLabel.textColor = .lightGray
        mainStackView.addArrangedSubview(timeFooterLabel)
    }
}
