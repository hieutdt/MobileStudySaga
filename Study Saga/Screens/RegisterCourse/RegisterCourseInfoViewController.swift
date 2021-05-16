//
//  RegisterCourseInfoViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 12/04/2021.
//

import Foundation
import UIKit
import Masonry
import Combine
import AlamofireImage


protocol RegisterCourseInfoVCDelegate: NSObject {
    
    func didSelectedCourse(_ course: Course)
    
    func didDeselectCourse(_ course: Course)
}

class RegisterCourseInfoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    
    var course: Course!
    
    var isSelected: Bool = false
    
    weak var delegate: RegisterCourseInfoVCDelegate? =  nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    func setUpUI() {
        self.scrollView.backgroundColor = .white
        self.contentView.backgroundColor = .white
        
        self.imageView.layer.cornerRadius = 10
        self.imageView.contentMode = .scaleAspectFill
        if let url = URL(string: self.course.courseImageUrl) {
            self.imageView.af.setImage(withURL: url)
        } else {
            self.imageView.image = UIImage(named: "")
        }
        
        self.titleLabel.text = self.course.subjectName
        self.teacherNameLabel.text = self.course.teacherName
        self.creditLabel.text = "5 tín chỉ"
        self.descriptionLabel.text = self.course.detail
        
        self.view.bringSubviewToFront(bottomView)
        self.bottomView.layer.shadowColor = UIColor.black.cgColor
        self.bottomView.layer.shadowRadius = 1
        self.bottomView.layer.shadowOpacity = 0.15
        
        self.registerButton.layer.cornerRadius = 5
        self.registerButton.addTarget(self,
                                      action: #selector(registerButtonTapped),
                                      for: .touchUpInside)
        
        switch self.course.state {
        case .assigning:
            if !self.isSelected {
                self.registerButton.setTitle("Thêm vào danh sách đăng ký", for: .normal)
                self.registerButton.backgroundColor = .white
                self.registerButton.setBackgroundColor(color: .systemGreen, forState: .normal)
                self.registerButton.setBackgroundColor(color: .green, forState: .highlighted)
            } else {
                self.registerButton.setTitle("Huỷ đăng ký", for: .normal)
                self.registerButton.backgroundColor = .white
                self.registerButton.setBackgroundColor(color: .systemRed, forState: .normal)
                self.registerButton.setBackgroundColor(color: .red, forState: .highlighted)
            }
            break
            
        case .confirmWaiting:
            self.registerButton.setTitle("Huỷ đăng ký", for: .normal)
            self.registerButton.backgroundColor = .white
            self.registerButton.setBackgroundColor(color: .systemRed, forState: .normal)
            self.registerButton.setBackgroundColor(color: .red, forState: .highlighted)
            break
        
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @objc func registerButtonTapped() {
        if self.isSelected {
            self.delegate?.didDeselectCourse(self.course)
        } else {
            self.delegate?.didSelectedCourse(self.course)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
