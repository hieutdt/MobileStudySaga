//
//  NotificationViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 03/06/2021.
//

import Foundation
import UIKit
import Combine

class NotificationViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Int, NotificationModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, NotificationModel>
    
    var tableView = UITableView()
    var viewModel = NotificationViewModel()
    var dataSource: DataSource?
    var cancellables = Set<AnyCancellable>()
    
    private lazy var updateNotiDataSourcePublisher = self.viewModel.$notifications
        .map { noti -> Snapshot in
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(noti)
            return snapshot
        }
        .makeConnectable()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        
        tableView.frame = self.view.bounds
        self.view.addSubview(tableView)
        
        tableView.backgroundColor = .clear
//        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(NotificationCell.self,
                           forCellReuseIdentifier: NotificationCell.reuseId)
        
        self.createDiffableDataSource()
    }
    
    func createDiffableDataSource() {
        let datasource = DataSource(tableView: self.tableView) { tableView, IndexPath, notificationModel in
            
            let notifs = self.viewModel.notifications
            
            if let noti = notifs.first(where: { $0.id == notificationModel.id }) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseId) as? NotificationCell else {
                    return nil
                }
                
                cell.model = noti
                return cell
            }
            
            return UITableViewCell()
        }
        
        self.dataSource = datasource
        
        // Apply initialize snapshot
        var initSnapshot = Snapshot()
        initSnapshot.appendSections([0])
        initSnapshot.appendItems(self.viewModel.notifications)
        datasource.apply(initSnapshot ,animatingDifferences: false) {
            // Begin receiving updates
            self.updateNotiDataSourcePublisher
                .connect()
                .store(in: &self.cancellables)
        }
    }
}

