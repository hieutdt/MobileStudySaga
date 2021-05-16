//
//  CourseViewModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/4/21.
//

import Foundation
import UIKit
import Combine


class CourseViewModel: NSObject, ObservableObject {
    
    @Published var courses: [Course] = []
    var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        CoursesManager.manager.didUpdateCoursesPublisher
            .receive(on: DispatchQueue.main)
            .sink { courses in
                self.courses = courses
            }
            .store(in: &self.cancellables)
    }
    
    func getCourses(_ completion: @escaping (Bool) -> Void) {
        CoursesManager.manager.getAllCourses { courses, isSuccess in
            
            self.courses = courses
            
            // Delay 1s to callback.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(isSuccess)
            }
        }
    }
}
