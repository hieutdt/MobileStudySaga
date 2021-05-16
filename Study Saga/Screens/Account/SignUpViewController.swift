//
//  SignUpViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/2/21.
//

import Foundation
import UIKit
import Combine


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    
    @IBOutlet weak var isStudentSegmentControl: UISegmentedControl!
    @IBOutlet weak var studentIdTextField: UITextField!
    @IBOutlet weak var schoolNameTextField: UITextField!
    
    @IBOutlet weak var signUpButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpButton: UIButton!
    
    // This constraint ties an element at zero points from the bottom layout guide
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        if self.isStudentSegmentControl.selectedSegmentIndex == 0 {
            self.signUpButtonTopConstraint.constant = 145
            self.schoolNameTextField.show()
            self.studentIdTextField.show()
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            
        } else {
            self.signUpButtonTopConstraint.constant = 30
            self.studentIdTextField.hide()
            self.schoolNameTextField.hide()
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setUpUI() {
        
        self.contentView.backgroundColor = .background
        self.scrollView.backgroundColor = .background
        self.scrollView.delegate = self
        self.scrollView.keyboardDismissMode = .interactive
        
        self.headerView.layer.masksToBounds = false
        self.headerView.layer.shadowColor = UIColor.black.cgColor
        self.headerView.layer.shadowRadius = 5
        self.headerView.layer.shadowOpacity = 0.05
        self.headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        self.emailTextField.backgroundColor = .clear
        
        self.passwordTextField.backgroundColor = .clear
        self.passwordTextField.isSecureTextEntry = true
        
        self.confirmPasswordTextField.backgroundColor = .clear
        self.confirmPasswordTextField.isSecureTextEntry = true
        
        self.nameTextField.backgroundColor = .clear
        
        self.birthTextField.backgroundColor = .clear
        
        self.studentIdTextField.backgroundColor = .clear
        self.schoolNameTextField.backgroundColor = .clear
        
        self.signUpButton.layer.cornerRadius = 15
        self.signUpButton.setTitleColor(.white, for: .normal)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        self.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.keyboardHeightLayoutConstraint?.constant = 0.0
        } else {
            self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            self.scrollView.setContentOffset(CGPoint(x: 0, y: endFrame!.size.height), animated: true)
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
    
    // MARK: - Actions
    
    @objc func signUpButtonTapped() {
        
    }
    
    @objc func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
