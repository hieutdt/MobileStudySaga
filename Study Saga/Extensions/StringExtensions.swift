//
//  StringExtensions.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 2/27/21.
//

import Foundation
import UIKit
import CommonCrypto

extension String {
    
    var isEmpty: Bool {
        return self.count == 0
    }
    
    var lenght: Int {
        return self.count
    }
    
    func JSONDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(
                    with: data, options: []
                ) as? [String: Any]
                
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    var json: [String: Any]? {
        guard !self.isEmpty else {
            return nil
        }
        
        guard let correctedData = self.data(using: .utf8) else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(
            with: correctedData, options: [.allowFragments]
        ) as? [String: Any]
    }
    
    init<T: LosslessStringConvertible>(_ value: Any?, expected: T.Type) {
        if let value = value as? T {
            self = String(value)
        } else {
            self = ""
        }
    }
}

extension String {
    
    static func fullDateFormat(timeInterval: TimeInterval?) -> String {
        guard let ts = timeInterval else {
            return ""
        }
        
        let date = Date(timeIntervalSince1970: ts)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm - dd/MM/yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    static func nearDateFormat(timeInterval: TimeInterval?) -> String {
        guard let ts = timeInterval else {
            return ""
        }
        
        let date = Date(timeIntervalSince1970: ts)
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "hh:mm"
        } else if calendar.isDateInTomorrow(date) {
            dateFormatter.dateFormat = "hh:mm ngày mai"
        } else {
            dateFormatter.dateFormat = "hh:mm - dd/MM/yyyy"
        }
        
        return dateFormatter.string(from: date)
    }
}

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        let cKey = key.cString(using: .utf8)
        let cData = self.cString(using: .utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
        let hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        let hmacBase64 = hmacData.base64EncodedString(options: .lineLength76Characters)
        return String(hmacBase64)
    }
}
