//
//  Date.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 2/27/21.
//

import Foundation

struct DateEntity {
    var weekDay: Int = 0
    var monthDay: Int = 0
    var month: Int = 0
    
    init(weekDay: Int, monthDay: Int, month: Int) {
        self.weekDay = weekDay
        self.monthDay = monthDay
        self.month = month
    }
    
    init(timestamp: TimeInterval) {
        let date = Date(timeIntervalSince1970: timestamp)
        self.weekDay = Calendar.current.component(.weekday, from: date)
        self.monthDay = Calendar.current.component(.day, from: date)
        self.month = Calendar.current.component(.month, from: date)
    }
}
