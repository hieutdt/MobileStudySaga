//
//  RegisterHistoryViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 14/04/2021.
//

import Foundation
import UIKit
import Combine
import Masonry
import AlamofireImage
import SkeletonView


class RegisterHistoryViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    
    var courses: [Course] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.fetchData()
    }
    
    func setUpUI() {
        self.title = "Lịch sử đăng ký môn học"
        
        self.view.backgroundColor = .background
        
        self.tableView.rowHeight = 200
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(
            ConfirmRegisterCourseCell.self,
            forCellReuseIdentifier: ConfirmRegisterCourseCell.reuseId
        )
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.isSkeletonable = true
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hide()
    }
    
    // MARK: - Fetch Data
    
    func fetchData() {
        
        if RegisterCourseManager.manager.registedCourses.isEmpty ||
            RegisterCourseManager.manager.coursesDidChanged {
            
            self.tableView.showAnimatedGradientSkeleton()
            
            RegisterCourseManager.manager.getRegistedCourses { courses, error in
                
                RegisterCourseManager.manager.coursesDidChanged = false
                
                if let _ = error {
                    AppLoading.showFailed(with: "Tải dữ liệu thất bại. Vui lòng thử lại sau!",
                                          viewController: self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                } else {
                    self.courses = courses
                }
                
                self.tableView.stopSkeletonAnimation()
                self.view.hideSkeleton()
                
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.reloadData()
            }
        } else {
            self.courses = RegisterCourseManager.manager.registedCourses
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.reloadData()
        }
    }
}

extension RegisterHistoryViewController: SkeletonTableViewDataSource {
    
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
        cell.isConfirm = false
        cell.delegate = self
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView,
                                cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return ConfirmRegisterCourseCell.reuseId
    }
}

extension RegisterHistoryViewController: ConfirmRegisterCourseCellDelegate {
    
    func didSelectCell(_ cell: ConfirmRegisterCourseCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            let index = indexPath.row
            let course = self.courses[index]
            let vc = UIStoryboard.register.viewController(RegisterCourseInfoViewController.self)
            vc.course = course
            self.present(vc, animated: true, completion: nil)
        }
    }
}
