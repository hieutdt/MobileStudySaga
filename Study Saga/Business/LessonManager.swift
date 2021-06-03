//
//  LessonManager.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 4/1/21.
//

import Foundation
import UIKit
import Combine
import Alamofire


class LessonManager: NSObject, ObservableObject {
    
    static let manager = LessonManager()
    
    func getNearLessons(_ completion: @escaping ([Lesson], Bool) -> Void) {
        
        guard let token = AccountManager.manager.cachingToken else {
            completion([], false)
            return
        }
        
        let url = "\(kDomain)/api/lesson/"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "*/*"
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: [:],
            encoding: URLEncoding.default,
            headers: headers) { urlRequest in
            urlRequest.timeoutInterval = 5
            urlRequest.allowsConstrainedNetworkAccess = true
        }
        .responseJSON { response in
            if let value = response.value as? [String: Any] {
                responsePrint("api/courses/lesson", data: value)
                
                let status = value.intValueForKey("response_code")
                if status == RESPONSE_STATUS_OK {
                    let data = value.arrayDictForKey("data")
                    var result: [Lesson] = []
                    for dict in data {
                        let lesson = Lesson(from: dict)
                        result.append(lesson)
                    }
                    
                    completion(result, true)
                    return
                }
            } else {
                completion([], false)
                return
            }
        }
    }
}
