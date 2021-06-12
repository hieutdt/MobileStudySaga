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
    
    var headerBar = UIView()
    var titleLabel = UILabel()
    var emptyView = UIView()
    
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
        
        self.setUpUI()
        self.createEmptyView()
        self.createDiffableDataSource()
        
        self.viewModel.$notifications.sink { models in
            if models.isEmpty {
                self.emptyView.show()
            } else {
                self.emptyView.hide()
            }
        }
        .store(in: &self.cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerBar.createViewBackgroundWithAppGradient()
    }
    
    func createEmptyView() {
        self.view.addSubview(emptyView)
        self.view.bringSubviewToFront(emptyView)
        
        emptyView.backgroundColor = .background
        emptyView.mas_makeConstraints { make in
            make?.top.equalTo()(headerBar.mas_bottom)
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.bottom.equalTo()(self.view.mas_bottom)
        }
        
        let imgView = UIImageView()
        imgView.image = UIImage(named: "unavailable-post")
        emptyView.addSubview(imgView)
        imgView.mas_makeConstraints { make in
            make?.top.equalTo()(emptyView.mas_top)?.offset()(60)
            make?.size.equalTo()(150)
            make?.centerX.equalTo()(emptyView.mas_centerX)
        }
        
        let label = UILabel()
        label.text = "Bạn không có thông báo nào"
        label.numberOfLines = 3
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textAlignment = .center
        label.textColor = .darkGray
        emptyView.addSubview(label)
        label.mas_makeConstraints { make in
            make?.top.equalTo()(imgView.mas_bottom)?.offset()(25)
            make?.leading.equalTo()(emptyView.mas_leading)?.offset()(20)
            make?.trailing.equalTo()(emptyView.mas_trailing)?.offset()(-20)
        }
    }
    
    func setUpUI() {
        self.view.addSubview(headerBar)
        headerBar.backgroundColor = .primary
        headerBar.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.top.equalTo()(self.view.mas_top)
            make?.height.equalTo()(50 + getStatusBarHeight())
        }
        
        headerBar.addSubview(titleLabel)
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        titleLabel.text = "Thông báo"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(headerBar.mas_leading)
            make?.trailing.equalTo()(headerBar.mas_trailing)
            make?.bottom.equalTo()(headerBar.mas_bottom)?.offset()(-10)
        }
        
        self.view.addSubview(tableView)
        tableView.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.bottom.equalTo()(self.view.mas_bottom)
            make?.top.equalTo()(headerBar.mas_bottom)
        }
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseId)
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

