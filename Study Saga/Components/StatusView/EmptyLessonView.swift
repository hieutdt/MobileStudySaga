//
//  EmptyLessonView.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/26/21.
//

import Foundation
import UIKit
import Masonry

/// The empty view that will be showed if we don't have any coming lessons.
class EmptyLessonView: DampingButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customInit()
    }
    
    var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "study_bg")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var titleLbl: UILabel = {
        let label = UILabel()
        label.text = "Bạn không còn tiết học nào sắp đến."
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 3
        label.contentMode = .bottom
        return label
    }()
    
    var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Hãy dành thời gian để ôn tập hoặc thư giãn bạn nhé!"
        label.textColor = .lightText
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.contentMode = .top
        return label
    }()
    
    func customInit() {
        self.addSubview(imgView)
        self.addSubview(titleLbl)
        self.addSubview(descLabel)
        
        self.backgroundColor = .appBlack
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        imgView.contentMode = .scaleToFill
        imgView.image = UIImage(named: "learning_cover")
        imgView.mas_makeConstraints { make in
            make?.leading.equalTo()(self.mas_leading)
            make?.trailing.equalTo()(self.mas_trailing)
            make?.top.equalTo()(self.mas_top)
            make?.height.equalTo()(150)
        }
        
        titleLbl.textAlignment = .center
        titleLbl.mas_makeConstraints { make in
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-10)
            make?.top.equalTo()(imgView.mas_bottom)?.with()?.offset()(10)
        }
        
        descLabel.textAlignment = .center
        descLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-10)
            make?.bottom.equalTo()(self.mas_bottom)?.with()?.offset()(-20)
            make?.top.equalTo()(titleLbl.mas_bottom)?.with()?.offset()(5)
        }
    }
}
