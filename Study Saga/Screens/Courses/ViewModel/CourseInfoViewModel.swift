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
        
        for _ in 0...2 {
            var noti = Notification()
            noti.courseId = self.course.courseId
            noti.fromTeacherId = self.course.teacherId
            noti.fromTeacherName = self.course.teacherName
            noti.content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur non nisi aliquam, malesuada nisi eget, laoreet arcu."
            
            self.course.notifications.append(noti)
        }
        
        for _ in 0...5 {
            var document = Document()
            document.type = .pdf
            document.name = "Nhật ký lịch sử Đảng"
            document.downloaded = false
            
            self.course.documents.append(document)
        }
    }
}
