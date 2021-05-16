//
//  Schedule.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/3/21.
//

import Foundation
import UIKit
import Combine


struct Lesson: Hashable, Identifiable {
    
    var id: String = UUID().uuidString
    var courseId: String = ""
    var courseName: String = ""
    
    var teacherId: String = ""
    var teacherName: String = ""
    
    var date: TimeInterval = 0
    
    var lessonName: String = ""
    var lessonNumber: Int = 0
    var lessonDetail: String = ""
    
    var linkRoom: String = ""
    var password: String = ""
    
    var dateStart: TimeInterval = 0
    var dateEnd: TimeInterval = 0
    
    var avatarUrl: String = ""
    
    var isOnline: Bool = true
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension Lesson {
    
    init(from json: [String: Any]) {
        self.id = json.stringValueForKey("_id")
        self.lessonName = json.stringValueForKey("name")
        self.lessonNumber = json.intValueForKey("index")
        self.teacherId = json.stringValueForKey("lecturer")
        self.teacherName = json.stringValueForKey("lecturerName")
        self.courseId = json.stringValueForKey("courseID")
        self.courseName = json.stringValueForKey("courseName")
        self.dateStart = TimeInterval(json.stringValueForKey("dateStart")) ?? 0
        self.dateEnd = TimeInterval(json.stringValueForKey("dateEnd")) ?? 0
        self.linkRoom = json.stringValueForKey("linkRoom")
        self.password = json.stringValueForKey("password")
        self.avatarUrl = json.stringValueForKey("courseAvatar")
    }
}
