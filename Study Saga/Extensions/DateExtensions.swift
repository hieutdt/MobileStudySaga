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
    
    func distanceTo(_ date2: Date) -> String {
        let distance = abs(self.distance(to: date2))
        let dayDistance = ceil(distance / (3600*24));
        let minDistance = (distance - (dayDistance * 3600*24)) / 60
        
        if dayDistance > 0 {
            return "\(Int(dayDistance)) ngày"
        } else {
            return "\(Int(minDistance)) phút"
        }
    }
}

