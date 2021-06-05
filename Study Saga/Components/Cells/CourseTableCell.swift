//
//  CourseTableCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/4/21.
//

import Foundation
import UIKit
import Combine
import AlamofireImage
import SkeletonView

class CourseTableCell: UITableViewCell {
    
    let kHorizontalPadding: CGFloat = 20
    
    static let reuseId = "CourseTableCellReuseId"
    
    var model: Course? {
        didSet {
            if let course = self.model {
                if let url = URL(string: course.courseImageUrl) {
                    self.courseImageView.af.setImage(withURL: url)
                }
                
                self.courseNameLabel.text = course.subjectName
                self.teacherNameLabel.text = "\(course.teacherName)"
                self.lessonLabel.text = "12 tiết"
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
    
    var isLoading: Bool = false {
        didSet {
            if self.isLoading {
                self.contentView.backgroundColor = .selectedBackground
                self.container.backgroundColor = .selectedBackground
            } else {
                self.contentView.backgroundColor = .white
                self.container.backgroundColor = .white
            }
        }
    }
    
    var courseImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var courseNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()
    
    var teacherIconView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "teacher")?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .darkGray
        return imgView
    }()
    
    var teacherNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    var lessonIconView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "book.closed")
        imgView.tintColor = .darkGray
        return imgView
    }()
    
    var lessonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var stateView = MiniStateView()
    
    private func customInit() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.setSkeletonable(true)
        
        self.contentView.addSubview(container)
        container.mas_makeConstraints { make in
            make?.top.equalTo()(self.contentView.mas_top)?.with()?.offset()(5)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.with()?.offset()(-10)
            make?.leading.equalTo()(self.contentView.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.with()?.offset()(-10)
        }
        
        container.addSubview(courseImageView)
        courseImageView.layer.masksToBounds = true
        courseImageView.mas_makeConstraints { make in
            make?.top.equalTo()(container.mas_top)?.with()?.offset()(10)
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-10)
            make?.height.equalTo()(150)
        }
        
        container.addSubview(courseNameLabel)
        courseNameLabel.mas_makeConstraints { make in
            make?.top.equalTo()(courseImageView.mas_bottom)?.with()?.offset()(10)
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(kHorizontalPadding)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-kHorizontalPadding)
        }
        
        container.addSubview(teacherIconView)
        teacherIconView.mas_makeConstraints { make in
            make?.top.equalTo()(courseNameLabel.mas_bottom)?.with()?.offset()(10)
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(kHorizontalPadding)
            make?.size.equalTo()(18)
        }
        
        container.addSubview(teacherNameLabel)
        teacherNameLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(teacherIconView.mas_centerY)
            make?.leading.equalTo()(teacherIconView.mas_trailing)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-kHorizontalPadding)
        }
        
        container.addSubview(lessonIconView)
        lessonIconView.mas_makeConstraints { make in
            make?.top.equalTo()(teacherIconView.mas_bottom)?.with()?.offset()(5)
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(kHorizontalPadding)
            make?.bottom.equalTo()(container.mas_bottom)?.with()?.offset()(-10)
            make?.size.equalTo()(18)
        }
        
        container.addSubview(lessonLabel)
        lessonLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(lessonIconView.mas_centerY)
            make?.leading.equalTo()(lessonIconView.mas_trailing)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-kHorizontalPadding)
        }
        
        courseImageView.addSubview(stateView)
        stateView.setStateViewWith("Đang học", iconColor: .systemGreen)
        stateView.backgroundColor = .white
        stateView.mas_makeConstraints { make in
            make?.height.equalTo()(35)
            make?.leading.equalTo()(courseImageView.mas_leading)?.with()?.offset()(10)
            make?.bottom.equalTo()(courseImageView.mas_bottom)?.with()?.offset()(-10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.container.layer.masksToBounds = true
        self.container.layer.cornerRadius = 20
        
        self.courseImageView.clipsToBounds = true
        self.courseImageView.layer.cornerRadius = 20
    }
    
    func setSkeletonable(_ isSkeletonalbe: Bool) {
        self.isSkeletonable = isSkeletonalbe
        self.contentView.isSkeletonable = isSkeletonalbe
        self.container.isSkeletonable = isSkeletonalbe
        self.courseImageView.isSkeletonable = isSkeletonalbe
        self.courseNameLabel.isSkeletonable = isSkeletonalbe
        self.lessonLabel.isSkeletonable = isSkeletonalbe
        self.teacherNameLabel.isSkeletonable = isSkeletonalbe
        self.lessonIconView.isSkeletonable = isSkeletonalbe
        self.teacherIconView.isSkeletonable = isSkeletonalbe
    }
}
