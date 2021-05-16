//
//  ConfirmRegisterViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 12/04/2021.
//

import Foundation
import UIKit
import Combine
import Masonry
import Alamofire


class ConfirmRegisterViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var courseNumberLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var didRemoveCourseAction: (RegisterCourse) -> Void = { _ in }
    
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hide()
    }
    
    func setUpUI() {
        
        self.title = "Xác nhận Đăng ký"
         
        self.contentView.backgroundColor = .background
        self.scrollView.backgroundColor = .background
        
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(
            ConfirmRegisterCourseCell.self,
            forCellReuseIdentifier: ConfirmRegisterCourseCell.reuseId
        )
        
        self.registerButton.applyGradient(colors: [
            UIColor.gradientFirst.cgColor,
            UIColor.gradientLast.cgColor
        ])
        self.registerButton.layer.masksToBounds = true
        self.registerButton.layer.cornerRadius = 20
        self.registerButton.addTarget(self,
                                      action: #selector(registerButtonTapped),
                                      for: .touchUpInside)
        
        self.courseNumberLabel.text = "Đã chọn: \(self.courses.count) môn học"
        self.creditsLabel.text = "Tổng số tín chỉ: \(self.courses.count * 5) tín chỉ"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableViewHeight.constant = self.tableView.contentSize.height
    }
    
    // MARK: - Actions
    
    @objc func registerButtonTapped() {
        AppLoading.showLoading(with: "Đang Đăng ký",
                               viewController: self)
        
        RegisterCourseManager.manager.registerCourses(self.courses) { error in
            
            AppLoading.hideLoading()
            
            if error == nil {
                AppAlert.showAlert("Đăng ký thành công",
                                   message: "Các môn học của bạn sẽ được xét duyệt bởi Giáo vụ trong thời gian sớm nhất.",
                                   on: self) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            } else {
                let error = error! as NSError
                AppLoading.showFailed(with: (error.userInfo["reason"] as! String),
                                      viewController: self)
            }
        }
    }
}

extension ConfirmRegisterViewController: UITableViewDelegate {
    
    
}

extension ConfirmRegisterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ConfirmRegisterCourseCell.reuseId
        ) as? ConfirmRegisterCourseCell else {
            fatalError()
        }
        
        cell.course = self.courses[indexPath.row]
        cell.isConfirm = true
        
        return cell
    }
}
