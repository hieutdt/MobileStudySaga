//
//  DocumentsViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 13/06/2021.
//

import Foundation
import UIKit
import Masonry


class DocumentsViewController: UIViewController {
    
    var headerView = UIView()
    var dismissBtn = UIButton()
    var titleLabel = UILabel()
    
    var tableView = UITableView()
    var emptyView = UIView()
    
    var documents: [DocumentModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.hide()
        
        self.setUpHeaderBar()
        self.setUpTableView()
        self.createEmptyView()
        
        self.documents = DBManager.manager.queryDocumentsFromDB()
        self.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.createViewBackgroundWithAppGradient()
    }
    
    func createEmptyView() {
        self.view.addSubview(emptyView)
        self.view.bringSubviewToFront(emptyView)
        
        emptyView.backgroundColor = .background
        emptyView.mas_makeConstraints { make in
            make?.top.equalTo()(headerView.mas_bottom)
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.bottom.equalTo()(self.view.mas_bottom)
        }
        
        let imgView = UIImageView()
        imgView.image = UIImage(named: "paper")
        emptyView.addSubview(imgView)
        imgView.mas_makeConstraints { make in
            make?.top.equalTo()(emptyView.mas_top)?.offset()(60)
            make?.size.equalTo()(100)
            make?.centerX.equalTo()(emptyView.mas_centerX)
        }
        
        let label = UILabel()
        label.text = "Bạn chưa có tài liệu nào lưu trữ offline."
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
    
    func reloadData() {
        self.tableView.reloadData()
        if self.documents.count == 0 {
            self.emptyView.show()
        } else {
            self.emptyView.hide()
        }
    }
    
    func setUpHeaderBar() {
        self.view.addSubview(headerView)
        headerView.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.top.equalTo()(self.view.mas_top)
            make?.height.equalTo()(50 + getStatusBarHeight())
        }
        
        headerView.addSubview(dismissBtn)
        dismissBtn.addTarget(self, action: #selector(dismissBtnDidTap), for: .touchUpInside)
        let systemImageName = self.navigationController != nil ? "chevron.left" : "xmark"
        dismissBtn.setImage(UIImage(systemName: systemImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        dismissBtn.tintColor = .white
        dismissBtn.mas_makeConstraints { make in
            make?.leading.equalTo()(headerView.mas_leading)?.offset()(10)
            make?.size.equalTo()(30)
            make?.bottom.equalTo()(headerView.mas_bottom)?.offset()(-10)
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.text = "Tài liệu học tập của bạn"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        titleLabel.textAlignment = .center
        titleLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(headerView.mas_leading)
            make?.trailing.equalTo()(headerView.mas_trailing)
            make?.centerY.equalTo()(dismissBtn.mas_centerY)
        }
    }
    
    func setUpTableView() {
        self.view.addSubview(tableView)
        tableView.mas_makeConstraints { make in
            make?.top.equalTo()(headerView.mas_bottom)
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.bottom.equalTo()(self.view.mas_bottom)
        }
        
        tableView.backgroundColor = .background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.register(DBDocumentCell.self, forCellReuseIdentifier: DBDocumentCell.reuseId)
    }
    
    @objc func dismissBtnDidTap() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension DocumentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DBDocumentCell.reuseId,
                for: indexPath) as? DBDocumentCell else {
            fatalError()
        }
        
        cell.document = self.documents[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let document = self.documents[indexPath.item]
        let vc = PDFViewController()
        vc.documentUrl = document.path
        vc.titleText = document.name
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive,
                                              title: "Xoá") { action, sourceView, completion in
            let document = self.documents[indexPath.item]
            let alertController = UIAlertController(title: "Bạn muốn xoá file \(document.name)?", message: nil, preferredStyle: .actionSheet)
            let removeAction = UIAlertAction(title: "Xoá", style: .destructive) { action in
                do {
                    DBManager.manager.removeDocumentFromDB(document)
                    UserDefaults.standard.removeObject(forKey: document.id)
                    self.documents.removeAll(where: { $0.id == document.id })
                    DispatchQueue.main.async {
                        AppLoading.showSuccess(with: "Xoá tài liệu thành công", viewController: self)
                        self.reloadData()
                    }
                    
                    try FileManager.default.removeItem(atPath: document.path)
                    
                } catch {
                    print("TH Error: \(error)")
                }
            }
            let cancelAction = UIAlertAction(title: "Đóng", style: .cancel, handler: nil)
            
            alertController.addAction(removeAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true) {
            }
        }
        
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
