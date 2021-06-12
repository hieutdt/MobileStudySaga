//
//  NotificationViewModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 03/06/2021.
//

import Foundation
import Combine
import UIKit


class NotificationViewModel: ObservableObject {
    
    @Published var notifications: [NotificationModel] = []
    
    init() {
        for _ in 0...100 {
            var noti = NotificationModel()
            noti.id = UUID().uuidString
            noti.courseName = "Nhập môn Công nghệ phần mềm"
            noti.fromTeacherName = "Trần Minh Triết"
            noti.content = "Nay cho mấy em nghỉ nha. Thứ 6 tuần sau học theo lịch học như bình thường."
            noti.thumbImgUrl = "https://locobee.com/mag/wp-content/uploads/2018/06/Locobee_Naruto_1.jpg"
            
            self.notifications.append(noti)
        }
    }
}
