//
//  InfoBoxView.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 16/04/2021.
//

import Foundation
import UIKit
import Masonry


class InfoBoxView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customInit()
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    var descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private func customInit() {
        
        self.backgroundColor = .clear
        
        self.addSubview(titleLabel)
        self.addSubview(descLabel)
        
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(self.mas_top)?.with()?.offset()(10)
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-10)
        }
        
        descLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-10)
            make?.top.equalTo()(titleLabel.mas_bottom)?.with()?.offset()(2)
            make?.bottom.equalTo()(self.mas_bottom)?.with()?.offset()(-15)
        }
        
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(hexString: "#E5E5E6").cgColor
    }
    
    // Setters
    
    public func setInfoBox(_ title: String, desc: String) {
        self.titleLabel.text = title
        self.descLabel.text = desc
    }
}
