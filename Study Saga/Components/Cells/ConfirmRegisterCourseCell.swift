//
//  ConfirmRegisterCourseCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 12/04/2021.
//

import Foundation
import UIKit
import Masonry
import SkeletonView


protocol ConfirmRegisterCourseCellDelegate: NSObject {
    
    func didSelectCell(_ cell: ConfirmRegisterCourseCell)
}


class ConfirmRegisterCourseCell: UITableViewCell {
    
    static let reuseId = "ConfirmRegisterCourseCellReuseID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: ConfirmRegisterCourseCellDelegate?
    
    var container = UIButton()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()
    
    var descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    var waitingLabel = UILabel()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        stackView.spacing = 5
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    var stackViewTrailing: NSLayoutConstraint? = nil
    
    var isConfirm: Bool = false {
        didSet {
            self.waitingLabel.isHidden = isConfirm
            if isConfirm {
                self.stackViewTrailing?.constant = -10
            } else {
                self.stackViewTrailing?.constant = -100
            }
        }
    }
    
    var course: Course? {
        didSet {
            if let course = self.course {
                self.titleLabel.text = course.className
                self.descLabel.text = course.teacherName
            }
        }
    }
    
    func customInit() {
        
        self.activateSkeleton()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(container)
        container.addSubview(stackView)
        container.addSubview(waitingLabel)
        
        container.backgroundColor = .white
        container.setBackgroundColor(color: .white, forState: .normal)
        container.setBackgroundColor(color: .selectedBackground, forState: .highlighted)
        container.addTarget(self, action: #selector(didSelectCell), for: .touchUpInside)
        container.mas_makeConstraints { make in
            make?.leading.equalTo()(self.contentView.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.with()?.offset()(-10)
            make?.top.equalTo()(self.contentView.mas_top)?.with()?.offset()(2)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.with()?.offset()(-2)
        }
        
        stackView.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(20)
            make?.top.equalTo()(container.mas_top)?.with()?.offset()(20)
            make?.bottom.equalTo()(container.mas_bottom)?.with()?.offset()(-20)
        }
        self.stackViewTrailing = stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        self.stackViewTrailing?.isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descLabel)
        
        titleLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(stackView.mas_leading)
            make?.trailing.equalTo()(stackView.mas_trailing)
        }
        
        descLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(stackView.mas_leading)
            make?.trailing.equalTo()(stackView.mas_trailing)
        }
        
        waitingLabel.text = "Chờ xác nhận"
        waitingLabel.textColor = .systemYellow
        waitingLabel.isHidden = true
        waitingLabel.font = .boldSystemFont(ofSize: 13)
        waitingLabel.mas_makeConstraints { make in
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-10)
            make?.centerY.equalTo()(container.mas_centerY)  
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.container.layer.cornerRadius = 10
    }
    
    func activateSkeleton() {
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        self.container.isSkeletonable = true
        self.stackView.isSkeletonable = true
        self.titleLabel.isSkeletonable = true
        self.descLabel.isSkeletonable = true
        self.waitingLabel.isSkeletonable = false
    }
    
    // MARK: - Action
    
    @objc func didSelectCell() {
        self.delegate?.didSelectCell(self)
    }
}
