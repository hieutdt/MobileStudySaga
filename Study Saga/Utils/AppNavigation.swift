//
//  AppNavigation.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 2/27/21.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    static let main: UIStoryboard = {
        let storyboard = UIStoryboard(name: "MainScreens", bundle: nil)
        return storyboard
    }()
    
    static let courses: UIStoryboard = {
        let storyboard = UIStoryboard(name: "CourseScreens", bundle: nil)
        return storyboard
    }()
    
    static let register: UIStoryboard = {
        let storyboard = UIStoryboard(name: "RegisterCourse", bundle: nil)
        return storyboard
    }()
}

extension UIStoryboard {
    
    func viewController<T: UIViewController>(_ classObj: T.Type) -> T {
        let vc = self.instantiateViewController(identifier: String(describing: classObj))
        return vc as! T
    }
}
