//
//  Document.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/12/21.
//

import Foundation
import Combine
import UIKit

enum DocumentType: Int {
    case unknown = 0
    case docx
    case pdf
    case url
}

struct DocumentModel: Hashable {
    
    var id: String = UUID().uuidString
    var type: DocumentType = .unknown
    var name: String = ""
    var downloaded: Bool = false
    var path: String = ""
    
    static func == (lhs: DocumentModel, rhs: DocumentModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension DocumentModel {
    init(from dict: [String: Any]) {
        self.id = dict.stringValueForKey("_id")
        self.name = dict.stringValueForKey("name")
        self.path = dict.stringValueForKey("url")
        self.type = .pdf
    }
}
