//
//  RegisterCourseViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/24/21.
//

import Foundation
import UIKit
import Combine
import AlamofireImage
import Masonry
import SkeletonView



class RegisterCourseViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var selectedNumberLabel: UILabel!
    @IBOutlet weak var creditNumberLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    var courses: [Course] = []
    var registedCourses: [Course] = []
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
        if RegisterCourseManager.manager.courses.isEmpty {
            self.fetchCoursesData()
        } else {
            self.courses = RegisterCourseManager.manager.courses
                .map {
                    var course = $0
                    course.state = .assigning
                    return course
                }
            
            self.tableView.reloadData()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hide()
    }
    
    // MARK: - UI Configure
    
    private func setUpUI() {
        self.title = "Đăng ký môn học"
        
        self.view.isSkeletonable = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isSkeletonable = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(
            RegisterCourseTableCell.self,
            forCellReuseIdentifier: RegisterCourseTableCell.reuseId
        )
        
        selectedNumberLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        creditNumberLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        selectedNumberLabel.text = "\(self.courses.count) môn"
        creditNumberLabel.text = "\(self.courses.count * 5) tín chỉ"
        
        self.view.bringSubviewToFront(self.bottomView)
        self.bottomView.layer.shadowColor = UIColor.black.cgColor
        self.bottomView.layer.shadowOpacity = 0.1
        self.bottomView.layer.shadowRadius = 2
        
        registerButton.layer.cornerRadius = 20
        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOpacity = 0.1
        registerButton.layer.shadowRadius = 0.5
        registerButton.addTarget(self,
                                 action: #selector(registerButtonTapped),
                                 for: .touchUpInside)
        registerButton.setBackgroundColor(color: .lightGray, forState: .normal)
        registerButton.isEnabled = false
    }
    
    // MARK: - Fetch Data
    
    func fetchCoursesData() {
        
        // Show skeleton.
        self.tableView.showAnimatedGradientSkeleton()
        
        // Start fetching register courses list data.
        RegisterCourseManager.manager.fetchRegisterCourses { courses, isSuccess in
            
            // Update models.
            if isSuccess {
                self.courses = courses.map {
                    var course = $0
                    course.state = .assigning
                    return course
                }
            }
            
            // Hide skeleton and reload table view.
            self.tableView.hideSkeleton()
            self.tableView.reloadData()
        }
    }
    
    func updateSelectedCount() {
        self.selectedNumberLabel.text = "\(self.registedCourses.count) môn"
        self.creditNumberLabel.text = "\(self.courses.count * 5) tín chỉ"
        
        if self.registedCourses.isEmpty {
            self.registerButton.isEnabled = false
            self.registerButton.setBackgroundColor(color: .lightGray, forState: .normal)
        } else {
            self.registerButton.isEnabled = true
            self.registerButton.setBackgroundColor(color: .primary, forState: .normal)
        }
    }
    
    // MARK: - Actions
    
    @objc func registerButtonTapped() {
        let vc = UIStoryboard.register.viewController(ConfirmRegisterViewController.self)
        vc.courses = self.registedCourses
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegisterCourseViewController: UITableViewDelegate {
    
    
}

extension RegisterCourseViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RegisterCourseTableCell.reuseId
        ) as? RegisterCourseTableCell else {
            fatalError("RegisterCourseTableCell was not registed!")
        }
        
        cell.course = self.courses[indexPath.row]
        cell.delegate = self
        cell.isChoosen = self.registedCourses.contains(
            where: { $0.courseId == self.courses[indexPath.row].courseId }
        )
        return cell
    }
}

extension RegisterCourseViewController: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView,
                                numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView,
                                cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return RegisterCourseTableCell.reuseId
    }
}

extension RegisterCourseViewController: RegisterCourseTableCellDelegate {
    
    func didSelectedCell(_ cell: RegisterCourseTableCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            let index = indexPath.row
            let course = self.courses[index]
            let vc = UIStoryboard.register.viewController(RegisterCourseInfoViewController.self)
            vc.course = course
            vc.delegate = self
            vc.isSelected = self.registedCourses.contains(
                where: { $0.courseId == course.courseId }
            )
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension RegisterCourseViewController: RegisterCourseInfoVCDelegate {
    
    func didSelectedCourse(_ course: Course) {
        self.registedCourses.append(course)
        self.tableView.hideSkeleton()
        self.tableView.reloadData()
        self.updateSelectedCount()
    }
    
    func didDeselectCourse(_ course: Course) {
        self.registedCourses.removeAll(where: { $0.courseId == course.courseId })
        self.tableView.hideSkeleton()
        self.tableView.reloadData()
        self.updateSelectedCount()
    }
}
