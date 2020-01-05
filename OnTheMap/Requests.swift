//
//  Requests.swift
//  OnTheMap
//
//  Created by Work  on 12/13/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation


struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}

struct LoginRequest: Codable {
    let  account: Account
    let  session: Session
    
}

struct LoginErr: Codable {
    let status: Int
    let error: String
}

extension LoginErr: LocalizedError {
    var description: String? {
         return error
    }
}

struct PostStudentLocation: Codable {
   
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
   
    init(uniqueKey: String,firstName: String, lastName:String, mapString: String, mediaURL: String, latitude: Double, longitude: Double ){
        self.firstName = firstName
        self.lastName = lastName
        self.uniqueKey = uniqueKey
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
}






