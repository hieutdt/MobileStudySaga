//
//  Course.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/4/21.
//

import Foundation
import UIKit
import Combine

enum CourseState: Int {
    case unknown = 0
    case assigning
    case confirmWaiting
    case learning
}

struct Course: Hashable {
    
    var courseId: String = UUID().uuidString
    var courseImageUrl: String = ""
    
    var detail: String = ""
    var subjectId: String = ""
    var subjectName: String = ""
    var teacherId: String = ""
    var teacherName: String = ""
    
    var dateStart: TimeInterval = 0
    var dateEnd: TimeInterval = 0
    
    var className: String = ""
    var lessonCount: Int = 0
    
    var lessons: [Lesson] = []
    var deadlines: [Deadline] = []
    var notifications: [Notification] = []
    var documents: [Document] = []
    
    var score: CGFloat = 0
    var sesmester: Int = 0
    
    var state: CourseState = .unknown
    
    var hasFullInfo: Bool = false
    
    func nextLesson() -> Lesson? {
        if self.lessons.count > 0 {
            var result = self.lessons[0]
            let now = Date().timeIntervalSince1970
            for lesson in self.lessons {
                if lesson.dateStart >= now
                    && abs(lesson.dateStart - now) < abs(result.dateStart - now) {
                    result = lesson
                }
            }
            
            return result
        }
        
        return nil
    }
}

extension Course {
    
    init(from json: [String: Any]) {
        self.courseId = json.stringValueForKey("_id")
        self.className = json.stringValueForKey("name")
        self.courseImageUrl = json.stringValueForKey("avatar")
        self.detail = json.stringValueForKey("detail")
        
        self.dateStart = TimeInterval(json.stringValueForKey("dateStart")) ?? 0
        self.dateEnd = TimeInterval(json.stringValueForKey("dateEnd")) ?? 0
        
        self.teacherId = json.stringValueForKey("lecturer")
        self.teacherName = json.stringValueForKey("lecturerName")
        
        self.subjectName = json.stringValueForKey("subjectName")
        if self.subjectName.isEmpty {
            self.subjectName = json.stringValueForKey("nameSubject")
        }
        self.subjectId = json.stringValueForKey("subjectID")
        
        self.score = CGFloat(json.numberForKey("score").floatValue)
        
        self.lessons = []
        let lessonDicts = json.arrayDictForKey("lessons")
        for dict in lessonDicts {
            var lesson = Lesson(from: dict)
            lesson.courseName = self.className
            self.lessons.append(lesson)
        }
        
        self.deadlines = []
        let deadlineDicts = json.arrayDictForKey("deadlines")
        for dict in deadlineDicts {
            let deadline = Deadline(from: dict)
            self.deadlines.append(deadline)
        }
        
        self.documents = []
        let documentDicts = json.arrayDictForKey("documents")
        for dict in documentDicts {
            let doc = Document(from: dict)
            self.documents.append(doc)
        }
    }
}
