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
    
    var textInputContainer = UIView()
    var textInput = UITextView()
    var sendButton = UIButton()
    weak var textInputHeight: NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setUpTextInput()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.createViewBackgroundWithAppGradient()
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
        self.tableView.delegate = self
        self.tableView.transform3D = CATransform3DRotate(tableView.transform3D, CGFloat(Double.pi), 1, 0, 0)
        self.tableView.transform3D = CATransform3DRotate(tableView.transform3D, CGFloat(Double.pi), 0, 1, 0)
        
        self.tableView.register(SendMessageCell.self, forCellReuseIdentifier: SendMessageCell.reuseID)
        self.tableView.register(ReceiveMessageCell.self, forCellReuseIdentifier: ReceiveMessageCell.reuseID)
        self.tableView.register(TutorialMessageCell.self, forCellReuseIdentifier: TutorialMessageCell.reuseId)
        
        self.view.addSubview(tableView)
        tableView.mas_makeConstraints { make in
            make?.top.equalTo()(headerView.mas_bottom)
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
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
        dismissBtn.tintColor = .white
        dismissBtn.mas_makeConstraints { make in
            make?.leading.equalTo()(headerView.mas_leading)?.offset()(10)
            make?.size.equalTo()(30)
            make?.bottom.equalTo()(headerView.mas_bottom)?.offset()(-10)
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.text = "Chatbot Hỗ trợ học tập"
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        titleLabel.textAlignment = .center
        titleLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(headerView.mas_leading)?.offset()(10)
            make?.trailing.equalTo()(headerView.mas_trailing)?.offset()(-10)
            make?.centerY.equalTo()(dismissBtn.mas_centerY)
        }
    }
    
    func setUpTextInput() {
        textInputContainer.addSubview(textInput)
        textInputContainer.addSubview(sendButton)
        
        textInputContainer.backgroundColor = .white
        
        textInput.text = "Nhập tin nhắn ở đây"
        textInput.font = UIFont(name: "HelveticaNeue-Regular", size: 15)
        textInput.mas_makeConstraints { make in
            make?.leading.equalTo()(textInputContainer.mas_leading)?.offset()(10)
            make?.top.equalTo()(textInputContainer.mas_top)?.offset()(10)
            make?.bottom.equalTo()(textInputContainer.mas_bottom)?.offset()(-30)
        }
        textInputHeight = textInput.heightAnchor.constraint(equalToConstant: 40)
        textInputHeight?.isActive = true
        
        sendButton.setImage(UIImage(named: "chat_send_normal"), for: .normal)
        sendButton.mas_makeConstraints { make in
            make?.size.equalTo()(60)
            make?.centerY.equalTo()(textInput.mas_centerY)
            make?.trailing.equalTo()(textInputContainer.mas_trailing)?.offset()(-10)
            make?.leading.equalTo()(textInput.mas_trailing)?.offset()(10)
        }
        
        self.view.addSubview(textInputContainer)
        textInputContainer.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.bottom.equalTo()(self.view.mas_bottom)
            make?.top.equalTo()(self.tableView.mas_bottom)
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
                
                if message.type == .tutorial {
                    guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: TutorialMessageCell.reuseId
                    ) as? TutorialMessageCell else {
                        fatalError()
                    }
                    
                    return cell
                }
                
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
