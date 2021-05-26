//
//  NotificationCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/9/21.
//

import Foundation
import UIKit
import Combine
import Masonry

class NotificationCell: UITableViewCell {
    
    static let reuseId = "NotificationCellReuseId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let horizontalPadding: CGFloat = 20
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.numberOfLines = .max
        return label
    }()
    
    var teacherNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    var teacherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "teacher")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .primary
        return imageView
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    var dateIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "time")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .primary
        return imageView
    }()
    
    var model: Notification? {
        didSet {
            if let noti = self.model {
                self.titleLabel.text = noti.content
                if noti.fromTeacherName.isEmpty {
                    self.teacherNameLabel.text = "PGS. TS Trần Minh Triết"
                } else {
                    self.teacherNameLabel.text = noti.fromTeacherName
                }
                self.dateLabel.text = .nearDateFormat(timeInterval: noti.time)
            }
        }
    }
    
    private func customInit() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(teacherIcon)
        container.addSubview(teacherNameLabel)
        container.addSubview(dateIcon)
        container.addSubview(dateLabel)
        
        container.backgroundColor = UIColor.appGray
        container.mas_makeConstraints { make in
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(5)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-5)
            make?.top.equalTo()(self.mas_top)?.with()?.offset()(5)
            make?.bottom.equalTo()(self.mas_bottom)?.with()?.offset()(-5)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(horizontalPadding)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-horizontalPadding)
            make?.top.equalTo()(container.mas_top)?.with()?.offset()(15)
        }
        
        teacherIcon.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(horizontalPadding)
            make?.top.equalTo()(titleLabel.mas_bottom)?.with()?.offset()(10)
            make?.size.equalTo()(15)
        }
        
        teacherNameLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(teacherIcon.mas_trailing)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-horizontalPadding)
            make?.centerY.equalTo()(teacherIcon.mas_centerY)
        }
        
        dateIcon.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(horizontalPadding)
            make?.top.equalTo()(teacherIcon.mas_bottom)?.with()?.offset()(10)
            make?.size.equalTo()(15)
            make?.bottom.equalTo()(container.mas_bottom)?.with()?.offset()(-15)
        }
        
        dateLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(dateIcon.mas_trailing)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-horizontalPadding)
            make?.centerY.equalTo()(dateIcon.mas_centerY)
        }
        
        container.layer.cornerRadius = 20
    }
}
