//
//  HomeViewModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 2/23/21.
//

import UIKit
import Combine

class HomeViewModel: NSObject, ObservableObject {

    @Published var userName: String = ""
    @Published var avatarUrl: String = ""
    @Published var deadlines: [Deadline] = []
    @Published var comingLesson: Lesson?
    @Published var majors: [Major] = []
    
    var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        AccountManager.manager.$loggedInUser
            .receive(on: DispatchQueue.main)
            .sink { user in
                if let user = user {
                    self.userName = user.name
                    self.avatarUrl = user.avatarUrl
                }
            }
            .store(in: &self.cancellables)
    }
    
    func fetchUserInfo(_ completion: @escaping () -> Void) {
        
        AccountManager.manager.getUserInfo { [weak self] user in
            guard let self = self else {
                return
            }
            
            if let user = user {
                self.userName = user.name
                self.avatarUrl = user.avatarUrl
            }
            
            // Call back after 1s.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion()
            }
        }
    }
    
    func fetchComingLesson(_ completion: @escaping (Lesson?) -> Void) {
        
        CoursesManager.manager.getComingLesson { lesson in
            if let lesson = lesson {
                self.comingLesson = lesson
            }
            
            // Call back after 1s.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(lesson)
            }
        }
    }
    
    func fetchNearDeadlines(_ completion: @escaping (Bool) -> Void) {
        CoursesManager.manager.getNearDeadlines { deadlines, isSuccess in
            self.deadlines = deadlines
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(isSuccess)
            }
        }
    }
    
    func fetchRecommendMajors(_ completion: @escaping () -> Void) {
        CoursesManager.manager.getRecommendMajors { majors in
            self.majors = majors
            completion()
        }
    }
}
