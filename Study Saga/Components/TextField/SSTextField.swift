//
//  SSTextField.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/11/21.
//

import Foundation
import UIKit
import Combine


class SSTextField: UITextField {
    
    var hint: String = ""
    
    var lblHint = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.config()
    }
    
    private func config() {
        self.lblHint.font = .systemFont(ofSize: 12)
        self.normalState()
    }
    
    override func becomeFirstResponder() -> Bool {
        if !self.isFirstResponder {
            self.focusState()
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.normalState()
        return super.resignFirstResponder()
    }
    
    func clean() {
        self.lblHint.text = self.hint
        self.lblHint.textColor = .primary
    }
    
    func normalState() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.clean()
    }
    
    func focusState() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 1
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
        self.clean()
    }
    
    func errorState() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.systemRed.cgColor
        self.layer.borderWidth = 1
    }
    
    func errorBy(msg: NSString, on view: UIView) {
        if self.lblHint.superview != view {
            view.addSubview(self.lblHint)
        }
        
        self.lblHint.translatesAutoresizingMaskIntoConstraints = false
        self.lblHint.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        self.lblHint.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2).isActive = true
        self.lblHint.text = "ⓘ \(msg)"
        self.lblHint.textColor = UIColor.systemRed
        self.lblHint.sizeToFit()
        self.errorState()
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= 4
        return textRect
    }
}
