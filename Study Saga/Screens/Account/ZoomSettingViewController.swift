//
//  ZoomSettingViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/16/21.
//

import Foundation
import UIKit
import Combine
import Masonry
import MobileRTC
import MobileCoreServices

class ZoomSettingViewController: UIViewController, MobileRTCAuthDelegate {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: SSTextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: SSTextField!
    
    @IBOutlet weak var logInZoomButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    private func setUpUI() {
        
        self.navigationController?.navigationBar.show()
        self.title = "Thiết lập Tài khoản Zoom"
        
        descLabel.textColor = .darkGray
        
        logInZoomButton.setTitleColor(.white, for: .normal)
        logInZoomButton.setBackgroundColor(color: .primary, forState: .normal)
        logInZoomButton.layer.cornerRadius = 5
        logInZoomButton.addTarget(self,
                                  action: #selector(zoomLogInButtonTapped),
                                  for: .touchUpInside)
        
        emailLabel.textColor = .gray
        emailLabel.font = .systemFont(ofSize: 13)
        passwordLabel.textColor = .gray
        passwordLabel.font = .systemFont(ofSize: 13)
        
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(mainViewDidTap))
        self.view.addGestureRecognizer(tapGesture)
        
        // Set up auth service delegate
        if let authService = MobileRTC.shared().getAuthService() {
            authService.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @objc func mainViewDidTap() {
        self.view.endEditing(true)
    }
    
    @objc func zoomLogInButtonTapped() {
        let email = emailTextField.text ?? ""
        let pwd = passwordTextField.text ?? ""
        
        if email.isEmpty || pwd.isEmpty {
            return
        }
        
        if let authService = MobileRTC.shared().getAuthService() {
            AppLoading.showLoading(viewController: self)
            authService.login(withEmail: email,
                              password: pwd,
                              rememberMe: true)
        }
    }
    
    // MARK: - MobileRTCAuthDelegate
    
    func onMobileRTCLoginResult(_ resultValue: MobileRTCLoginFailReason) {
        
        AppLoading.hideLoading()
        
        switch resultValue {
        case .success:
            AppAlert.showAlert("Thiết lập tài khoản thành công!", on: self)
            break
            
        default:
            AppAlert.showAlert("Thiết lập tài khoản thất bại",
                               message: "Vui lòng kiểm tra lại tài khoản Zoom của bạn và thử lại sau.",
                               on: self)
            break
        }
    }
    
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        // Do nothing.
    }
}
