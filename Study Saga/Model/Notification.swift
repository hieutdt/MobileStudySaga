//
//  Notification.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/9/21.
//

import Foundation
import Combine


struct Notification: Hashable {
    var id: String = UUID().uuidString
    var fromTeacherId: String = ""
    var fromTeacherName: String = ""
    var content: String = ""
    var time: TimeInterval = 0
    var courseId: String = ""
}
