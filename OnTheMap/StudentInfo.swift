//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Work  on 12/15/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
struct StudentInfo: Codable {
    
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var latitude: Double
    var longitude: Double
    var mediaURL: String
    var updatedAt: String
    var createdAt: String
    
//    init(mapString: String, mediaUrl:String) {
//        self.mapString = mapString
//        self.mediaURL = mediaUrl
//
//    }
    
}

struct StudentResults: Codable {
    let results: [StudentInfo]
}
