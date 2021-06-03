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
}
