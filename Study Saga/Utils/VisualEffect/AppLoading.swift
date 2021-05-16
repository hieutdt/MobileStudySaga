//
//  AppLoading.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/2/21.
//

import Foundation
import UIKit
import SVProgressHUD
import Combine


class AppLoading: NSObject {
    
    static func showLoading(with text: String? = nil,
                            viewController: UIViewController) {
        
        SVProgressHUD.setForegroundColor(.primary)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setContainerView(viewController.view)
        SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
        
        SVProgressHUD.show(withStatus: text)
    }
    
    static func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    static func showSuccess(with text: String? = nil,
                            viewController: UIViewController) {
        
        SVProgressHUD.showSuccess(withStatus: text)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SVProgressHUD.dismiss()
        }
    }
    
    static func showFailed(with text: String? = nil,
                           viewController: UIViewController) {
        
        SVProgressHUD.showError(withStatus: text)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SVProgressHUD.dismiss()
        }
    }
}
