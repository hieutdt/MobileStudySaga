//
//  ScheduleViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/3/21.
//

import Foundation
import UIKit
import Combine
import SkeletonView


class ScheduleViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Data Model

    var viewModel = ScheduleViewModel()
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.fetchData()
    }
    
    func setUpUI() {
        self.headerView.layer.masksToBounds = false
        self.headerView.layer.shadowColor = UIColor.black.cgColor
        self.headerView.layer.shadowRadius = 5
        self.headerView.layer.shadowOpacity = 0.05
        self.headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        self.filterButton.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle"),
                                   for: .normal)
        self.filterButton.setTitle("", for: .normal)
        
        self.view.bringSubviewToFront(self.headerView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isSkeletonable = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .background
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(
            ScheduleTableCell.self,
            forCellReuseIdentifier: ScheduleTableCell.reuseId
        )
    }
    
    func fetchData() {
        tableView.showAnimatedGradientSkeleton()
        self.viewModel.fetchLessons { isSuccess in
            self.tableView.hideSkeleton()
            self.tableView.reloadData()
        }
    }
}

extension ScheduleViewController: UITableViewDelegate {
    
    
}

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ScheduleTableCell.reuseId
        ) as? ScheduleTableCell else {
            fatalError("ScheduleTableCell was not registed.")
        }
        
        let schedule = self.viewModel.schedules[indexPath.row]
        cell.model = schedule
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        if indexPath.item == 0 {
            cell.isNearestClass = true
        }
        
        return cell
    }
}

extension ScheduleViewController: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView,
                                numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView,
                                cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return ScheduleTableCell.reuseId
    }
}
