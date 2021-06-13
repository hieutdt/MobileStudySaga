//
//  DeadlineViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 4/7/21.
//

import Foundation
import UIKit
import Masonry
import Combine
import SkeletonView


class DeadlineViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameTitleLabel: UILabel!
    
    @IBOutlet weak var submitStateLabel: UILabel!
    @IBOutlet weak var submitStateView: UIView!
    
    @IBOutlet weak var deadlineDescLabel: UILabel!
    @IBOutlet weak var deadlineFileLinkTableView: UITableView!
    @IBOutlet weak var deadlineTimeLabel: UILabel!
    @IBOutlet weak var deadlineLeftTimeLabel: UILabel!
    @IBOutlet weak var deadlineTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var submitTableView: UITableView!
    @IBOutlet weak var submitCheckBtn: UIButton!
    @IBOutlet weak var submitTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - View Model
    
    var deadline: Deadline!
    
    var isChecked: Bool = false
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0 ... 5 {
            var doc = DocumentModel()
            doc.type = .pdf
            doc.name = "YeuCauBaiTap1.pdf"
            self.deadline.deadlineDocuments.append(doc)
        }
        
        for _ in 0...1 {
            var doc = DocumentModel()
            doc.type = .pdf
            doc.name = "1712441_Baitap1.pdf"
            self.deadline.submitDocuments.append(doc)
        }
        
        self.setUpUI()
        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.show()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let deadlineTableRows = max(self.deadline.deadlineDocuments.count, 3)
        self.deadlineTableHeight.constant = CGFloat(deadlineTableRows * 40)
        
        let submitTableRows = max(self.deadline.submitDocuments.count, 2)
        self.submitTableHeight.constant = CGFloat(submitTableRows * 40)
    }
    
    func reloadData() {
        self.submitTableView.reloadData()
        self.deadlineFileLinkTableView.reloadData()
    }
    
    // MARK: - UI Configure
    
    private func setUpUI() {
        
        self.title = "Thông tin bài tập"
        
        submitStateView.layer.cornerRadius = 5
        
        scrollView.backgroundColor = .white
        contentView.backgroundColor = .white
        
        nameTitleLabel.text = deadline.deadlineName
        
        saveButton.setGradient()
        saveButton.layer.cornerRadius = 20
        saveButton.layer.masksToBounds = true
        saveButton.setTitleColor(.white, for: .normal)
        
        deadlineFileLinkTableView.delegate = self
        deadlineFileLinkTableView.dataSource = self
        deadlineFileLinkTableView.backgroundColor = .clear
        deadlineFileLinkTableView.tableFooterView = UIView()
        deadlineFileLinkTableView.separatorStyle = .none
        deadlineFileLinkTableView.register(
            FileLinkTableCell.self,
            forCellReuseIdentifier: FileLinkTableCell.reuseId
        )
        
        submitTableView.delegate = self
        submitTableView.dataSource = self
        submitTableView.backgroundColor = .clear
        submitTableView.tableFooterView = UIView()
        submitTableView.separatorStyle = .none
        submitTableView.register(
            FileLinkTableCell.self,
            forCellReuseIdentifier: FileLinkTableCell.reuseId
        )
        
        submitCheckBtn.layer.borderWidth = 2
        submitCheckBtn.layer.borderColor = UIColor.systemGreen.cgColor
        submitCheckBtn.layer.cornerRadius = 2
        submitCheckBtn.addTarget(self,
                                 action: #selector(submitCheckBtnDidTap),
                                 for: .touchUpInside)
        submitCheckBtn.setBackgroundColor(color: .white, forState: .normal)
        submitCheckBtn.setBackgroundColor(color: .selectedBackground, forState: .highlighted)
        submitCheckBtn.tintColor = .white
        
        if self.deadline.isSubmitted {
            self.submitStateView.show()
            self.titleLabelBottom.constant = 60
        } else {
            self.submitStateView.hide()
            self.titleLabelBottom.constant = 20
        }
        
        deadlineDescLabel.text = deadline.detail
        
        self.isChecked = self.deadline.isSubmitted
        self.updateSubmitCheckBtn()
    }
    
    @objc func submitCheckBtnDidTap() {
        if isChecked {
            isChecked = false
            self.updateSubmitCheckBtn()
        } else {
            isChecked = true
            self.updateSubmitCheckBtn()
        }
    }
    
    func updateSubmitCheckBtn() {
        if isChecked {
            submitCheckBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
            submitCheckBtn.setBackgroundColor(color: .systemGreen, forState: .normal)
        } else {
            submitCheckBtn.setImage(UIImage(), for: .normal)
            submitCheckBtn.setBackgroundColor(color: .white, forState: .normal)
        }
    }
}

extension DeadlineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension DeadlineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == deadlineFileLinkTableView {
            return self.deadline.deadlineDocuments.count
        } else {
            return self.deadline.submitDocuments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FileLinkTableCell.reuseId
        ) as? FileLinkTableCell else {
            fatalError("FileLinkTableCell was not registed!")
        }
        
        if tableView == deadlineFileLinkTableView {
            cell.document = self.deadline.deadlineDocuments[indexPath.row]
        } else {
            cell.document = self.deadline.submitDocuments[indexPath.row]
        }
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .selectedBackground
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
}
