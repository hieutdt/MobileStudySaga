//
//  UpdateInfoViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/25/21.
//

import Foundation
import UIKit
import Combine
import Masonry
import AlamofireImage


class UpdateInfoViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var editAvatarBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    var currentUser = AccountManager.manager.loggedInUser!
    
    var imagePicker = UIImagePickerController()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hide()
    }
    
    // MARK: - UI Configure
    
    private func setUpUI() {
        
        self.title = "Cập nhật thông tin cá nhân"
        
        self.contentView.backgroundColor = .background
        self.scrollView.backgroundColor = .background
        
        avatarImgView.layer.cornerRadius = 20
        
        DispatchQueue.global(qos: .background).async { [self] in
            if let url = URL(string: currentUser.avatarUrl) {
                DispatchQueue.main.async {
                    avatarImgView.af.setImage(withURL: url)
                }
                
            } else {
                DispatchQueue.main.async {
                    avatarImgView.image = UIImage(named: "avatar")
                }
            }
        }
        
        self.nameTextField.text = currentUser.name
        self.nameTextField.font = .systemFont(ofSize: 12)
        self.nameTextField.isEnabled = false
        self.nameTextField.backgroundColor = .background
        
        self.emailTextField.text = currentUser.email
        self.emailTextField.font = .systemFont(ofSize: 12)
        self.emailTextField.isEnabled = false
        self.emailTextField.backgroundColor = .background
        
        self.departmentTextField.text = currentUser.departmentName
        self.departmentTextField.font = .systemFont(ofSize: 12)
        self.departmentTextField.isEnabled = false
        self.departmentTextField.backgroundColor = .background
        
        self.genderSegmentedControl.setTitle("Nam", forSegmentAt: 0)
        self.genderSegmentedControl.setTitle("Nữ", forSegmentAt: 1)
        self.genderSegmentedControl.setEnabled(
            true,
            forSegmentAt: currentUser.gender == .male ? 0 : 1
        )
        self.genderSegmentedControl.isEnabled = false
        
        self.saveButton.applyGradient(colors: [UIColor.gradientFirst.cgColor,
                                               UIColor.gradientLast.cgColor])
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.layer.cornerRadius = 20
        self.saveButton.layer.masksToBounds = true
        self.saveButton.addTarget(self,
                                  action: #selector(saveButtonTapped),
                                  for: .touchUpInside)
        self.saveButton.setTitle("Lưu cập nhật", for: .normal)
        
        self.editAvatarBtn.addTarget(self,
                                     action: #selector(updateAvatarImgTapped),
                                     for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func saveButtonTapped() {
        self.uploadUserInfo(self.avatarImgView.image!)
    }
    
    @objc func updateAvatarImgTapped() {
        let actionSheet = UIAlertController(title: "Cập nhật ảnh đại diện",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel)
        let updateAction = UIAlertAction(title: "Chọn từ Thư viện",
                                         style: .default) { action in
            self.getImageFromGallery()
        }
        
        actionSheet.addAction(updateAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker
    
    func getImageFromGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(
                title: "Không có quyền truy cập",
                message: "Bạn cần cho phép ứng dụng truy cập vào album ảnh trước",
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: "Đóng", style: .cancel)
            let settingAction = UIAlertAction(title: "Đến Cài đặt",
                                              style: .default) { action in
                // Go to settings.
                
            }
            
            alert.addAction(cancelAction)
            alert.addAction(settingAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Networking
    
    func uploadUserInfo(_ image: UIImage) {
        
        AppLoading.showLoading(with: "Cập nhật thông tin", viewController: self)
        
        AccountManager.manager.updateAvatar(image) { isSuccess in
            
            AppLoading.hideLoading()
            
            let state = isSuccess ? "Cập nhật thành công" : "Cập nhật thất bại"
            if isSuccess {
                AppLoading.showSuccess(with: state, viewController: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                AppLoading.showFailed(with: state, viewController: self)
            }
        }
    }
}

extension UpdateInfoViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.avatarImgView.image = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
