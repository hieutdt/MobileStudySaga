//
//  StateView.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/30/21.
//

import Foundation
import UIKit
import Masonry


class StateView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customInit()
    }
    
    let container = UIView()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.contentMode = .center
        lbl.textAlignment = .center
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.textColor = .black
        return lbl
    }()
    
    let descLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 5
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.primary, for: .normal)
        btn.setTitleShadowColor(.black, for: .highlighted)
        return btn
    }()
    
    var buttonAction: (() -> Void)? = nil
    
    private func customInit() {
        
        self.backgroundColor = .clear
        self.container.backgroundColor = .clear
        
        // Add subviews.
        self.addSubview(container)
        container.addSubview(imageView)
        container.addSubview(titleLbl)
        container.addSubview(descLbl)
        container.addSubview(button)
        
        // Image View layouts.
        imageView.mas_makeConstraints { make in
            make?.top.equalTo()(container.mas_top)
            make?.centerX.equalTo()(container.mas_centerX)
            make?.size.equalTo()(120)
        }
        
        // Title label layouts.
        titleLbl.mas_makeConstraints { make in
            make?.top.equalTo()(imageView.mas_bottom)?.with()?.offset()(10)
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-10)
        }
        
        // Description label layouts.
        descLbl.mas_makeConstraints { make in
            make?.top.equalTo()(titleLbl.mas_bottom)?.with()?.offset()(6)
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-10)
        }
        
        // State button layouts.
        button.mas_makeConstraints { make in
            make?.top.equalTo()(descLbl.mas_bottom)?.with()?.offset()(10)
            make?.centerX.equalTo()(container.mas_centerX)
            make?.bottom.equalTo()(container.mas_bottom)
        }
        
        // Container layouts.
        container.mas_makeConstraints { make in
            make?.centerY.equalTo()(self.mas_centerY)
            make?.leading.equalTo()(self.mas_leading)
            make?.trailing.equalTo()(self.mas_trailing)
        }
    }
    
    // Setter.
    func setStateView(imageName: String,
                      title: String,
                      desc: String,
                      buttonTitle: String,
                      buttonAction: @escaping () -> Void) {
        
        self.imageView.image = UIImage(named: imageName)
        self.titleLbl.text = title
        self.descLbl.text = desc
        self.button.setTitle(buttonTitle, for: .normal)
        self.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.buttonAction = buttonAction
    }
    
    @objc func buttonTapped() {
        self.buttonAction?()
    }
}
