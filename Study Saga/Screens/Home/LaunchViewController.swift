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
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 36)
        label.textColor = .primary
        label.textAlignment = .center
        label.text = "Study Saga"
        return label
    }()
    
    var container = UIView()
    
    var logoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "paper_plane")
        return imgView
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
        self.view.backgroundColor = .white
        
        self.view.addSubview(container)
        container.backgroundColor = .white
        container.mas_makeConstraints { make in
            make?.centerX.equalTo()(self.view.mas_centerX)
            make?.centerY.equalTo()(self.view.mas_centerY)
        }
        
        container.addSubview(logoImgView)
        logoImgView.mas_makeConstraints { make in
            make?.top.equalTo()(container.mas_top)
            make?.size.equalTo()(150)
            make?.centerX.equalTo()(container.mas_centerX)
        }
        
        container.addSubview(appNameLabel)
        appNameLabel.mas_makeConstraints { make in
            make?.top.equalTo()(logoImgView.mas_bottom)?.offset()(20)
            make?.leading.equalTo()(container.mas_leading)
            make?.trailing.equalTo()(container.mas_trailing)
            make?.bottom.equalTo()(container.mas_bottom)
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
