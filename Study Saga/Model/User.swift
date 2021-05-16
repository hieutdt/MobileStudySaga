//
//  User.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/2/21.
//

import Foundation

enum Gender {
    case male
    case female
}

struct User: Hashable, Identifiable {

    var id: String = UUID().uuidString
    
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var avatarUrl: String = ""
    
    var departmentId: String = ""
    var departmentName: String = ""
    var isEnable: Bool = true
    var gender: Gender = .male
}

extension User {
    
    init(from json: [String: Any]) {
        self.name = json.stringValueForKey("fullName")
        self.email = json.stringValueForKey("email")
        self.departmentId = json.stringValueForKey("departmentID")
        self.departmentName = json.stringValueForKey("departmentName")
        self.avatarUrl = json.stringValueForKey("avatar")
        self.gender = json.stringValueForKey("sex") == "Male" ? .male : .female
        self.isEnable = json.boolValueForKey("isEnabled")
    }
}
