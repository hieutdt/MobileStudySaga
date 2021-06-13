//
//  Major.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 12/06/2021.
//

import Foundation
import UIKit


struct Major: Hashable {
    
    var id: String = UUID().uuidString
    var name: String = ""
    var thumbUrl: String = ""
    var processing: Int = 0
    var count: Int = 0
    var subjects: [Subject] = []
}

extension Major {
    
    init(from json: [String: Any]) {
        self.name = json.stringValueForKey("name")
        self.count = json.intValueForKey("count")
        self.processing = json.intValueForKey("processing")
        self.thumbUrl = json.stringValueForKey("avatar")
        let subjects = json.arrayDictForKey("subjects")
        
        for subjectDict in subjects {
            let subject = Subject(from: subjectDict)
            self.subjects.append(subject)
        }
    }
}
