//
//  HomeViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 2/27/21.
//

import Foundation
import UIKit
import Combine
import AlamofireImage
import SkeletonView

let kMaxDeadlinesToShow: Int = 3

class HomeViewController: UIViewController {
    
    // MARK: - UI Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    var avatarShadowLayer = CAShapeLayer()
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var joinClassButton: UIButton!
    @IBOutlet weak var emptyLessonView: EmptyLessonView!
    @IBOutlet weak var nearestClassContainer: DampingButton!
    @IBOutlet weak var nearestClassName: UILabel!
    @IBOutlet weak var nearestClassTeacherName: UILabel!
    @IBOutlet weak var nearestClassStart: UILabel!
    
    @IBOutlet weak var showAllDeadlineButton: UIButton!
    @IBOutlet weak var deadlinesTableView: UITableView!
    @IBOutlet weak var deadlinesTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var openCourseButton: DampingButton!
    @IBOutlet weak var openCourseImageView: UIImageView!
    @IBOutlet weak var openCourseDummyButton: UIButton!
    
    var headerGradient = UIView()
    weak var headerGradientHeight: NSLayoutConstraint? = nil
    
    
    // MARK: - Data Models
    
    var viewModel = HomeViewModel()
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UI components and layouts.
        self.setUpUI()
        
        // Show all skeletons.
        self.showSkeleton()
        
        // Set up data binding between viewModel <-> views.
        self.dataBinding()
        
        // Fetch the logged in user infomations.
        self.viewModel.fetchUserInfo {
            self.nameLabel.hideSkeleton(transition: .crossDissolve(0.25))
            self.avatarImageView.hideSkeleton(transition: .crossDissolve(0.25))
        }
        
        self.nearestClassContainer.show()
        self.emptyLessonView.hide()
        
        self.viewModel.fetchComingLesson { lesson in
            self.emptyLessonView.hideSkeleton(transition: .crossDissolve(0.25))
            self.nearestClassContainer.hideSkeleton(transition: .crossDissolve(0.25))
            
            if lesson == nil {
                self.nearestClassContainer.hide()
                self.emptyLessonView.show()
            } else {
                self.emptyLessonView.hide()
                self.nearestClassContainer.show()
            }
        }
        
        self.viewModel.fetchNearDeadlines { isSuccess in
            self.deadlinesTableView.hideSkeleton(transition: .crossDissolve(0.25))
            self.deadlinesTableView.reloadData()
            self.view.setNeedsLayout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubviewToFront(nearestClassContainer)
    }
    
    func showSkeleton() {
        self.emptyLessonView.showAnimatedGradientSkeleton()
        self.nameLabel.showAnimatedGradientSkeleton()
        self.avatarImageView.showAnimatedGradientSkeleton()
        self.nearestClassContainer.showAnimatedGradientSkeleton()
        self.deadlinesTableView.showAnimatedGradientSkeleton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let numberOfRows = min(kMaxDeadlinesToShow, self.viewModel.deadlines.count)
        self.deadlinesTableViewHeight.constant = CGFloat(
            numberOfRows * 130 + (numberOfRows - 1) * 2
        )
    }
    
    // MARK: - UI Configure
    
    private func setUpUI() {
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.hide()
        
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = .white
        self.contentView.backgroundColor = .clear
        
        //-----------------------------------------------------------
        //  Header view
        //-----------------------------------------------------------
        
        self.nearestClassName.numberOfLines = 2
        self.nearestClassName.font = .boldSystemFont(ofSize: 28)
        
        self.avatarImageView.layer.cornerRadius = 30
        self.avatarImageView.layer.borderWidth = 3
        self.avatarImageView.layer.borderColor = UIColor(hexString: "#E8E8E9").cgColor
        self.avatarImageView.image = UIImage(named: "avatar")
        
        self.nearestClassContainer.layer.cornerRadius = 25
        self.nearestClassContainer.backgroundColor = .white
        self.nearestClassContainer.layer.shadowColor = UIColor.black.cgColor
        self.nearestClassContainer.layer.shadowOpacity = 0.05
        self.nearestClassContainer.layer.shadowRadius = 10
        self.nearestClassContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
    
        self.nearestClassName.isSkeletonable = true
        self.nearestClassTeacherName.isSkeletonable = true
        self.nearestClassStart.isSkeletonable = true
        self.joinClassButton.isSkeletonable = true
        self.joinClassButton.addTarget(self,
                                       action: #selector(nearestClassButtonTapped),
                                       for: .touchUpInside)
        self.joinClassButton.setTitleColor(.white, for: .normal)
        self.joinClassButton.setBackgroundColor(color: .appRed, forState: .normal)
        self.joinClassButton.setBackgroundColor(color: UIColor(hexString: "#A93226"),
                                                forState: .highlighted)
        self.joinClassButton.layer.cornerRadius = 20
        
        self.emptyLessonView.hide()
        
        self.showAllDeadlineButton.tintColor = .primary
        
        //-----------------------------------------------------------
        //  Set up deadlines table view
        //----------------------------------------------------- ------
        self.deadlinesTableView.delegate = self
        self.deadlinesTableView.dataSource = self
        self.deadlinesTableView.isSkeletonable = true
        self.deadlinesTableView.tableFooterView = UIView()
        self.deadlinesTableView.backgroundColor = .white
        self.deadlinesTableView.separatorStyle = .none
        self.deadlinesTableView.isScrollEnabled = false
        self.deadlinesTableView.showsVerticalScrollIndicator = false
        self.deadlinesTableView.allowsSelection = false
        self.deadlinesTableView.register(
            DeadlineTableCell.self,
            forCellReuseIdentifier: DeadlineTableCell.reuseId
        )
        self.deadlinesTableView.backgroundColor = .clear
        
        //-----------------------------------------------------------
        //  Open courses
        //-----------------------------------------------------------
        self.openCourseImageView.image = UIImage(named: "online_learning")
        self.openCourseImageView.contentMode = .scaleAspectFill
        
        self.openCourseButton.layer.masksToBounds = true
        self.openCourseButton.layer.cornerRadius = 25
        self.openCourseButton.backgroundColor = .appBlack
        self.openCourseButton.addTarget(self,
                                        action: #selector(openCourseButtonTapped),
                                        for: .touchUpInside)
        
        self.openCourseDummyButton.isUserInteractionEnabled = false
        self.openCourseDummyButton.layer.cornerRadius = 10
        
        headerHeight.constant = 100 + getStatusBarHeight()
        
        scrollView.addSubview(headerGradient)
        headerGradient.backgroundColor = .primary
        scrollView.bringSubviewToFront(contentView)
        headerGradient.mas_makeConstraints { make in
            make?.leading.equalTo()(scrollView.mas_leading)
            make?.trailing.equalTo()(scrollView.mas_trailing)
            make?.top.equalTo()(scrollView.mas_top)
        }
        headerGradientHeight = headerGradient.heightAnchor.constraint(equalToConstant: 250)
        headerGradientHeight?.isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerGradient.createViewBackgroundWithAppGradient()
    }
    
    // MARK: - Data Binding
    
    private func dataBinding() {
        
        self.viewModel.$avatarUrl
            .receive(on: DispatchQueue.main)
            .sink { avatarUrl in
                guard let url = URL(string: avatarUrl) else {
                    self.avatarImageView.image = UIImage(named: "avatar")
                    return
                }
                
                self.avatarImageView.af.setImage(withURL: url)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$userName
            .receive(on: DispatchQueue.main)
            .sink { userName in
                self.nameLabel.text = userName
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$deadlines
            .receive(on: DispatchQueue.main)
            .sink { dealines in
                self.deadlinesTableView.reloadData()
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$comingLesson
            .receive(on: DispatchQueue.main)
            .sink { lesson in
                if let lesson = lesson {
                    self.nearestClassName.text = lesson.courseName
                    self.nearestClassTeacherName.text = lesson.lessonName
                    self.nearestClassStart.text = .nearDateFormat(timeInterval: lesson.dateStart)
                }
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Actions
    
    @objc func nearestClassButtonTapped() {
        print("nearestClassButtonTapped()")
        
        let actionSheet = UIAlertController(title: self.nearestClassName.text,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let joinAction = UIAlertAction(title: "Tham gia", style: .default) { action in
            // Join handle
            if let lesson = self.viewModel.comingLesson {
                let vc = UIStoryboard.courses.viewController(JoinMeetingViewController.self)
                vc.lesson = lesson
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel)
        
        actionSheet.addAction(joinAction)
        actionSheet.addAction(cancelAction)
        
        // Present action sheet.
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func openCourseButtonTapped() {
        let vc = UIStoryboard.register.viewController(RegisterCourseViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.deadlines.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DeadlineTableCell.reuseId
        ) as? DeadlineTableCell else {
            fatalError("DeadLineTableCell is not registed.")
        }
        
        let deadline = self.viewModel.deadlines[indexPath.row]
        cell.deadline = deadline
        cell.delegate = self
        
        return cell
    }
}

extension HomeViewController: DeadlineTableCellDelegate {
    
    func didSelectCell(_ cell: DeadlineTableCell) {
        if let indexPath = self.deadlinesTableView.indexPath(for: cell) {
            let deadline = self.viewModel.deadlines[indexPath.row]
            let vc = UIStoryboard.courses.viewController(DeadlineViewController.self)
            vc.deadline = deadline
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(
        _ skeletonView: UITableView,
        cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        
        return DeadlineTableCell.reuseId
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView,
                                numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let offset = scrollView.contentOffset
            if offset.y < 0 {
                let scaleFactor = 1 + (-1 * offset.y / (headerGradientHeight!.constant/2.0))
                self.headerGradient.layer.transform = CATransform3DScale(
                    CATransform3DTranslate(CATransform3DIdentity, 0, offset.y, 0),
                    scaleFactor,
                    scaleFactor,
                    1
                )
                
            } else {
                self.headerGradient.layer.transform = CATransform3DIdentity
            }
        }
    }
}

func getStatusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}
