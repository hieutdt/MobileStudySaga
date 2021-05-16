//
//  BaseButton.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/1/21.
//

import Foundation
import UIKit
import Masonry

class BaseButton: UIButton {
    
    // MARK: - UI components
    
    private var iconImgView = UIImageView()
    
    private var titleLbl: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private var descLbl: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private var nextImgView: UIImageView = {
        let imgView = UIImageView()
        let image = UIImage(named: "right_arrow")?.withRenderingMode(.alwaysTemplate)
        imgView.image = image
        imgView.tintColor = .lightGray
        return imgView
    }()
    
    private var hMainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = false
        stackView.backgroundColor = .clear
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private var vTitleStack: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = false
        stackView.backgroundColor = .clear
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        line.alpha = 0.15
        return line
    }()
    
    private var buttonAction: () -> Void = {}
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    private func initialize() {
        
        self.backgroundColor = .white
        
        // Set up UI
        self.addSubview(hMainStack)
        hMainStack.mas_makeConstraints { make in
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-10)
            make?.top.equalTo()(self.mas_top)?.with()?.offset()(2)
            make?.bottom.equalTo()(self.mas_bottom)?.with()?.offset()(-2)
        }
        
        self.addSubview(bottomLine)
        bottomLine.mas_makeConstraints { make in
            make?.bottom.equalTo()(self.mas_bottom)
            make?.height.equalTo()(0.8)
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(30)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-30)
        }
        
        hMainStack.addArrangedSubview(iconImgView)
        iconImgView.tintColor = .primary
        iconImgView.mas_makeConstraints { make in
            make?.leading.equalTo()(hMainStack.mas_leading)?.with()?.offset()(20)
            make?.size.equalTo()(22)
        }
        
        hMainStack.addArrangedSubview(vTitleStack)
        vTitleStack.mas_makeConstraints { make in
            make?.top.equalTo()(hMainStack.mas_top)
            make?.bottom.equalTo()(hMainStack.mas_bottom)
        }
        
        hMainStack.addArrangedSubview(nextImgView)
        nextImgView.mas_makeConstraints { make in
            make?.size.equalTo()(15)
            make?.trailing.equalTo()(hMainStack.mas_trailing)?.offset()(-20)
        }
        
        vTitleStack.addArrangedSubview(titleLbl)
        titleLbl.mas_makeConstraints { make in
            make?.leading.equalTo()(vTitleStack.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(vTitleStack.mas_trailing)?.with()?.offset()(-10)
        }
        
        vTitleStack.addArrangedSubview(descLbl)
        descLbl.mas_makeConstraints { make in
            make?.leading.equalTo()(vTitleStack.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(vTitleStack.mas_trailing)?.with()?.offset()(-10)
        }
        
        // Action handle
        self.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
    }
    
    // MARK: - Setters
    
    public func setButton(title: String!,
                          desc: String? = nil,
                          iconName: String? = nil,
                          showNext: Bool = false,
                          showLine: Bool = true,
                          action: @escaping () -> Void) {
        
        self.titleLbl.text = title
        self.titleLbl.show()
        
        if let desc = desc  {
            self.descLbl.text = desc
            self.descLbl.show()
        } else {
            self.descLbl.hide()
        }
        
        if let iconName = iconName {
            self.iconImgView.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
            self.iconImgView.show()
        } else {
            self.iconImgView.hide()
        }
        
        self.nextImgView.isHidden = !showNext
        self.bottomLine.isHidden = !showLine
        self.buttonAction = action
    }
    
    public func setStyle(isDestructive: Bool) {
        if isDestructive {
            self.iconImgView.tintColor = .secondary
            self.titleLbl.textColor = .secondary
        } else {
            self.iconImgView.tintColor = .black
            self.titleLbl.textColor = .black
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            // Smooth change color.
            if isHighlighted {
                UIView.animate(withDuration: 0.2) {
                    self.backgroundColor = .selectedBackground
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.backgroundColor = .white
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func buttonTouchUpInside() {
        self.buttonAction()
    }
}
