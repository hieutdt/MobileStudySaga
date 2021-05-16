//
//  AccountViewModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/1/21.
//

import Foundation
import Combine

class AccountViewModel: ObservableObject {
    
    @Published var user: User?
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.user = AccountManager.manager.loggedInUser
        
        AccountManager.manager.$loggedInUser
            .sink { [weak self] user in
                guard let self = self else {
                    return
                }
                
                self.user = user
            }
            .store(in: &self.cancellables)
    }
}
