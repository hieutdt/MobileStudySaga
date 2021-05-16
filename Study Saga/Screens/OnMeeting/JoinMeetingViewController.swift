//
//  JoinMeetingViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/10/21.
//

import Foundation
import UIKit
import Combine
import MobileRTC


class JoinMeetingViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var displayNameTextField: SSTextField!
    @IBOutlet weak var joinClassButton: UIButton!
    @IBOutlet weak var lessonNameLabel: UILabel!
    
    var viewModel = MeetingViewModel()
    
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    var lesson: Lesson!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
        classNameLabel.text = lesson.courseName
        teacherNameLabel.text = lesson.teacherName
        lessonNameLabel.text = lesson.lessonName
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        MobileRTC.shared().setMobileRTCRootController(self.navigationController!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hide()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpUI() {
        
        self.title = "Tham gia lớp học"
        self.navigationController?.navigationBar.show()
        
        displayNameTextField.placeholder = "Tên hiển thị trong lớp học"
        displayNameTextField.text = "1712441 - Trần Đình Tôn Hiếu"
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(contentViewDidTap))
        contentView.addGestureRecognizer(tapGesture)
        
        joinClassButton.setGradient()
        joinClassButton.setTitleColor(.white, for: .normal)
        joinClassButton.layer.cornerRadius = 20
        joinClassButton.layer.masksToBounds = true
        joinClassButton.addTarget(self,
                                  action: #selector(joinMeetingDidTap),
                                  for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.contentViewBottomConstraint?.constant = 0.0
        } else {
            self.contentViewBottomConstraint?.constant = endFrame?.size.height ?? 0.0
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
    
    @objc func contentViewDidTap() {
        self.view.endEditing(true)
    }
    
    @objc func joinMeetingDidTap() {
//        let vc = CheckInViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        self.viewModel.joinMeeting()
    }
}
