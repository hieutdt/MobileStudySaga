//
//  DeadlineTableCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 2/27/21.
//

import Foundation
import UIKit
import Combine
import Masonry
import SkeletonView

protocol DeadlineTableCellDelegate: NSObject {
    
    func didSelectCell(_ cell: DeadlineTableCell)
}


class DeadlineTableCell: UITableViewCell {
    
    static let reuseId = "DeadlineTableCellReuseId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Properties
    
    var shadowView = ShadowView()
    var container = UIButton()
    var courseNameLabel = UILabel()
    var deadlineLabel = UILabel()
    var statusLabel = UILabel()
    var statusImageView = UIImageView()
    
    let horizontalMargin: CGFloat = 30
    let verticalMargin: CGFloat = 15
    
    // MARK: Data Model
    
    weak var delegate: DeadlineTableCellDelegate?
    
    var deadline: Deadline? {
        didSet {
            if let model = self.deadline {
                self.courseNameLabel.text = model.deadlineName
                self.deadlineLabel.text = "Hạn chót: " + .fullDateFormat(timeInterval: model.timeEnd)
                if model.isSubmitted {
                    self.statusLabel.text = "Đã hoàn thành"
                    self.statusLabel.textColor = .success
                    self.statusImageView.image = UIImage(named: "checked")
                } else {
                    self.statusLabel.text = "Chưa hoàn thành"
                    self.statusLabel.textColor = .primary
                    self.statusImageView.image = UIImage(named: "circle_solid")?
                        .withRenderingMode(.alwaysTemplate)
                    self.statusImageView.tintColor = .primary
                }
            }
        }
    }
    
    private func customInit() {
        
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        container.isSkeletonable = true
        
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        
        self.contentView.addSubview(shadowView)
        
        self.contentView.addSubview(container)
        container.addSubview(courseNameLabel)
        container.addSubview(deadlineLabel)
        container.addSubview(statusImageView)
        container.addSubview(statusLabel)
        
        // Activate skeleton
        courseNameLabel.isSkeletonable = true
        deadlineLabel.isSkeletonable = true
        statusImageView.isSkeletonable = true
        statusLabel.isSkeletonable = true
        
        // Shadow
        shadowView.mas_makeConstraints { make in
            make?.top.equalTo()(self.contentView.mas_top)?.with()?.offset()(5)
            make?.leading.equalTo()(self.contentView.mas_leading)?.with()?.offset()(5)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.with()?.offset()(-5)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.with()?.offset()(-5)
        }
        shadowView.hide()
        
        // Container
        container.backgroundColor = .lightGray
        container.setBackgroundColor(color: UIColor(hexString: "#F3F3F4"), forState: .normal)
        container.setBackgroundColor(color: UIColor(hexString: "#E4E4E5"), forState: .highlighted)
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 20
        container.addTarget(self, action: #selector(didSelectCell), for: .touchUpInside)
        container.mas_makeConstraints { make in
            make?.top.equalTo()(self.contentView.mas_top)?.with()?.offset()(5)
            make?.leading.equalTo()(self.contentView.mas_leading)?.with()?.offset()(5)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.with()?.offset()(-5)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.with()?.offset()(-5)
        }
        
        // Course name label
        courseNameLabel.textColor = .black
        courseNameLabel.font = .boldSystemFont(ofSize: 16)
        courseNameLabel.textAlignment = .left
        courseNameLabel.isUserInteractionEnabled = false
        courseNameLabel.mas_makeConstraints { make in
            make?.top.equalTo()(container.mas_top)?.with()?.offset()(verticalMargin)
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(horizontalMargin)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-horizontalMargin)
        }
        
        // Deadline date label
        deadlineLabel.textColor = .gray
        deadlineLabel.font = .systemFont(ofSize: 13)
        deadlineLabel.textAlignment = .left
        deadlineLabel.isUserInteractionEnabled = false
        deadlineLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(horizontalMargin)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-horizontalMargin)
            make?.top.equalTo()(courseNameLabel.mas_bottom)?.with()?.offset()(5)
        }
        
        // Status image icon
        statusImageView.isUserInteractionEnabled = false
        statusImageView.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(horizontalMargin)
            make?.size.equalTo()(20)
            make?.bottom.equalTo()(container.mas_bottom)?.with()?.offset()(-verticalMargin)
            make?.top.equalTo()(deadlineLabel.mas_bottom)?.with()?.offset()(5)
        }
                
        // Status label
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.isUserInteractionEnabled = false
        statusLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(statusImageView.mas_trailing)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-horizontalMargin)
            make?.centerY.equalTo()(statusImageView.mas_centerY)
        }
    }
    
    @objc func didSelectCell() {
        self.delegate?.didSelectCell(self)
    }
}

