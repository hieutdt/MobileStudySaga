//
//  MiniStateView.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 15/04/2021.
//

import Foundation
import UIKit
import Masonry
import Combine


class MiniStateView: UIView {
    
    var iconImgView = UIImageView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customInit()
    }
    
    private func customInit() {
        self.addSubview(iconImgView)
        self.addSubview(label)
        
        iconImgView.backgroundColor = .white
        iconImgView.mas_makeConstraints { make in
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(20)
            make?.centerY.equalTo()(self.mas_centerY)
            make?.size.equalTo()(10)
        }
        
        label.font = .systemFont(ofSize: 13)
        label.mas_makeConstraints { make in
            make?.leading.equalTo()(iconImgView.mas_trailing)?.with()?.offset()(6)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-20)
            make?.top.equalTo()(self.mas_top)
            make?.bottom.equalTo()(self.mas_bottom)
        }
        
        self.layer.cornerRadius = 20
    }
    
    // Public API
    
    func setStateViewWith(_ text: String, imageName: String) {
        self.label.text = text
        self.iconImgView.image = UIImage(named: imageName)
    }
    
    func setStateViewWith(_ text: String, iconColor: UIColor) {
        self.label.text = text
        self.iconImgView.image = nil
        self.iconImgView.backgroundColor = iconColor
    }
}
