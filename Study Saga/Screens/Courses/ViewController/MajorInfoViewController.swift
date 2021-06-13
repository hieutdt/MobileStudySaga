//
//  MajorInfoViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 12/06/2021.
//

import Foundation
import UIKit
import AlamofireImage
import Masonry
import Charts


class MajorInfoVIewController: UIViewController {
    
    var major: Major!
    
    var headerBar = UIView()
    var titleLabel = UILabel()
    var dismissBtn = UIButton()
    
    var progressLabel = UILabel()
    var subjectLabel = UILabel()
    
    var chartView = PieChartView()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerBar.createViewBackgroundWithAppGradient()
    }
    
    // MARK: - UI Configure
    
    func setUpUI() {
        
        self.view.backgroundColor = .white
        
        // Set up  views.
        self.setUpHeaderBar()
        self.setUpPieChart()
        self.setUpTableView()
        
        // Set up dataset.
        self.setUpData()
    }
    
    func setUpHeaderBar() {
        
        headerBar.backgroundColor = .systemBlue
        self.view.addSubview(headerBar)
        headerBar.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.top.equalTo()(self.view.mas_top)
            make?.height.equalTo()(50 + getStatusBarHeight())
        }
        
        dismissBtn.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dismissBtn.addTarget(self, action: #selector(dismissBtnTapped), for: .touchUpInside)
        dismissBtn.tintColor = .white
        headerBar.addSubview(dismissBtn)
        dismissBtn.mas_makeConstraints { make in
            make?.leading.equalTo()(headerBar.mas_leading)?.offset()(10)
            make?.size.equalTo()(40)
            make?.bottom.equalTo()(headerBar.mas_bottom)?.offset()(-10)
        }
        
        headerBar.addSubview(titleLabel)
        titleLabel.text = major.name
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        titleLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(headerBar.mas_leading)
            make?.trailing.equalTo()(headerBar.mas_trailing)
            make?.centerY.equalTo()(dismissBtn.mas_centerY)
        }
    }
    
    func setUpPieChart() {
        self.view.addSubview(progressLabel)
        progressLabel.font = .systemFont(ofSize: 12)
        progressLabel.numberOfLines = 10
        progressLabel.textColor = .darkGray
        progressLabel.text = "Dưới đây là danh sách các môn học và tiến độ theo chuyên ngành \(self.major.name) gợi ý cho bạn. Sinh viên có thể tham khảo, theo dõi để học tập đủ các môn theo chuyên ngành mà mình mong muốn."
        progressLabel.mas_makeConstraints { make in
            make?.top.equalTo()(headerBar.mas_bottom)?.offset()(10)
            make?.leading.equalTo()(self.view.mas_leading)?.offset()(20)
            make?.trailing.equalTo()(self.view.mas_trailing)?.offset()(-20)
        }
        
        self.view.addSubview(chartView)
        chartView.mas_makeConstraints { make in
            make?.top.equalTo()(progressLabel.mas_bottom)?.offset()(10)
            make?.leading.equalTo()(self.view.mas_leading)?.offset()(20)
            make?.trailing.equalTo()(self.view.mas_trailing)?.offset()(-20)
            let viewHeight = self.view.bounds.height
            make?.height.equalTo()(viewHeight*0.4)
        }
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.register(RecommendTableCell.self, forCellReuseIdentifier: RecommendTableCell.reuseId)
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        self.view.addSubview(tableView)
        tableView.mas_makeConstraints { make in
            make?.top.equalTo()(chartView.mas_bottom)?.offset()(20)
            make?.leading.equalTo()(self.view.mas_leading)?.offset()(5)
            make?.trailing.equalTo()(self.view.mas_trailing)?.offset()(-5)
            make?.bottom.equalTo()(self.view.mas_bottom)?.offset()(-20)
        }
    }
    
    // MARK: - Action
    
    @objc func dismissBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Data
    
    func setUpData() {
        
        let learnedEntry = PieChartDataEntry(value: Double(self.major.processing), label: "Đã/đang học")
        let notLearnEntry = PieChartDataEntry(value: Double(self.major.count - self.major.processing), label: "Chưa học")
        let dataset = PieChartDataSet(entries: [learnedEntry, notLearnEntry], label: "")
        dataset.colors = [NSUIColor.init(red: 133/255, green: 193/255, blue: 233/255, alpha: 1),
                          NSUIColor(red: 250/255, green: 215/255, blue: 160/255, alpha: 1)]
        let data = PieChartData(dataSet: dataset)
        
        let highlight = Highlight(x: 0, y: 0, dataSetIndex: 0)
        
        self.chartView.data = data
        self.chartView.highlightValue(highlight)
        self.chartView.centerAttributedText = NSAttributedString(string: "Tiến độ học tập", attributes: [
            .font: UIFont(name: "HelveticaNeue-Medium", size: 22)!,
            .foregroundColor: UIColor.darkText
        ])
        
        self.chartView.notifyDataSetChanged()
    }
}

extension MajorInfoVIewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.major.subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(
                withIdentifier: RecommendTableCell.reuseId,
                for: indexPath) as? RecommendTableCell else {
            fatalError()
        }
        
        cell.model = self.major.subjects[indexPath.item]
        return cell
    }
}
