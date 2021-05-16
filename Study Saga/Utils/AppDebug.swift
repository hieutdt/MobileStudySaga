//
//  AppDebug.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/22/21.
//

import Foundation
import UIKit


/// Print the response data of a request with a custom format.
/// - Parameters:
///   - requestName: The name of request.
///   - data: JSON response data.
func responsePrint(_ requestName: String, data: [String: Any]) {
    print("\n")
    print("---------------------------------------------------------------")
    print(" REQUEST: \(requestName)")
    print(" -> Response: ")
    if let theJSONData = try? JSONSerialization.data(
        withJSONObject: data,
        options: .prettyPrinted) {
        let theJSONText = String(data: theJSONData, encoding: .ascii)
        print("\(theJSONText!)")
    }
    print("---------------------------------------------------------------\n")
}
