//
//  DateExtensions.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 22/05/2021.
//

import Foundation
import UIKit


extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    static func getDateDiff(time1: TimeInterval, time2: TimeInterval) -> String {
        let cal = Calendar.current
        let date1 = Date(timeIntervalSince1970: time1)
        let date2 = Date(timeIntervalSince1970: time2)
        let components = cal.dateComponents([.day, .hour, .minute], from: date2, to: date1)
        
        let date = cal.date(from: components)!
        let formatter = DateFormatter()
        formatter.dateFormat = "dd hh:MM"
        let dateString = formatter.string(from: date)
        return dateString
    }
}

