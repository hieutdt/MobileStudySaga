//
//  NotificationModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 03/06/2021.
//

import Foundation
import Combine


struct NotificationModel: Hashable {
    
    var id: String = ""
    var ts: TimeInterval = 0
    var fromTeacherName: String = ""
    var courseName: String = ""
    var content: String = ""
    var thumbImgUrl: String = ""
}
