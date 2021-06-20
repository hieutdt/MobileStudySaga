//
//  CoursesManager.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/26/21.
//

import Foundation
import UIKit
import Combine
import Alamofire


class CoursesManager: NSObject, ObservableObject {
    
    // Singleton
    static let manager = CoursesManager()
    
    @Published private var courses: [Course] = []
    
    var didUpdateCoursesPublisher = PassthroughSubject<[Course], Never>()
    
    /// Get an in coming lesson from all courses of user.
    /// - Parameter completion: Callback with a Lesson model if we have the in coming lesson.
    func getComingLesson(completion: @escaping (Lesson?) -> Void) {
        
        guard let token = AccountManager.manager.cachingToken else {
            return
        }
        
        let url = "\(kDomain)/api/courses/latest"
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
                responsePrint("api/courses/latest", data: value)
                
                let status = value.intValueForKey("response_code")
                if status == RESPONSE_STATUS_OK {
                    let data = value.dictionaryForKey("data")
                    let courseId = data.stringValueForKey("courseID")
                    let courseName = data.stringValueForKey("name")
                    let lessonsDict = data.dictionaryForKey("lessons")
                    
                    var lesson = Lesson(from: lessonsDict)
                    lesson.courseId = courseId
                    lesson.courseName = courseName
                    
                    completion(lesson)
                    
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    /// Get all courses of current user.
    /// - Parameter completion: Completion handler block.
    func getAllCourses(_ completion: @escaping ([Course], Bool) -> Void) {
        
        guard let token = AccountManager.manager.cachingToken else {
            completion([], false)
            return
        }
        
        let url = "\(kDomain)/api/courses/all"
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
                responsePrint("api/courses/all", data: value)
                
                let status = value.intValueForKey("response_code")
                if status == RESPONSE_STATUS_OK {
                    
                    self.courses.removeAll()
                    
                    let array = value.arrayDictForKey("data")
                    for dict in array {
                        let course = Course(from: dict)
                        self.courses.append(course)
                    }
                    
                    self.didUpdateCoursesPublisher.send(self.courses)
                }
                
                completion(self.courses, true)
                
            } else {
                completion([], false)
            }
        }
    }
    
    func getNearDeadlines(_ completion: @escaping ([Deadline], Bool) -> Void) {
        
        guard let cachingToken = AccountManager.manager.cachingToken,
              cachingToken.lenght > 0 else {
            completion([], false)
            return
        }
        
        let url = "\(kDomain)/api/deadline/"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(cachingToken)",
            "Accept": "*/*"
        ]
        
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
                responsePrint("api/deadline/", data: value)
                
                let data = value.arrayDictForKey("data")
                var result: [Deadline] = []
                for dict in data {
                    let deadline = Deadline(from: dict)
                    result.append(deadline)
                }
                
                completion(result, true)
                
            } else {
                completion([], false)
            }
        }
    }
    
    func getCourseInfo(id: String, completion: @escaping (Course?) -> Void) {
        
        let cachingCourse = self.courses.first(where: { $0.courseId == id })
        if cachingCourse?.hasFullInfo == true {
            completion(cachingCourse!)
            return
        }
        
        guard let cachingToken = AccountManager.manager.cachingToken,
              cachingToken.lenght > 0 else {
            completion(nil)
            return
        }
        
        let url = "\(kDomain)/api/courses/\(id)"
        
        NetworkManager.GET(
            url: url,
            params: [:]
        ) { value, error in
            responsePrint("api/courses/\(id)", data: value)
            
            let data = value.dictionaryForKey("data")
            let course = Course(from: data)
            if let index = self.courses.firstIndex(where: { $0.courseId == id }) {
                self.courses[index] = course
                self.courses[index].hasFullInfo = true
            }
            
            completion(course)
        }
    }
    
    func getRecommendMajors(_ completion: @escaping ([Major]) -> Void) {
        guard let token = AccountManager.manager.cachingToken else {
            completion([])
            return
        }
        
        let url = "\(kDomain)/api/rasa/recommend"
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
                let status = value.intValueForKey("response_code")
                if status == RESPONSE_STATUS_OK {
                    let data = value.dictionaryForKey("data")
                    let listMajor = data.arrayDictForKey("listMajor")
                    
                    var result: [Major] = []
                    
                    for majorDict in listMajor {
                        let major = Major(from: majorDict)
                        result.append(major)
                    }
                    
                    completion(result)
                    
                } else {
                    completion([])
                }
            } else {
                completion([])
            }
        }
    }
    
    func getNewFeeds(_ completion: @escaping ([FeedModel]) -> Void) {
        guard let token = AccountManager.manager.cachingToken else {
            completion([])
            return
        }
        
        let url = "\(kDomain)/api/feednew"
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
            urlRequest.timeoutInterval = 30
            urlRequest.allowsConstrainedNetworkAccess = true
        }
        .responseJSON { response in
            if let value = response.value as? [String: Any] {
                let status = value.intValueForKey("response_code")
                if status == RESPONSE_STATUS_OK {
                    let data = value.arrayDictForKey("data")
                    var results: [FeedModel] = []
                    for dict in data {
                        let feedModel = FeedModel(json: dict)
                        results.append(feedModel)
                    }
                    
                    completion(results)
                    
                } else {
                    completion([])
                }
            } else {
                completion([])
            }
        }
    }
}
