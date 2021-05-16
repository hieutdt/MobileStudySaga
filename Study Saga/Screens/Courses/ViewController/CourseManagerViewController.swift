//
//  CourseManagerViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/4/21.
//

import Foundation
import UIKit
import Combine
import Masonry
import SkeletonView

class CourseManagerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var emptyCoursesView = StateView(frame: .zero)
    
    var viewModel = CourseViewModel()
    var cancellables = Set<AnyCancellable>()
    
    private weak var selectedCell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.fetch()
    }
    
    func fetch() {
        
        self.tableView.showAnimatedGradientSkeleton()
        
        // Fetch all user's courses.
        self.viewModel.getCourses { isSuccess in
            self.tableView.hideSkeleton()
            
            if isSuccess {
                if self.viewModel.courses.isEmpty {
                    self.tableView.hide()
                    self.showStateViewWithFetchResult(true)
                    
                } else {
                    self.tableView.show()
                    self.emptyCoursesView.hide()
                    self.tableView.reloadData()
                }
                
            // Fetching failed case
            } else {
                self.tableView.hide()
                self.showStateViewWithFetchResult(false)
            }
        }
    }
    
    func setUpUI() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(emptyCoursesView)
        emptyCoursesView.mas_makeConstraints { make in
            make?.edges.equalTo()(self.view)
        }
        emptyCoursesView.hide()
        
        let layer = CAGradientLayer()
        layer.frame = headerView.bounds
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.colors = [UIColor.gradientFirst.cgColor, UIColor.gradientLast.cgColor]
        headerView.layer.insertSublayer(layer, at: 0)
        headerView.layer.masksToBounds = false
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.05
        headerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.view.bringSubviewToFront(headerView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isSkeletonable = true
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(
            CourseTableCell.self,
            forCellReuseIdentifier: CourseTableCell.reuseId
        )
        tableView.backgroundColor = .clear
    }
    
    func showStateViewWithFetchResult(_ isEmpty: Bool) {
        if isEmpty {
            emptyCoursesView.setStateView(imageName: "set_up_zoom_bg",
                                          title: "Bạn chưa có môn học nào",
                                          desc: "Hãy đăng ký môn học để tham gia học bạn nhé!",
                                          buttonTitle: "Đăng ký môn học") {
                // TODO: Open assign courses view controller.
                // ...
            }
            
        } else {
            emptyCoursesView.setStateView(imageName: "set_up_zoom_bg",
                                          title: "Có lỗi xảy ra",
                                          desc: "Có lỗi xảy ra trong quá trình tải dữ liệu. Vui lòng thử lại!",
                                          buttonTitle: "Thử lại") { [weak self] in
                // Retry fetch data.
                guard let self = self else {
                    return
                }
                
                self.fetch()
            }
        }
    }
}

extension CourseManagerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let course = self.viewModel.courses[indexPath.item]
        
        AppLoading.showLoading(with: "Đang tải ...", viewController: self)
        
        CoursesManager.manager.getCourseInfo(id: course.courseId) { course in
            
            AppLoading.hideLoading()
            
            if let course = course {
                let vc = UIStoryboard.courses.viewController(CourseInfoViewController.self)
                vc.course = course
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                AppLoading.showFailed(with: "Có lỗi xảy ra", viewController: self)
            }
        }
    }
}

extension CourseManagerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.courses.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CourseTableCell.reuseId
        ) as? CourseTableCell else {
            fatalError("CourseTableCell is not registed!")
        }
        
        cell.model = self.viewModel.courses[indexPath.row]
        return cell
    }
}

extension CourseManagerViewController: SkeletonTableViewDataSource {

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
        return CourseTableCell.reuseId
    }
}
