//
//  ChatViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 13/06/2021.
//

import Foundation
import Combine
import UIKit
import Masonry


class ChatViewController: UIViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Message>
    typealias DataSource = UITableViewDiffableDataSource<Int, Message>
    
    var headerView = UIView()
    var dismissBtn = UIButton()
    var titleLabel = UILabel()
    var tableView = UITableView()
    
    var viewModel = ChatViewModel()
    var dataSource: DataSource?
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    func setUpUI() {
        
        self.view.backgroundColor = .background
        
        self.setUpHeaderBar()
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.allowsSelection = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.tableView.register(SendMessageCell.self, forCellReuseIdentifier: SendMessageCell.reuseID)
        self.tableView.register(ReceiveMessageCell.self, forCellReuseIdentifier: ReceiveMessageCell.reuseID)
        self.tableView.delegate = self
        self.tableView.transform3D = CATransform3DRotate(tableView.transform3D, CGFloat(Double.pi), 1, 0, 0)
        self.tableView.transform3D = CATransform3DRotate(tableView.transform3D, CGFloat(Double.pi), 0, 1, 0)
        
        self.view.addSubview(tableView)
        tableView.mas_makeConstraints { make in
            make?.top.equalTo()(headerView.mas_bottom)
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.bottom.equalTo()(self.view.mas_bottom)?.offset()(-50)
        }

        self.createDiffableDataSource(tableView: self.tableView)
    }
    
    func setUpHeaderBar() {
        self.view.addSubview(headerView)
        headerView.mas_makeConstraints { make in
            make?.top.equalTo()(self.view.mas_top)
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.height.equalTo()(50 + getStatusBarHeight())
        }
        
        headerView.addSubview(dismissBtn)
        dismissBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        dismissBtn.setImage(
            UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        dismissBtn.mas_makeConstraints { make in
            
            make?.leading.equalTo()(headerView.mas_leading)?.offset()(10)
            make?.size.equalTo()(30)
            make?.bottom.equalTo()(headerView.mas_bottom)?.offset()(-10)
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        titleLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(dismissBtn.mas_trailing)?.offset()(15)
            make?.trailing.equalTo()(headerView.mas_trailing)?.offset()(-10)
            make?.centerY.equalTo()(dismissBtn.mas_centerY)
        }
    }
    
    private lazy var updateDataSourcePublisher = self.viewModel.$messages
        .map { message -> Snapshot in
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(message)
            return snapshot
        }
        .makeConnectable()
    
    func createDiffableDataSource(tableView: UITableView) {
        let datasource = DataSource(tableView: tableView) { [weak self] uiTableView, indexPath, message in
            
            guard let self = self else {
                return nil
            }
            
            let messages = self.viewModel.messages
            
            if let message = messages.first(where: { $0.messageId == message.messageId }) {
                
                // Send message
                if message.isFromCurrentUser() {
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: SendMessageCell.reuseID
                    ) as? SendMessageCell else {
                        return UITableViewCell()
                    }
                    
                    cell.message = message
                    return cell
                    
                // Receive message
                } else {
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: ReceiveMessageCell.reuseID
                    ) as? ReceiveMessageCell else {
                        return UITableViewCell()
                    }
                    
                    cell.message = message
                    return cell
                }
            }
            
            return UITableViewCell()
        }
        
        self.dataSource = datasource
        
        var initialSnapshot = Snapshot()
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(self.viewModel.messages)
        
        datasource.apply(initialSnapshot, animatingDifferences: false) { [weak self] in
            guard let self = self else { return }
            
            // Begin receiving updates.
            self.updateDataSourcePublisher
                .connect()
                .store(in: &self.cancellables)
        }
    }
    
    @objc func backBtnTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChatViewController: UITableViewDelegate {
    
}
