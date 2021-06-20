//
//  FeedModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 20/06/2021.
//

import Foundation
import Combine


struct FeedModel: Hashable {
    
    var id: String = UUID().uuidString
    var title: String = ""
    var url: String = ""
    var thumb: String = ""
    var time: TimeInterval = Date().timeIntervalSince1970
}

extension FeedModel {
    init(json: [String: Any]) {
        self.title = json.stringValueForKey("title")
        self.url = json.stringValueForKey("link")
        self.time = Double(json.stringValueForKey("pubDate"))!/1000
        let randomThumbUrls = [
            "https://www.hcmus.edu.vn/images/2020/04/07/bn2.jpg",
            "https://media.kenhtuyensinh.vn/images/cms/2020/01/t-nhien.jpg",
            "https://sites.google.com/site/camnangtansv/_/rsrc/1396354609847/truong-dhai-hoc-khoa-hoc-tu-nhien/cac-co-so-cua-truong/29.jpg"
        ]
        let index = Int.random(in: 0...randomThumbUrls.count-1)
        self.thumb = randomThumbUrls[index]
    }
}
