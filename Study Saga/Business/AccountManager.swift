//
//  AccountManager.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/1/21.
//

import Foundation
import Combine
import Alamofire

let kUserTokenKey = "study_saga_user_token"

class AccountManager: NSObject, ObservableObject {
    
    /// Singleton
    static var manager = AccountManager()
    
    @Published var loggedInUser: User?
    
    override init() {
        super.init()
    }
    
    // MARK: - APIs
    
    /// Log Out handle. Clear user model of this manager
    /// and clear user token in device.
    func logOut() {
        
        // Clear current user object.
        self.loggedInUser = nil
        
        // Remove caching in local storage.
        UserDefaults.standard.removeObject(forKey: kUserTokenKey)
    }
    
    /// Log In from Email & Password.
    /// This method will caching the user TOKEN to device by UserDefaults.
    /// - Parameters:
    ///   - email: Email address by string for log in.
    ///   - pwd: Password by string for log in.
    ///   - completion: Callback with a bool value: `isSuccess`.
    func logIn(email: String,
               pwd: String,
               completion: @escaping (Bool) -> Void) {
        
        let logInUrl = "http://\(kServerUrl):\(kPortNumber)/api/oauth/login"
        
        let params = [
            "email": email,
            "password": pwd
        ]
        
        AF.request(
            logInUrl,
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default,
            headers: nil,
            requestModifier: { urlRequest in
                urlRequest.timeoutInterval = 5
                urlRequest.allowsConstrainedNetworkAccess = true
            }
        )
        .responseJSON { response in
            if let value = response.value as? [String: Any] {
                responsePrint("api/oauth/login", data: value)
                
                let status = value.intValueForKey("response_code")
                let data = value.dictionaryForKey("data")
                let token = data.stringValueForKey("token")
                if status == RESPONSE_STATUS_OK {
                    UserDefaults.standard.setValue(token, forKey: kUserTokenKey)
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    /// Send a GET request for check if the current token is validate for handle init app flow.
    /// - Parameter completion: callback block with a bool value: `isValidate`
    func checkTokenValidate(completion: @escaping (Bool) -> Void) {
        
        if let cachingToken = self.cachingToken, cachingToken.count > 0 {
            
            // Send check validate get request
            let url = "http://\(kServerUrl):\(kPortNumber)/api/account/validationToken"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(cachingToken)",
                "Accept": "*/*"
            ]
            
            AF.request(
                url,
                method: .get,
                parameters: [:],
                encoding: URLEncoding.default,
                headers: headers,
                requestModifier: { urlRequest in
                    urlRequest.timeoutInterval = 5
                    urlRequest.allowsConstrainedNetworkAccess = true
                }
            )
            .responseJSON { response in
                if let value = response.value as? [String: Any] {
                    responsePrint("api/account/validationToken", data: value)
                    
                    let status = value.intValueForKey("response_code")
                    if status == RESPONSE_STATUS_OK {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
            
        } else {
            completion(false)
        }
    }
    
    /// Get current caching token from Disk.
    var cachingToken: String? {
        return UserDefaults.standard.string(forKey: kUserTokenKey)
    }
    
    /// Send a GET request to server for receive the data of current user.
    /// Use current token for authorization.
    /// - Parameter completion: callback block with User model.
    func getUserInfo(_ completion: @escaping (User?) -> Void) {
        
        guard let cachingToken = self.cachingToken, cachingToken.lenght > 0 else {
            completion(nil)
            return
        }
        
        // Send GET user info request
        let url = "http://\(kServerUrl):\(kPortNumber)/api/account/"
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
                responsePrint("api/account", data: value)
                
                // Create user model from json data.
                let data = value.dictionaryForKey("data")
                let user = User(from: data)
                
                // Caching this user info.
                self.loggedInUser = user

                // Callback.
                completion(user)
                
            } else {
                completion(nil)
            }
        }
    }
    
    func updateAvatar(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        
        guard let cachingToken = self.cachingToken, cachingToken.lenght > 0 else {
            completion(false)
            return
        }
        
        // Resize this image to 300x300.
        let resizedImage = UIImage.resizeImage(
            image: image,
            targetSize: CGSize(width: 300, height: 300)
        )
        
        // Send POST request to update user's avatar.
        let url = "http://\(kServerUrl):\(kPortNumber)/api/account/"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(cachingToken)",
            "Accept": "*/*"
        ]
        
        // Convert uiimage -> base64 string.
        let base64ImgString = resizedImage.jpegToBase64()!
        let fullBase64String = "data:image/jpeg;base64,\(base64ImgString)"
        let params = [
            "avatar": fullBase64String
        ]
        
        // Send request.
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default,
            headers: headers) { urlRequest in
            urlRequest.timeoutInterval = 5
            urlRequest.allowsConstrainedNetworkAccess = true
        }
        .responseJSON { response in
            if let value = response.value as? [String: Any] {
                responsePrint("api/account", data: value)
                
                let data = value.dictionaryForKey("data")
                let isSuccess = data.boolValueForKey("isSuccessful")
                if isSuccess {
                    AccountManager.manager.loggedInUser = User(from: value.dictionaryForKey("data"))
                }
                
                completion(isSuccess)
                
            } else {
                completion(false)
            }
        }
    }
}
