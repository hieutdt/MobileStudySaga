//
//  FileDownloadManager.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 05/06/2021.
//

import Foundation
import UIKit
import Combine
import FileKit
import Alamofire


enum FileDownloadError: Error {
    case none
    case unknown
    case downloadError
    case urlError
}

final class FileDownloadManager: NSObject {
    
    static let manager = FileDownloadManager()
    
    func startDownloadFileWith(url: String,
                               fileName: String,
                               progressBlock: @escaping (Double) -> Void,
                               completionBlock: @escaping (String, FileDownloadError) -> Void) {
        UIApplication.shared.isIdleTimerDisabled = true
        
        let destination: DownloadRequest.Destination = { tempUrl, response in
            var documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsUrl.appendPathComponent(fileName)
            print(documentsUrl)
            return (documentsUrl, [.createIntermediateDirectories])
        }
        
        if let url = URL(string: url) {
            Alamofire.Session.default.download(url, to: destination)
                .downloadProgress { progress in
                    progressBlock(progress.fractionCompleted)
                }
                .responseData { response in
                    
                    if let destinationUrl = response.fileURL {
                        print(destinationUrl)
                        
                        if let statusCode = response.response?.statusCode {
                            print(statusCode)
                            completionBlock(destinationUrl.absoluteString, .none)
                        } else {
                            completionBlock("", .urlError)
                        }
                    } else {
                        completionBlock("", .downloadError)
                    }
                }
        } else {
            completionBlock("", .urlError)
        }
    }
}

class Utils {
  internal static func tempDirectory() throws -> Path {
    return try self.directoryInsideDocumentsWithName(name: "temp")
  }

  internal static func directoryInsideDocumentsWithName(name: String, create: Bool = true) throws -> Path {
   let directory = Path(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]) + name
   if create && !directory.exists {
     try directory.createDirectory()
   }
   return directory
  }
}
