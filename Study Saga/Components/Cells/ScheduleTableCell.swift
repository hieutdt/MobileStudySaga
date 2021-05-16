//
//  ScheduleTableCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/3/21.
//

import Foundation
import UIKit
import Combine
import AlamofireImage
import SkeletonView

class ScheduleTableCell: UITableViewCell {
    
    static let reuseId = "ScheduleTableCellReuseId"
    
    var model: Lesson? {
        didSet {
            if let model = model {
                self.timeLabel.text = .nearDateFormat(timeInterval: model.dateStart)
                self.classNameLabel.text = model.lessonName
                self.courseNameLabel.text = model.courseName
                self.teacherNameLabel.text = model.teacherName
                
                if let url = URL(string: model.avatarUrl) {
                    self.classImageView.af.setImage(withURL: url)
                } else {
                    self.classImageView.image = UIImage(named: "online-interview")
                }
                
//                if model.isOnline {
//                    self.classImageView.image = UIImage(named: "online-interview")
//                } else {
//                    self.classImageView.image = UIImage(named: "school")
//                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    var timeLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "34C8BF")
        view.alpha = 0.6
        return view
    }()
    
    var onLearningIcon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .center
        view.image = UIImage(named: "dot")
        return view
    }()
    
    var timeLabel: UILabel  = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    var classContainerButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(color: .white, forState: .normal)
        button.setBackgroundColor(color: .selectedBackground, forState: .highlighted)
        return button
    }()
    
    var classImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .selectedBackground
        return imageView
    }()
    
    var courseNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    var classNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    var teacherNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textColor = .darkGray
        return label
    }()
    
    var joinImgView: UIImageView = {
        let imageview = UIImageView()
        return imageview
    }()
    
    var isNearestClass: Bool = false {
        didSet {
            if isNearestClass {
                self.onLearningIcon.image = UIImage(named: "dot_2")
                self.timeLabel.font = .boldSystemFont(ofSize: 15)
                self.timeLabel.textColor = .black
                self.classNameLabel.font = .boldSystemFont(ofSize: 14)
                self.courseNameLabel.font = .boldSystemFont(ofSize: 15)
                self.classContainerButton.layer.borderWidth = 2
                self.classContainerButton.layer.borderColor = UIColor.systemBlue.cgColor
                
            } else {
                self.onLearningIcon.image = UIImage(named: "dot")
                self.timeLabel.font = .systemFont(ofSize: 14)
                self.timeLabel.textColor = .gray
                self.classNameLabel.font = .systemFont(ofSize: 14)
                self.courseNameLabel.font = .systemFont(ofSize: 15)
                self.classContainerButton.layer.borderWidth = 0
            }
        }
    }
    
    override func prepareForReuse() {
        self.isNearestClass = false
    }

    // MARK: - Initialize
    
    private func customInit() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        self.timeLine.isSkeletonable = true
        self.onLearningIcon.isSkeletonable = true
        self.timeLabel.isSkeletonable = false
        self.classContainerButton.isSkeletonable = true
        self.classNameLabel.isSkeletonable = true
        self.teacherNameLabel.isSkeletonable = true
        self.classImageView.isSkeletonable = true
        
        //-------------------------------------------------------
        //  Time Line
        //-------------------------------------------------------
        self.contentView.addSubview(timeLine)
        timeLine.mas_makeConstraints { make in
            make?.top.equalTo()(self.contentView.mas_top)
            make?.bottom.equalTo()(self.contentView.mas_bottom)
            make?.leading.equalTo()(self.contentView.mas_leading)?.with()?.offset()(30)
            make?.width.equalTo()(1)
        }
        
        //-------------------------------------------------------
        //  On Learning Icon
        //-------------------------------------------------------
        self.contentView.addSubview(onLearningIcon)
        onLearningIcon.mas_makeConstraints { make in
            make?.centerX.equalTo()(timeLine.mas_centerX)
            make?.size.equalTo()(20)
        }
        
        //-------------------------------------------------------
        //  Time Label
        //-------------------------------------------------------
        self.contentView.addSubview(timeLabel)
        timeLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(onLearningIcon.mas_trailing)?.with()?.offset()(15)
            make?.top.equalTo()(self.contentView.mas_top)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.contentView.mas_trailing)
            make?.centerY.equalTo()(onLearningIcon.mas_centerY)
        }
        
        //-------------------------------------------------------
        //  Class Container
        //-------------------------------------------------------
        self.contentView.addSubview(classContainerButton)
        classContainerButton.mas_makeConstraints { make in
            make?.top.equalTo()(timeLabel.mas_bottom)?.with()?.offset()(10)
            make?.leading.equalTo()(timeLine.mas_trailing)?.with()?.offset()(20)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.with()?.offset()(-30)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.with()?.offset()(-20)
        }
        
        //-------------------------------------------------------
        //  Class Image View
        //-------------------------------------------------------
        classContainerButton.addSubview(classImageView)
        classImageView.mas_makeConstraints { make in
            make?.leading.equalTo()(classContainerButton.mas_leading)?.with()?.offset()(30)
            make?.centerY.equalTo()(classContainerButton.mas_centerY)
            make?.size.equalTo()(45)
        }
        
        //-------------------------------------------------------
        //  Course Name Label
        //-------------------------------------------------------
        classContainerButton.addSubview(courseNameLabel)
        courseNameLabel.mas_makeConstraints { make in
            make?.top.equalTo()(classContainerButton.mas_top)?.with()?.offset()(25)
            make?.leading.equalTo()(classImageView.mas_trailing)?.with()?.offset()(15)
            make?.trailing.equalTo()(classContainerButton.mas_trailing)?.with()?.offset()(-20)
        }
        
        //-------------------------------------------------------
        //  Class Name Label
        //-------------------------------------------------------
        classContainerButton.addSubview(classNameLabel)
        classNameLabel.mas_makeConstraints { make in
            make?.top.equalTo()(courseNameLabel.mas_bottom)?.with()?.offset()(5)
            make?.leading.equalTo()(classImageView.mas_trailing)?.with()?.offset()(15)
            make?.trailing.equalTo()(classContainerButton.mas_trailing)?.with()?.offset()(-20)
        }
        
        //-------------------------------------------------------
        //  Teacher Name Label
        //-------------------------------------------------------
        classContainerButton.addSubview(teacherNameLabel)
        teacherNameLabel.mas_makeConstraints { make in
            make?.top.equalTo()(classNameLabel.mas_bottom)?.with()?.offset()(5)
            make?.leading.equalTo()(classImageView.mas_trailing)?.with()?.offset()(15)
            make?.trailing.equalTo()(classContainerButton.mas_trailing)?.with()?.offset()(-15)
            make?.bottom.equalTo()(classContainerButton.mas_bottom)?.with()?.offset()(-25)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        classImageView.layer.cornerRadius = 15
        classImageView.clipsToBounds = true
        classContainerButton.layer.cornerRadius = 25
    }
}
