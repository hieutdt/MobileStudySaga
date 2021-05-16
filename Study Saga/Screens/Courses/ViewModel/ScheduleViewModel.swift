//
//  ScheduleViewModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/3/21.
//

import Foundation
import Combine


class ScheduleViewModel: NSObject, ObservableObject {
    
    @Published var schedules: [Lesson] = []
    
    override init() {
        super.init()
    }
    
    func fetchLessons(_ completion: @escaping (Bool) -> Void) {
        LessonManager.manager.getNearLessons { lessons, isSuccess in
            self.schedules = lessons
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion(isSuccess)
            }
        }
    }
}
