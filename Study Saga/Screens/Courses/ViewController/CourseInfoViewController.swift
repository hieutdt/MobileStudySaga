//
//  CourseInfoViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/4/21.
//

import Foundation
import UIKit
import Combine
import AlamofireImage
import PDFKit
import FileKit


class CourseInfoViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var navigationBackBtn: UIButton!
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var teacherIconImgView: UIImageView!
    @IBOutlet weak var teacherNameLabel: UILabel!
    
    @IBOutlet weak var ratingInfoBox: InfoBoxView!
    @IBOutlet weak var lessonNumberInfoBox: InfoBoxView!
    @IBOutlet weak var languageInfoxBox: InfoBoxView!
    
    @IBOutlet weak var lessonNumberLabel: UILabel!
    @IBOutlet weak var joinClassContainer: UIView!
    @IBOutlet weak var joinClassButton: UIButton!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var joinClassTeacherName: UILabel!
    @IBOutlet weak var joinClassEmptyView: EmptyDeadlinesView!
    @IBOutlet weak var joinClassStatusLabel: UILabel!
    
    @IBOutlet weak var documentTableView: UITableView!
    @IBOutlet weak var documentTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var deadlineTableView: UITableView!
    @IBOutlet weak var deadlineTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var emptyDocumentLabel: UILabel!
    @IBOutlet weak var emptyDeadlineLabel: UILabel!
    
    @IBOutlet weak var separatorLine1: UIView!
    @IBOutlet weak var separatorLine2: UIView!
    @IBOutlet weak var separatorLine4: UIView!
    
    let separatorLineBackground = UIColor(hexString: "#E7E7E8")
    
    // MARK: - Data model
    
    var course: Course? {
        didSet {
            if let course = course {
                self.viewModel = CourseInfoViewModel(course: course)
            }
        }
    }
    
    var viewModel: CourseInfoViewModel!
    var cancellables = Set<AnyCancellable>()
    
    var notiTableViewDataSource: NotiDataSource?
    var documentTableViewDataSource: DocumentDataSource?
    
    var lastContentOffset: CGFloat = 0
    
    let backgroundColor = UIColor.white
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.createDocumentDiffableDataSource()
        self.dataBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hide()
    }
    
    private func setUpUI() {
        
        self.setUpNavigationBar()
        
        self.view.backgroundColor = backgroundColor
        self.contentView.backgroundColor = backgroundColor
        if let scrollView = self.contentView.superview as? UIScrollView {
            scrollView.backgroundColor = backgroundColor
            scrollView.delegate = self
        }
        
        courseImageView.contentMode = .scaleAspectFill
        
        teacherIconImgView.tintColor = .darkGray
        teacherIconImgView.image = UIImage(named: "teacher")?.withRenderingMode(.alwaysTemplate)
        teacherNameLabel.textColor = .darkGray
        
        separatorLine1.backgroundColor = separatorLineBackground
        separatorLine2.backgroundColor = separatorLineBackground
        separatorLine4.backgroundColor = separatorLineBackground
        
        joinClassContainer.layer.cornerRadius = 20
        joinClassContainer.backgroundColor = .appGray
        
        joinClassButton.backgroundColor = .white
        joinClassButton.setGradient()
        joinClassButton.layer.cornerRadius = 20
        joinClassButton.layer.masksToBounds = true
        joinClassButton.setTitleColor(.white, for: .normal)
        joinClassButton.setTitle("Tham gia học ngay", for: .normal)
        joinClassButton.addTarget(self,
                                  action: #selector(joinClassButtonTapped),
                                  for: .touchUpInside)
        
        lessonNumberLabel.textColor = .darkGray
        classNameLabel.textColor = .black
        joinClassTeacherName.textColor = .darkGray
        joinClassStatusLabel.textColor = .systemGreen
        
        joinClassEmptyView.setEmptyView(
            with: "Chúc mừng bạn đã hoàn thành tất cả tiết học",
            image: UIImage(named: "smile2")!,
            backgroundColor: UIColor(hexString: "#F0F0F1")
        )
        joinClassEmptyView.label.textColor = .darkGray
        joinClassEmptyView.imageView.tintColor = .darkGray
        joinClassEmptyView.hide()
        
        emptyDocumentLabel.textColor = .darkGray
        emptyDocumentLabel.hide()
        
        emptyDeadlineLabel.textColor = .darkGray
        emptyDeadlineLabel.hide()
        
        documentTableView.delegate = self
        documentTableView.backgroundColor = .clear
        documentTableView.separatorStyle = .none
        documentTableView.allowsSelection = false
        documentTableView.tableFooterView = UIView()
        documentTableView.register(
            FileLinkTableCell.self,
            forCellReuseIdentifier: FileLinkTableCell.reuseId
        )
        
        deadlineTableView.delegate = self
        deadlineTableView.backgroundColor = .clear
        deadlineTableView.dataSource = self
        deadlineTableView.separatorStyle = .none
        deadlineTableView.allowsSelection = false
        deadlineTableView.tableFooterView = UIView()
        deadlineTableView.register(
            DeadlineTableCell.self,
            forCellReuseIdentifier: DeadlineTableCell.reuseId
        )
        
        self.setUpInfoBoxs()
    }
    
    private func setUpNavigationBar() {
        self.navigationView.backgroundColor = backgroundColor
        self.navigationView.alpha = 0
        
        self.navigationBackBtn.backgroundColor = .clear
        self.navigationBackBtn.setImage(
            UIImage(systemName: "chevron.left"),
            for: .normal
        )
        self.navigationBackBtn.setTitle("", for: .normal)
        self.navigationBackBtn.tintColor = .white
        self.navigationBackBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.navigationBackBtn.layer.cornerRadius = 20
        self.navigationBackBtn.addTarget(self,
                                         action: #selector(backButtonTapped),
                                         for: .touchUpInside)
        
        self.navigationTitleLbl.textColor = .black
        self.navigationTitleLbl.text = self.course?.className
        self.navigationTitleLbl.alpha = 0
    }
    
    func setUpInfoBoxs() {
        self.ratingInfoBox.setInfoBox("ĐÁNH GIÁ", desc: "4.5")
        self.lessonNumberInfoBox.setInfoBox("SỐ TIẾT", desc: "12")
        self.languageInfoxBox.setInfoBox("NGÔN NGỮ", desc: "ENG")
    }
    
    // MARK: - Create Table View
    
    typealias NotiDataSource = UITableViewDiffableDataSource<Int, Notification>
    typealias NotiSnapshot = NSDiffableDataSourceSnapshot<Int, Notification>
    private lazy var updateNotiDataSourcePublisher = self.viewModel.$course
        .map { course -> NotiSnapshot in
            var snapshot = NotiSnapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(course!.notifications)
            return snapshot
        }
        .makeConnectable()
    
    typealias DocumentDataSource = UITableViewDiffableDataSource<Int, DocumentModel>
    typealias DocumentSnapshot = NSDiffableDataSourceSnapshot<Int, DocumentModel>
    private lazy var updateDocumentDataSourcePublisher = self.viewModel.$course
        .map { course -> DocumentSnapshot in
            var snapshot = DocumentSnapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(course!.documents)
            return snapshot
        }
        .makeConnectable()
    
    private func createDocumentDiffableDataSource() {
        
        // Create diffable datasource
        let datasource = DocumentDataSource(tableView: self.documentTableView)
        { [weak self] tableView, indexPath, document -> UITableViewCell? in
            guard let self = self else {
                return nil
            }
            
            let documents = self.viewModel.course.documents
            
            if let document = documents.first(where: { $0.id == document.id }) {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: FileLinkTableCell.reuseId
                ) as? FileLinkTableCell else {
                    return nil
                }
                
                cell.document = document
                cell.delegate = self
                if indexPath.row % 2 == 0 {
                    cell.setBackground(UIColor(hexString: "#F0F0F1"))
                } else {
                    cell.setBackground(.white)
                }
                
                return cell
            }
            
            return UITableViewCell()
        }
        
        self.documentTableViewDataSource = datasource
        
        // Apply initialize snapshot
        var initializeSnapshot = DocumentSnapshot()
        initializeSnapshot.appendSections([0])
        initializeSnapshot.appendItems(self.viewModel.course!.documents)
        datasource.apply(initializeSnapshot, animatingDifferences: false) {
            // Begin receiving updates.
            self.updateDocumentDataSourcePublisher
                .connect()
                .store(in: &self.cancellables)
        }
    }
    
    // MARK: - Data Binding
    
    private func dataBinding() {
        
        self.updateDocumentDataSourcePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                guard let datasource = self?.documentTableViewDataSource else {
                    return
                }
                
                datasource.apply(snapshot, animatingDifferences: false) {
                    // Update table view height
                    guard let self = self else {
                        return
                    }
                    
                    self.documentTableHeight.constant =
                        CGFloat(60 * self.viewModel.course.documents.count)
                }
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$course
            .receive(on: DispatchQueue.main)
            .sink { course in
                if let course = course {
                    if let url = URL(string: course.courseImageUrl) {
                        self.courseImageView.af.setImage(withURL: url)
                    }
                    
                    self.courseNameLabel.text = course.className
                    self.teacherNameLabel.text = course.teacherName
                    
                    if let nextLesson = course.nextLesson() {
                        self.classNameLabel.text = nextLesson.lessonName
                        self.lessonNumberLabel.text = "Tiết \(nextLesson.lessonNumber)"
                        self.joinClassTeacherName.text = nextLesson.teacherName
                        self.joinClassButton.show()
                        self.joinClassEmptyView.hide()
                        
                        // Check class was started or not to update the button's state.
                        let nowTs = Date().timeIntervalSince1970
                        if nextLesson.dateStart - 5*60 >= nowTs &&
                            nowTs <= nextLesson.dateEnd {
                            self.joinClassButton.isEnabled = true
                            self.joinClassButton.applyGradient(colors: [
                                UIColor.gradientFirst.cgColor,
                                UIColor.gradientLast.cgColor
                            ])
                        } else {
                            self.joinClassButton.isEnabled = false
                            self.joinClassButton.applyGradient(colors: [
                                UIColor(hexString: "#bdc3c7").cgColor,
                                UIColor(hexString: "#2c3e50").cgColor
                            ])
                        }
                        
                    } else {
                        self.joinClassEmptyView.show()
                    }
                    
                    if course.deadlines.isEmpty {
                        self.emptyDeadlineLabel.show()
                        self.deadlineTableView.hide()
                        self.deadlineTableHeight.constant = 80
                    } else {
                        self.emptyDeadlineLabel.hide()
                        self.deadlineTableView.show()
                        self.deadlineTableHeight.constant = self.deadlineTableView.contentSize.height
                    }
                    
                    if course.documents.isEmpty {
                        self.emptyDocumentLabel.show()
                        self.documentTableView.hide()
                        self.documentTableHeight.constant = 80
                    } else {
                        self.emptyDocumentLabel.hide()
                        self.documentTableView.show()
                        self.documentTableHeight.constant = self.documentTableView.contentSize.height
                    }
                }
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Actions
    
    @objc func joinClassButtonTapped() {
        if let lesson = self.viewModel.course.nextLesson() {
            let vc = UIStoryboard.courses.viewController(JoinMeetingViewController.self)
            vc.lesson = lesson
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
        }
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CourseInfoViewController: UITableViewDelegate {
    
}

extension CourseInfoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Update image view.
        let offset = scrollView.contentOffset
        if offset.y < 0 {
            let scaleFactor = 1 + (-1 * offset.y / (courseImageViewHeight.constant/2.0))
            self.courseImageView.layer.transform = CATransform3DScale(
                CATransform3DTranslate(CATransform3DIdentity, 0, offset.y, 0),
                scaleFactor,
                scaleFactor,
                1
            )
        } else {
            self.courseImageView.layer.transform = CATransform3DIdentity
        }
        
        // Show shadow if needed
        if offset.y >= 200 {
            self.navigationView.layer.shadowColor = UIColor.black.cgColor
            self.navigationView.layer.shadowOpacity = 0.1
            self.navigationView.layer.shadowRadius = 2
            self.navigationView.layer.shadowOffset = CGSize(width: 0, height: 2)
        } else {
            self.navigationView.layer.shadowOpacity = 0
        }
        
        // Update navigation bar's transparent.
        let alpha = scrollView.contentOffset.y / 200
        self.navigationView.alpha = alpha
        self.navigationTitleLbl.alpha = alpha
        
        let backgroundColorRGB = alpha
        let textColorRGB = 1 - alpha
        self.navigationBackBtn.tintColor = UIColor(red: textColorRGB,
                                                   green: textColorRGB,
                                                   blue: textColorRGB,
                                                   alpha: 1)
        if backgroundColorRGB < 1 {
            self.navigationBackBtn.backgroundColor = UIColor(red: backgroundColorRGB,
                                                             green: backgroundColorRGB,
                                                             blue: backgroundColorRGB,
                                                             alpha: 0.3)
        } else {
            self.navigationBackBtn.backgroundColor = backgroundColor
        }
    }
}

extension CourseInfoViewController: DocumentTableCellDelegate {
    
    func didSelectDocumentCell(_ cell: DocumentTableCell) {
        if let indexPath = self.documentTableView.indexPath(for: cell) {
            let document = self.viewModel.course.documents[indexPath.row]
            let actionSheet = UIAlertController(title: document.name,
                                                message: "Bạn có muốn tải xuống để xem không?",
                                                preferredStyle: .actionSheet)
            let downloadAction = UIAlertAction(title: "Tải xuống", style: .default) { action in
                
            }
            
            let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel)
            
            actionSheet.addAction(downloadAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
}

extension CourseInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.course.deadlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DeadlineTableCell.reuseId
        ) as? DeadlineTableCell else {
            fatalError("DeadlineTableCell has not registed!")
        }
        
        cell.deadline = self.viewModel.course.deadlines[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension CourseInfoViewController: DeadlineTableCellDelegate {
    
    func didSelectCell(_ cell: DeadlineTableCell) {
        if let indexPath = self.deadlineTableView.indexPath(for: cell) {
            let index = indexPath.row
            let deadline = self.viewModel.course.deadlines[index]
            let vc = UIStoryboard.courses.viewController(DeadlineViewController.self)
            vc.deadline = deadline
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CourseInfoViewController: FileLinkTableCellDelegate {
    
    func didSelectCell(_ cell: FileLinkTableCell) {
        if let indexPath = self.documentTableView.indexPath(for: cell) {
            let index = indexPath.row
            var document = self.viewModel.course.documents[index]
            
            if UserDefaults.standard.string(forKey: document.id) != nil {
                document.downloaded = true
            } else {
                document.downloaded = false
            }
            
            if document.downloaded {
                // Read action
                let alert = UIAlertController(title: document.name,
                                              message: "Tài liệu đã được tải sẵn, việc đọc sẽ không tốn tài nguyên mạng",
                                              preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel)
                let readAction = UIAlertAction(title: "Đọc",
                                               style: .default) { action in
                    let documentDiskUrl = UserDefaults.standard.string(forKey: document.id)
                    self.openDocumentWithName(document.name, urlString: documentDiskUrl!) {
                        // Failure
                        UserDefaults.standard.removeObject(forKey: document.id)
                        AppLoading.showFailed(with: "File không tồn tại. Vui lòng thử tải lại.", viewController: self)
                    }
                }
                
                alert.addAction(readAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                // Download file first
                let alert = UIAlertController(title: document.name,
                                              message: "Tài liệu chưa có sẵn, bạn có muốn tiến hành tải file?",
                                              preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel)
                let downloadAction = UIAlertAction(title: "Tải xuống",
                                                   style: .default) { action in
                    
                    AppLoading.showProgress(0, viewController: self)
                    
                    FileDownloadManager.manager.startDownloadFileWith(url: document.path,
                                                                      fileName: document.name) { progress in
                        AppLoading.showProgress(Float(progress), viewController: self)
                        
                    } completionBlock: { url, error in
                        
                        AppLoading.showSuccess(with: "Tải thành công", viewController: self)
                        
                        document.courseName = self.course!.className
                        UserDefaults.standard.setValue(url, forKey: document.id)
                        DBManager.manager.saveDocumentInfoToDB(document)
                        
                        self.openDocumentWithName(document.name, urlString: url) {
                            UserDefaults.standard.removeObject(forKey: document.id)
                            
                            AppLoading.showFailed(with: "File không tồn tại. Vui lòng thử tải lại", viewController: self)
                        }
                    }
                }
                
                alert.addAction(downloadAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func openDocumentWithName(_ name: String,
                              urlString: String,
                              failure: @escaping () -> Void) {
        // Check data
        if let url = URL(string: urlString) {
            let document = PDFDocument(url: url)
            if document == nil {
                failure()
                return
            }
            
            if document?.pageCount == 0 {
                failure()
                return
            }
        }
        
        let pdfViewController = PDFViewController()
        pdfViewController.modalPresentationStyle = .fullScreen
        pdfViewController.documentUrl = urlString
        pdfViewController.titleText = name
        
        self.present(pdfViewController, animated: true, completion: nil)
    }
}
