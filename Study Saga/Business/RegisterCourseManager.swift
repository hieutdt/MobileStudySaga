//
//  RegisterCourseManager.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 12/04/2021.
//

import Foundation
import UIKit
import Combine
import Alamofire


class RegisterCourse: NSObject {
    
    var course: Course!
    var isSelected: Bool = false
    
    init(course: Course) {
        super.init()
        self.course = course
    }
}


class RegisterCourseManager: NSObject {
    
    static let manager = RegisterCourseManager()
    
    // Caching
    var courses: [Course] = []
    var registedCourses: [Course] = []
    var coursesDidChanged: Bool = true
    
    /// Get courses that user can registed.
    func fetchRegisterCourses(_ completion: @escaping ([Course], Bool) -> Void) {
        
        guard let cachingToken = AccountManager.manager.cachingToken,
              cachingToken.lenght > 0 else {
            completion([], false)
            return
        }
        
        let url = "\(kDomain)/api/subject/"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(cachingToken)",
            "Accept": "*/*"
        ]
        
        var result: [Course] = []
        
        AF.request(url,
                   method: .get,
                   parameters: [:],
                   encoding: URLEncoding.default,
                   headers: headers) { urlRequest in
            urlRequest.timeoutInterval = 5
            urlRequest.allowsConstrainedNetworkAccess = true
        }
        .responseJSON { response in
            if let value = response.value as? [String: Any] {
                responsePrint("api/subject/", data: value)
                
                self.courses.removeAll()
                let data = value.arrayDictForKey("data")
                for subjectDict in data {
                    let subject = Subject(from: subjectDict)
                    for course in subject.courses {
                        result.append(course)
                    }
                }
                
                self.courses = result
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion(result, true)
                }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion([], false)
                }
            }
        }
    }
    
    func registerCourses(_ courses: [Course],
                         completion: @escaping (Error?) -> Void) {
        
        guard let cachingToken = AccountManager.manager.cachingToken,
              cachingToken.lenght > 0 else {
            let error = NSError(domain: "stutysaga.api",
                                code: 199,
                                userInfo: [
                                    "reason" : "Phiên đã hết hạn. Vui lòng đăng nhập lại"
                                ])
            completion(error)
            return
        }
        
        let url = "\(kDomain)/api/register/"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(cachingToken)",
            "Accept": "*/*"
        ]
        
        let courseIds = courses.map { $0.courseId }
        let params = [
            "data": courseIds
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default,
            headers: headers,
            requestModifier: { urlRequest in
                urlRequest.timeoutInterval = 5
                urlRequest.allowsConstrainedNetworkAccess = true
            }
        )
        .responseJSON { response in
            if let value = response.value as? [String: Any] {
                responsePrint("api/register", data: value)
                
                let status = value.intValueForKey("response_code")
                if status == RESPONSE_STATUS_OK {
                    self.coursesDidChanged = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        completion(nil)
                    }
                    
                } else {
                    let error = NSError(
                        domain: "studysage.api",
                        code: 198,
                        userInfo: [
                            "reason" : "Có lỗi xảy ra"
                        ])
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        completion(error)
                    }
                }
                
            } else {
                let error = NSError(
                    domain: "studysage.api",
                    code: 198,
                    userInfo: [
                        "reason" : "Có lỗi xảy ra"
                    ])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    completion(error)
                }
            }
        }
    }
    
    func getRegistedCourses(_ completion: @escaping ([Course], Error?) -> Void) {
        
        let url = "\(kDomain)/api/register/"
        
        var result: [Course] = []
        NetworkManager.GET(
            url: url,
            params: [:]) { value, error in
            
            if let error = error {
                completion([], error)
                
            } else {
                let data = value.arrayDictForKey("data")
                for dict in data {
                    var course = Course(from: dict)
                    course.state = .confirmWaiting
                    result.append(course)
                }
                
                // Caching result.
                self.registedCourses = result
                
                completion(result, nil)
            }
        }
    }
}
