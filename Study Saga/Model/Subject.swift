//
//  Subject.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 11/04/2021.
//

import Foundation
import UIKit
import Combine


class Subject: NSObject {
    
    var id: String = UUID().uuidString
    
    var sesmester: Int = 0
    var dateCreated: TimeInterval = 0
    var name: String = ""
    var detail: String = ""
    var isLearned: Bool = false
    
    var courses: [Course] = []
}

extension Subject {
    
    convenience init(from json: [String: Any]) {
        self.init()
        self.id = json.stringValueForKey("_id")
        self.sesmester = json.intValueForKey("sesmester")
        self.name = json.stringValueForKey("name")
        self.detail = json.stringValueForKey("detail")
        self.isLearned = json.boolValueForKey("isLearned")
        let courses = json.arrayDictForKey("courses")
        for courseDict in courses {
            var course = Course(from: courseDict)
            course.subjectName = self.name
            self.courses.append(course)
        }
    }
}
