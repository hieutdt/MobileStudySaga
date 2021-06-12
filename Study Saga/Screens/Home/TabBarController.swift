//
//  TabBarController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/2/21.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    var homeTabBarItem = UITabBarItem(
        title: "Trang chủ",
        image: UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate),
        selectedImage: UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysTemplate)
    )
    
    var notiTabBarItem = UITabBarItem(
        title: "Thông báo",
        image: UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate),
        selectedImage: UIImage(named: "bell_fill")?.withRenderingMode(.alwaysTemplate)
    )
    
    var accountTabBarItem = UITabBarItem(
        title: "Cá nhân",
        image: UIImage(named: "account")?.withRenderingMode(.alwaysTemplate),
        selectedImage: UIImage(named: "account_fill")?.withRenderingMode(.alwaysTemplate)
    )
    
    var scheduleTabBarItem = UITabBarItem(
        title: "Lịch học",
        image: UIImage(named: "schedule")?.withRenderingMode(.alwaysTemplate),
        selectedImage: UIImage(named: "schedule_fill")?.withRenderingMode(.alwaysTemplate)
    )
    
    var courseTabBarItem = UITabBarItem(
        title: "Khoá học",
        image: UIImage(named: "class")?.withRenderingMode(.alwaysTemplate),
        selectedImage: UIImage(named: "class_fill")?.withRenderingMode(.alwaysTemplate)
    )
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // Home View controller
        let homeVC = UIStoryboard.main.viewController(HomeViewController.self)
        homeVC.tabBarItem = self.homeTabBarItem
        
        // Notification View controller
        let notiVC = NotificationViewController()
        notiVC.tabBarItem = self.notiTabBarItem
        
        // Schedule View controller
        let scheduleVC = UIStoryboard.courses.viewController(ScheduleViewController.self)
        scheduleVC.tabBarItem = self.scheduleTabBarItem
        
        // Courses View controller
        let courseVC = UIStoryboard.courses.viewController(CourseManagerViewController.self)
        courseVC.tabBarItem = self.courseTabBarItem
        
        // Account View controller
        let accountVC = UIStoryboard.main.viewController(AccountViewController.self)
        accountVC.tabBarItem = self.accountTabBarItem
        
        self.viewControllers = [homeVC, notiVC, scheduleVC, courseVC, accountVC]
        self.selectedIndex = 0
        self.selectedViewController = homeVC
        self.tabBar.barStyle = .default
        self.tabBar.tintColor = .primary
        self.tabBar.unselectedItemTintColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hide()
    }
}
