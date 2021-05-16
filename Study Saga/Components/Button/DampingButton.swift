//
//  DampingButton.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/1/21.
//

import Foundation
import UIKit

class DampingButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    func initialize() {
        self.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(buttonTouchUp),
                       for: [.touchUpInside, .touchUpOutside, .touchDragOutside, .touchCancel])
    }
    
    @objc func buttonTouchDown() {
        self.performAnimations {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc func buttonTouchUp() {
        if self.transform != .identity {
            self.performAnimations {
                self.transform = .identity
            }
        } else {
            self.performAnimations({
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            duration: 0.2) { finished in
                self.performAnimations({
                    self.transform = .identity
                }, duration: 0.4)
            }
        }
    }
    
    func performAnimations(
        _ animations: @escaping () -> Void,
        duration: TimeInterval = 0.4,
        completion: ((_ finished: Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [],
            animations: animations,
            completion: completion
        )
    }
}
