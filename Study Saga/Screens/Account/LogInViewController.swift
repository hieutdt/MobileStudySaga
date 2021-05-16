//
//  LogInViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/2/21.
//

import Foundation
import UIKit
import Combine


class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: SSTextField!
    @IBOutlet weak var passwordTextField: SSTextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
    }
    
    private func setUpUI() {
        self.logInButton.layer.cornerRadius = 10
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
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(viewDidTap))
        self.view.addGestureRecognizer(tapGesture)
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
            AppLoading.showLoading(with: "Đăng nhập...", viewController: self)
            
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

