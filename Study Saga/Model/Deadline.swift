//
//  Deadline.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 2/27/21.
//

import Foundation
import UIKit
import Combine

struct Deadline: Hashable {
    
    var id: String = UUID().uuidString
    var courseId: String = ""
    var courseName: String = ""
    var teacherName: String = ""
    
    var deadlineName: String = ""
    var detail: String = ""
    var isSubmitted: Bool = false
    
    var timeStart: TimeInterval = 0
    var timeEnd: TimeInterval = 0
    
    var deadlineDocuments: [DocumentModel] = []
    var submitDocuments: [DocumentModel] = []
}

extension Deadline {
    
    /// Example:
    /**
     {
         "_id": "605b9bd0f2c4dc31c0db0418",
         "lessonID": "605b9a8af2c4dc31c0db0216",
         "courseID": "604993b4756a9cf5c4354f96",
         "timeStart": "1616227782",
         "timeEnd": "1623474000",
         "createdBy": "6049d12219f7047c5853da35",
         "name": "Deadline bai tap 2 ",
         "detail": "Deadline bai tap 2 ",
         "isSubmit": false
     }
     */
    
    init(from json: [String: Any]) {
        self.id = json.stringValueForKey("_id")
        self.deadlineName = json.stringValueForKey("name")
        self.detail = json.stringValueForKey("deatil")
        self.isSubmitted = json.boolValueForKey("isSubmit")
        self.timeStart = TimeInterval(json.stringValueForKey("timeStart")) ?? 0
        self.timeEnd = TimeInterval(json.stringValueForKey("timeEnd")) ?? 0
        self.courseId = json.stringValueForKey("courseID")
        self.courseName = json.stringValueForKey("courseName")
    }
}
    
