//
//  CourseInfoViewModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/9/21.
//

import Foundation
import Combine

class CourseInfoViewModel: ObservableObject {
    
    @Published var course: Course!
    
    init(course: Course!) {
        
        self.course = course
    }
}
