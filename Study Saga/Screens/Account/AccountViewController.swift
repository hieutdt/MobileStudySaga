//
//  AccountViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/1/21.
//

import Foundation
import UIKit
import Combine
import AlamofireImage

class AccountViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: BaseButton!
    @IBOutlet weak var courseHistoryButton: BaseButton!
    @IBOutlet weak var calendarButton: BaseButton!
    @IBOutlet weak var assignCoursesButton: BaseButton!
    @IBOutlet weak var registerCourseHIstoryButton: BaseButton!
    
    @IBOutlet weak var logOutButton: BaseButton!
    
    // MARK: - Data model
    
    var viewModel = AccountViewModel()
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.setUpDataBinding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerContainer.createViewBackgroundWithAppGradient()
    }
    
    // MARK: - UI Configure
    
    private func setUpUI() {
        self.navigationController?.navigationBar.hide()
        
        self.contentView.backgroundColor = .background
        
        self.userNameLabel.textColor = .white
        self.userEmailLabel.textColor = .lightText
        

        self.headerContainer.backgroundColor = .primary
        self.headerContainer.layer.masksToBounds = false
        self.headerContainer.layer.shadowColor = UIColor.black.cgColor
        self.headerContainer.layer.shadowRadius = 5
        self.headerContainer.layer.shadowOpacity = 0.2
        self.headerContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        self.avatarImageView.layer.cornerRadius = 10
        self.avatarImageView.image = UIImage(named: "avatar")
        
        self.editProfileButton.setButton(title: "Chỉnh sửa thông tin",
                                         iconName: "profile_edit",
                                         showNext: true) {
            let vc = UIStoryboard.main.viewController(UpdateInfoViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.courseHistoryButton.setButton(
            title: "Kết quả học tập",
            iconName: "report_card",
            showNext: true) {
            
        }
        
        self.logOutButton.setButton(
            title: "Đăng xuất",
            iconName: "log_out",
            showNext: false,
            showLine: false) {
            
            let actionSheet = UIAlertController(title: "Xác nhận đăng xuất",
                                                message: nil,
                                                preferredStyle: .actionSheet
            )
            
            let logOutAction = UIAlertAction(title: "Đăng xuất",
                                             style: .destructive) { [weak self] action in
                guard let self = self else {
                    return
                }
                
                self.logOut()
            }
                
                let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
            actionSheet.addAction(logOutAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
        self.logOutButton.setStyle(isDestructive: true)
        
        self.assignCoursesButton.setButton(
            title: "Đăng ký môn học",
            iconName: "assign_course",
            showNext: true,
            showLine: true) {
            // Open Register Course screen.
            let vc = UIStoryboard.register.viewController(RegisterCourseViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.registerCourseHIstoryButton.setButton(
            title: "Lịch sử đăng ký",
            iconName: "history",
            showNext: true,
            showLine: false) {
            // Open Register History screen.
            let vc = UIStoryboard.register.viewController(RegisterHistoryViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Data Binding
    
    func setUpDataBinding() {
        
        self.viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { user in
                if let user = user {
                    if let url = URL(string: user.avatarUrl) {
                        self.avatarImageView.af.setImage(withURL: url)
                    }
                    
                    self.userNameLabel.text = user.name
                    self.userEmailLabel.text = user.email
                }
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Actions
    
    func logOut() {
        // Log out actions
        AccountManager.manager.logOut()
        
        if let window = UIWindow.keyWindow() {
            let logInVC = UIStoryboard.main.viewController(LogInViewController.self)
            
            self.dismiss(animated: true, completion: nil)
            window.rootViewController = logInVC
            window.makeKeyAndVisible()
        }
    }
    
    // MARK: - Navigation
    
    func presentZoomSettingVC() {
        let vc = UIStoryboard.main.viewController(ZoomSettingViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentZoomStatusVC() {
        let vc = UIStoryboard.main.viewController(ZoomAccountStatusViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
