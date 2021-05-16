//
//  SSFileManager.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 09/05/2021.
//

import Foundation
import UIKit

final class SSFileManager: NSObject {
    
    static let manager = SSFileManager()
    
    private let fileManager = FileManager.default
    
    override init() {
        super.init()
    }
    
    var documentDirectoryURL: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    
}

