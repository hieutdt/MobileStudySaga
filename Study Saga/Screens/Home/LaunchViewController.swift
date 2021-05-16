//
//  LaunchViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/23/21.
//

import Foundation
import UIKit
import Combine
import Masonry

class LaunchViewController: UIViewController {
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "STUDY SAGA"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.validateTokenAndUpdateScreen()
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .primary
        self.view.addSubview(appNameLabel)
        appNameLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)?.with()?.offset()(30)
            make?.trailing.equalTo()(self.view.mas_trailing)?.with()?.offset()(-30)
            make?.centerX.equalTo()(self.view.mas_centerX)
            make?.centerY.equalTo()(self.view.mas_centerY)
        }
    }
    
    private func validateTokenAndUpdateScreen() {
        AccountManager.manager.checkTokenValidate { isValidate in
            var rootVC: UIViewController?
            if isValidate {
                // Open Home View Controller directly
                rootVC = TabBarController()
            } else {
                // Open Log in view controller
                rootVC = UIStoryboard.main.viewController(LogInViewController.self)
            }
            
            let navigationController = UINavigationController(rootViewController: rootVC!)
            rootVC?.navigationController?.navigationBar.hide()
            
            UIWindow.keyWindow()?.rootViewController = navigationController
            UIWindow.keyWindow()?.overrideUserInterfaceStyle = .light
            UIWindow.keyWindow()?.makeKeyAndVisible()
        }
    }
}
