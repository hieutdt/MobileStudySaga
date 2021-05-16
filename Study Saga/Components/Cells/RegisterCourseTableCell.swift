//
//  RegisterCourseTableCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 4/8/21.
//

import Foundation
import UIKit
import Masonry
import Combine
import AlamofireImage
import SkeletonView


protocol RegisterCourseTableCellDelegate: NSObject {
    
    func didSelectedCell(_ cell: RegisterCourseTableCell)
}

class RegisterCourseTableCell: UITableViewCell {
    
    static let reuseId = "RegisterCourseTableCellReuseId"
    
    weak var delegate: RegisterCourseTableCellDelegate? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var course: Course? {
        didSet {
            if let course = self.course {
                if let url = URL(string: course.courseImageUrl) {
                    self.courseImageView.af.setImage(
                        withURL: url,
                        filter: RoundedCornersFilter(radius: 20)
                    )
                    self.courseNameLabel.text = course.className
                    self.teacherNameLabel.text = "GV: \(course.teacherName)"
                    self.creditsLabel.text = "Số tín chỉ: 5"
                }
            }
        }
    }
    
    var isChoosen: Bool = false {
        didSet {
            if isChoosen {
                let selectedColor = UIColor(hexString: "#D1F2EB")
                self.container.setBackgroundColor(color: selectedColor, forState: .normal)
            } else {
                self.container.setBackgroundColor(color: .white, forState: .normal)
                self.container.layer.borderWidth = 0
            }
        }
    }
    
    var container = UIButton()
    
    var courseImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .darkGray
        return imgView
    }()
    
    var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    var courseNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        lbl.numberOfLines = 3
        return lbl
    }()
    
    var teacherNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .darkGray
        lbl.numberOfLines = 3
        return lbl
    }()
    
    var creditsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .darkGray
        return lbl
    }()
    
    private func customInit() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        self.labelStackView.isUserInteractionEnabled = false
        self.courseImageView.isUserInteractionEnabled = false
        
        activateSkeleton()
        
        self.contentView.addSubview(container)
        container.addSubview(courseImageView)
        container.addSubview(labelStackView)
        
        container.layer.cornerRadius = 10
        container.setBackgroundColor(color: .white, forState: .normal)
        container.setBackgroundColor(color: .selectedBackground, forState: .highlighted)
        container.addTarget(self, action: #selector(didSelectCell), for: .touchUpInside)
        container.mas_makeConstraints { make in
            make?.leading.equalTo()(self.contentView.mas_leading)?.with()?.inset()(0)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.with()?.inset()(0)
            make?.top.equalTo()(self.contentView.mas_top)?.with()?.inset()(6)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.with()?.inset()(6)
        }
        
        courseImageView.backgroundColor = .white
        courseImageView.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(20)
            make?.top.equalTo()(container.mas_top)?.with()?.inset()(10)
            make?.bottom.equalTo()(container.mas_bottom)?.with()?.inset()(10)
            make?.width.equalTo()(120)
            make?.height.equalTo()(100)
        }
        
        labelStackView.mas_makeConstraints { make in
            make?.leading.equalTo()(courseImageView.mas_trailing)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.inset()(20)
            make?.top.equalTo()(container.mas_top)?.with()?.inset()(10)
            make?.bottom.equalTo()(container.mas_bottom)?.with()?.inset()(10)
        }
        
        labelStackView.addArrangedSubview(courseNameLabel)
        labelStackView.addArrangedSubview(teacherNameLabel)
        labelStackView.addArrangedSubview(creditsLabel)
        
        courseNameLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(labelStackView.mas_leading)
            make?.trailing.equalTo()(labelStackView.mas_trailing)
        }
        
        teacherNameLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(labelStackView.mas_leading)
            make?.trailing.equalTo()(labelStackView.mas_trailing)
        }
        
        creditsLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(labelStackView.mas_leading)
            make?.trailing.equalTo()(labelStackView.mas_trailing)
        }
    }
    
    func activateSkeleton() {
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        self.container.isSkeletonable = true
        self.courseImageView.isSkeletonable = true
        self.labelStackView.isSkeletonable = true
        self.courseNameLabel.isSkeletonable = true
        self.teacherNameLabel.isSkeletonable = true
        self.creditsLabel.isSkeletonable = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.courseImageView.layer.cornerRadius = 10
        self.courseImageView.clipsToBounds = true
        self.container.layer.cornerRadius = 10
    }
    
    // MARK: - Action
    
    @objc func didSelectCell() {
        self.delegate?.didSelectedCell(self)
    }
}
