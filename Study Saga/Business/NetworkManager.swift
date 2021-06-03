//
//  NetworkManager.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/20/21.
//

import Foundation
import UIKit
import Combine
import Alamofire

enum NetworkRequestType {
    case get
    case post
}

let kDomain = "https://studysaga.online"

let RESPONSE_STATUS_OK: Int = 200

class NetworkManager: NSObject, ObservableObject {
    
    /// Singleton
    static let manager = NetworkManager()
    
    static func GET(url: String,
                    params: [String: Any],
                    completion: @escaping ([String: Any], Error?) -> Void) {
        guard let cachingToken = AccountManager.manager.cachingToken,
              cachingToken.lenght > 0 else {
            let error = NSError(
                domain: "stutysaga.api",
                code: 199,
                userInfo: [
                    "reason" : "Phiên đã hết hạn. Vui lòng đăng nhập lại"
                ])
            completion([:], error)
            return
        }
        
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
                completion(value, nil)
                
            } else {
                let error = NSError(
                    domain: "stutysaga.api",
                    code: 198,
                    userInfo: [
                        "reason" : "Có lỗi xảy ra. Vui lòng thử lại."
                    ])
                completion([:], error)
            }
        }
    }
}
