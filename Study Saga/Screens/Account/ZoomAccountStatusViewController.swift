//
//  ZoomAccountStatusViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/22/21.
//

import Foundation
import UIKit
import Combine
import MobileRTC


class ZoomAccountStatusViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var currentUser = AccountManager.manager.loggedInUser!
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editBarButtonItem: UIBarButtonItem = UIBarButtonItem(
            title: "Chỉnh sửa",
            style: .plain,
            target: self,
            action: #selector(editButtonTapped))
        
        self.title = "Thiết lập tài khoản Zoom"
        self.navigationItem.rightBarButtonItem = editBarButtonItem
        
        titleLabel.textColor = .primary
        emailLabel.text = "Địa chỉ email: "
        timeLabel.text = "Thời gian: "
        
        // Set up binding
        AccountManager.manager.$loggedInUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self = self, let user = user else {
                    return
                }
                
                self.currentUser = user
                self.emailLabel.text = "Địa chỉ email: "
                self.timeLabel.text = "Thời gian: "
            }
            .store(in: &self.cancellables)
    }
    
    @objc func editButtonTapped() {
        let vc = UIStoryboard.main.viewController(ZoomSettingViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
