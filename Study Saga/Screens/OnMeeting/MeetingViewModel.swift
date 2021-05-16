//
//  MeetingViewModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/23/21.
//

import Foundation
import UIKit
import Combine
import MobileRTC
import Alamofire

enum MobileRTCTokenType: String {
    case token = "token"
    case zak = "zak"
}

class MeetingViewModel: NSObject, ObservableObject {
    
    @Published var lesson: Lesson?
    
    let apiKey = "zAcsToAFT_y7HOffy3odiA"
    let apiSecret = "rk6Od4alRIz0n13vRRpV10q5LGgNV9cEtKR5"
    
    func convertToBase64String(_ dict: [String: Any]) -> String {
        do {
            let headerJWTData: Data = try JSONSerialization.data(
                withJSONObject: dict,
                options: .prettyPrinted
            )
            let headerJWTBase64 = headerJWTData.base64EncodedString()
            return headerJWTBase64
            
        } catch let error {
            fatalError("Dictionary cannot convert to base64: \(error)")
        }
    }
    
    /// Handle Join Meeting.
    func joinMeeting() {
        if let meetingService = MobileRTC.shared().getMeetingService() {
            let param = MobileRTCMeetingJoinParam()
            param.meetingNumber = "7162287375"
            param.password = "DG6U1P"
            param.userName = AccountManager.manager.loggedInUser?.name
            
            // Let MobileRTC handle join meeting.   
            // This framework will handle the UI.
            meetingService.joinMeeting(with: param)
        }
    }
}
