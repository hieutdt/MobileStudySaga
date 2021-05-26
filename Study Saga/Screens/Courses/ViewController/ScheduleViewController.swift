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
import EventKit


class ScheduleViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var chooseDateButton = UIButton()
    
    var monthYearPicker = MonthYearPickerView()
    weak var pickerBottom: NSLayoutConstraint? = nil
    
    var pickerToolView = UIView()
    var pickerCancelBtn = UIButton()
    var pickerDoneBtn = UIButton()
    
    let eventStore = EKEventStore()
    
    // MARK: - Data Model
    
    var viewModel = ScheduleViewModel()
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.fetchData()
    }
    
    func setUpUI() {
        self.headerView.backgroundColor = .primary
        self.headerView.layer.masksToBounds = false
        self.headerView.layer.shadowColor = UIColor.black.cgColor
        self.headerView.layer.shadowRadius = 5
        self.headerView.layer.shadowOpacity = 0.05
        self.headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        self.view.bringSubviewToFront(self.headerView)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        self.timeButton.setTitle("Tháng " + dateFormatter.string(from: date), for: .normal)
        self.timeButton.addTarget(self,
                                  action: #selector(dateButtonTapped),
                                  for: .touchUpInside)
        self.timeButton.setTitleColor(.systemBlue, for: .normal)
        self.timeButton.setTitleColor(.blue, for: .highlighted)
        self.timeButton.setTitleColor(.lightText, for: .normal)
        
        tableView.dataSource = self
        tableView.rowHeight = 250
        tableView.isSkeletonable = true
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .background
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(
            ScheduleTableCell.self,
            forCellReuseIdentifier: ScheduleTableCell.reuseId
        )
        
        monthYearPicker.backgroundColor = .white
        self.view.addSubview(monthYearPicker)
        monthYearPicker.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.height.equalTo()(150)
        }
        pickerBottom = monthYearPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        pickerBottom?.constant = 300
        pickerBottom?.isActive = true
        
        pickerToolView = UIView()
        pickerToolView.backgroundColor = UIColor.white
        self.view.addSubview(pickerToolView)
        pickerToolView.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.height.equalTo()(50)
            make?.bottom.equalTo()(monthYearPicker.mas_top)
        }
        
        pickerCancelBtn.setTitle("Huỷ", for: .normal)
        pickerCancelBtn.setTitleColor(.systemBlue, for: .normal)
        pickerCancelBtn.setTitleColor(.blue, for: .highlighted)
        pickerCancelBtn.addTarget(self,
                                  action: #selector(cancelPicker),
                                  for: .touchUpInside)
        pickerToolView.addSubview(pickerCancelBtn)
        pickerCancelBtn.mas_makeConstraints { make in
            make?.top.equalTo()(pickerToolView.mas_top)
            make?.bottom.equalTo()(pickerToolView.mas_bottom)
            make?.leading.equalTo()(pickerToolView.mas_leading)?.offset()(20)
        }
        
        pickerDoneBtn.setTitle("Xong", for: .normal)
        pickerDoneBtn.setTitleColor(.systemBlue, for: .normal)
        pickerDoneBtn.setTitleColor(.blue, for: .highlighted)
        pickerDoneBtn.addTarget(self,
                                action: #selector(donePicker),
                                for: .touchUpInside)
        pickerToolView.addSubview(pickerDoneBtn)
        pickerDoneBtn.mas_makeConstraints { make in
            make?.top.equalTo()(pickerToolView.mas_top)
            make?.bottom.equalTo()(pickerToolView.mas_bottom)
            make?.trailing.equalTo()(pickerToolView.mas_trailing)?.offset()(-20)
        }
        
        headerView.addSubview(chooseDateButton)
        let btnImage = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysTemplate)
        chooseDateButton.setBackgroundColor(color: UIColor(hexString: "#FADBD8"),
                                            forState: .normal)
        chooseDateButton.setBackgroundColor(color: UIColor(hexString: "#EC7063"),
                                            forState: .highlighted)
        chooseDateButton.setImage(btnImage, for: .normal)
        chooseDateButton.tintColor = UIColor(hexString: "#E74C3C")
        chooseDateButton.addTarget(self,
                                   action: #selector(dateButtonTapped),
                                   for: .touchUpInside)
        chooseDateButton.mas_makeConstraints { make in
            make?.trailing.equalTo()(headerView.mas_trailing)?.offset()(-20)
            make?.size.equalTo()(40)
            make?.centerY.equalTo()(headerView.mas_centerY)
        }
        chooseDateButton.layer.cornerRadius = 10
    }
    
    func fetchData() {
        self.tableView.showAnimatedGradientSkeleton()
        self.viewModel.fetchLessons { isSuccess in
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton()
            
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.reloadData()
        }
    }
    
    func addEventToCalendar(_ lesson: Lesson) {
        eventStore.requestAccess(to: .event) { [self] granted, error in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(String(describing: error))")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = lesson.courseName
                event.startDate = Date(timeIntervalSince1970: lesson.dateStart)
                event.endDate = Date(timeIntervalSince1970: lesson.dateEnd)
                event.notes = lesson.lessonName
                event.calendar = eventStore.defaultCalendarForNewEvents

                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                    AppLoading.showFailed(with: "Thêm sự kiện vào Lịch thất bại",
                                          viewController: self)
                }
                
                UserDefaults.standard.setValue(1, forKey: lesson.id)
                
                DispatchQueue.main.async {
                    AppLoading.showSuccess(with: "Thêm sự kiện vào Lịch thành công",
                                           viewController: self)
                    self.tableView.reloadData()
                }
                
            } else {
                print("failed to save event with error : \(String(describing: error)) or access not granted")
                AppLoading.showFailed(with: "Thêm sự kiện vào Lịch thất bại",
                                      viewController: self)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func dateButtonTapped() {
        let isHidden = (pickerBottom?.constant == 300)
        if isHidden {
            pickerBottom?.constant = -80
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {
            pickerBottom?.constant = 300
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func donePicker() {
        pickerBottom?.constant = 300
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { success in
            let month = self.monthYearPicker.month
            let year = self.monthYearPicker.year
            let string = String(format: "%02d/%d", month, year)
            self.timeButton.setTitle("Tháng " + string, for: .normal)
            
            // TODO: Reload data
            
        }
    }
    
    @objc func cancelPicker() {
        pickerBottom?.constant = 300
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ScheduleViewController: ScheduleTableCellDelegate {
    func scheduleCellDidSelected(_ cell: ScheduleTableCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            let index = indexPath.item
            let lesson = self.viewModel.schedules[index]
            self.showAddCalendarAlert(lesson)
        }
    }
    
    func showAddCalendarAlert(_ lesson: Lesson) {
        let actionSheet = UIAlertController(title: "Bạn có muốn thêm tiết học này vào ứng dụng Lịch?",
                                            message: "\(lesson.courseName) - \(lesson.lessonName)",
                                            preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Đồng ý", style: .default) { action in
            self.addEventToCalendar(lesson)
        }
        
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        
        actionSheet.addAction(okAction)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension ScheduleViewController: SkeletonTableViewDataSource {
    
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
        if UserDefaults.standard.integer(forKey: schedule.id) == 1 {
            cell.isAddedToCalendar = true
        } else {
            cell.isAddedToCalendar = false
        }
        cell.delegate = self
        
        if indexPath.item == 0 {
            cell.isNearestClass = true
        }
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView,
                                cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return ScheduleTableCell.reuseId
    }
}
