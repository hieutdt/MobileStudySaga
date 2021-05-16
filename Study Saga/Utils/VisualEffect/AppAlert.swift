//
//  AppAlert.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/22/21.
//

import Foundation
import UIKit


class AppAlert: NSObject {
    
    public static func showAlert(_ title: String,
                                 message: String? = nil,
                                 on viewController: UIViewController,
                                 completion: @escaping () -> Void = {}) {
        
        let actionSheet = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Đóng", style: .cancel) { action in
            completion()
        }
        
        actionSheet.addAction(cancelAction)
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
