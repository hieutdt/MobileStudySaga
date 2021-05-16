//
//  LessonCollectionCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/8/21.
//

import Foundation
import UIKit
import Combine
import Masonry


class LessonCollectionCell: UICollectionViewCell {
    
    static let reuseId = "LessonCollectionCellReuseId"
    
    init() {
        super.init(frame: .zero)
        self.customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Properties
    
    var container: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillEqually
        view.backgroundColor = .white
        view.spacing = 5
        return view
    }()
    
    var lessonNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    var lessonNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.textColor = .black
        return label
    }()
    
    var teacherNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    var joinClassLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemGreen
        label.text = "Tham gia học ngay >"
        return label
    }()
    
    // MARK: - View Model
    
    var model: Lesson? {
        didSet {
            if let model = self.model {
                self.lessonNameLabel.text = model.lessonName
                self.lessonNumberLabel.text = "Buổi \(model.lessonNumber)"
                self.teacherNameLabel.text = model.teacherName
            }
        }
    }
    
    private func customInit() {
        
        self.addSubview(container)
        container.mas_makeConstraints { make in
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-10)
            make?.top.equalTo()(self.mas_top)?.with()?.offset()(5)
            make?.bottom.equalTo()(self.mas_bottom)?.with()?.offset()(-5)
        }
        
        container.addArrangedSubview(lessonNumberLabel)
        lessonNumberLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-10)
        }
        
        container.addArrangedSubview(lessonNameLabel)
        lessonNameLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-10)
        }
        
        container.addArrangedSubview(teacherNameLabel)
        teacherNameLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-10)
        }
        
        container.addArrangedSubview(joinClassLabel)
        joinClassLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        self.contentView.layer.cornerRadius = 10
//        self.contentView.layer.masksToBounds = true
//
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 1)
//        self.layer.shadowRadius = 1
//        self.layer.shadowOpacity = 0.5
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(
//            roundedRect: self.bounds,
//            cornerRadius: self.contentView.layer.cornerRadius)
//            .cgPath
    }
}
