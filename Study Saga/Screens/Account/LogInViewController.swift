//
//  LogInViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/2/21.
//

import Foundation
import UIKit
import Combine
import TweeTextField

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: TweeActiveTextField!
    @IBOutlet weak var passwordTextField: TweeActiveTextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var signUpInfoLabel: UILabel!
    var documentManagerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
    }
    
    private func setUpUI() {
        
        emailTextField.placeholderColor = .lightGray
        emailTextField.textColor = .darkText
        emailTextField.tweePlaceholder = "Địa chỉ Email"
        emailTextField.placeholderDuration = 0.25
        emailTextField.activeLineColor = .primary
        emailTextField.lineColor = .lightGray
        emailTextField.activeLineWidth = 3
        emailTextField.animationDuration = 0.3
        emailTextField.placeholder = ""
        
        passwordTextField.placeholderColor = .lightGray
        passwordTextField.textColor = .darkText
        passwordTextField.tweePlaceholder = "Mật khẩu"
        passwordTextField.placeholderDuration = 0.25
        passwordTextField.activeLineColor = .primary
        passwordTextField.lineColor = .lightGray
        passwordTextField.activeLineWidth = 3
        passwordTextField.animationDuration = 0.3
        passwordTextField.placeholder = ""
        
        self.logInButton.layer.cornerRadius = 20
        self.logInButton.setTitleColor(.white, for: .normal)
        self.logInButton.setTitleColor(.selectedBackground, for: .selected)
        self.logInButton.addTarget(self,
                                   action: #selector(logInTapped),
                                   for: .touchUpInside)
        
        self.passwordTextField.isSecureTextEntry = true
        
        self.signUpButton.setTitleColor(.primary, for: .normal)
        self.signUpButton.addTarget(self,
                                    action: #selector(signUpButtonTapped),
                                    for: .touchUpInside)
        self.signUpButton.removeFromSuperview()
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(viewDidTap))
        self.view.addGestureRecognizer(tapGesture)
        
        self.documentManagerButton = UIButton()
        self.documentManagerButton.setTitle("Quản lý tài liệu học tập", for: .normal)
        self.documentManagerButton.setTitleColor(.systemBlue, for: .normal)
        self.documentManagerButton.setTitleColor(.midnightBlue, for: .highlighted)
        self.view.addSubview(self.documentManagerButton)
        self.documentManagerButton.mas_makeConstraints { make in
            make?.bottom.equalTo()(self.view.mas_bottom)?.offset()(-40)
            make?.leading.equalTo()(self.view.mas_leading)?.offset()(30)
            make?.trailing.equalTo()(self.view.mas_trailing)?.offset()(-30)
        }
        
        self.signUpInfoLabel = UILabel()
        self.signUpInfoLabel.font = UIFont.systemFont(ofSize: 13)
        self.signUpInfoLabel.textColor = .darkGray
        self.signUpInfoLabel.numberOfLines = 10
        self.signUpInfoLabel.textAlignment = .center
        self.signUpInfoLabel.text = "Tính năng đăng ký đã bị khoá. Nếu bạn chưa có tài khoản, vui lòng liên hệ với Phòng Giáo vụ của trường để đăng ký tài khoản."
        self.view.addSubview(self.signUpInfoLabel)
        self.signUpInfoLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)?.offset()(30)
            make?.trailing.equalTo()(self.view.mas_trailing)?.offset()(-30)
            make?.top.equalTo()(self.logInButton.mas_bottom)?.offset()(15)
        }
    }
    
    @objc func logInTapped() {
        
        if let email = emailTextField.text,
           let pwd = passwordTextField.text {
            
            // Validate Email and Password.
            if email.isEmpty || pwd.isEmpty {
                AppAlert.showAlert("Email và mật khẩu không được để trống",
                                   on: self)
                return
            }
            
            // Show loading
            AppLoading.showLoading(with: "Đăng nhập", viewController: self)
            
            // Send log in request
            AccountManager.manager.logIn(email: email, pwd: pwd) { logInSuccess in
                
                // Hide loading
                AppLoading.hideLoading()
                
                // Open TabBarController if log in succeed.
                if logInSuccess {
                    let tabBarController = TabBarController()
                    let navigationController = UINavigationController(rootViewController: tabBarController)
                    tabBarController.navigationController?.navigationBar.hide()
                    
                    UIWindow.keyWindow()?.rootViewController = navigationController
                    UIWindow.keyWindow()?.makeKeyAndVisible()
                    
                } else {
                    AppAlert.showAlert("Đăng nhập thất bại",
                                       message: "Email hoặc Mật khẩu chưa chính xác. Vui lòng kiểm tra và thử lại!",
                                       on: self)
                }
            }
        }
    }
    
    @objc func signUpButtonTapped() {
        let vc = UIStoryboard.main.viewController(SignUpViewController.self)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func viewDidTap() {
        // Hide keyboard
        self.view.endEditing(true)
    }
}

