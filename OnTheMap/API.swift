//
//  API.swift
//  OnTheMap
//
//  Created by Work  on 12/13/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
class API{
    static let shared = API()
    
    func login(_ username: String, _ password: String , completion: @escaping (_ success: Bool, _ error : Error?)-> Void){
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    
                    completion(false, error)
                    return
                }
             
            }//End if
            /*
             
             if  let statusCode = response as? HTTPURLResponse {
             if ( (statusCode.statusCode >= 200) && (statusCode.statusCode < 300) ) {
             do {
             let data = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
             print(data)
             DispatchQueue.main.async {
             completion(true, error)
             }
             }catch {
             DispatchQueue.main.async {
             completion(false, error)
             }
             return
             }
             
             }else {
             DispatchQueue.main.async {
             completion(false, error)
             }
             }
             }
             
  
             */
            
            guard let data = data else {
                return
            }
            if let statusCode = response as? HTTPURLResponse{
                if ( (statusCode.statusCode >= 200) && (statusCode.statusCode < 300) ){
                    
                }
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            
            print(String(data: newData, encoding: .utf8)!)
               //  decoder , do .
//            let decoder = JSONDecoder()
            do {
                let decoder = JSONDecoder()
                let responseObj = try decoder.decode(LoginRequest.self, from: newData)
                DispatchQueue.main.async {
                    
                    completion(true, nil)
                }
               //completion(responseObj, nil )
                
            } catch { //another do to ckech the what is the err
                
                do {
                    let dec = JSONDecoder()
                    let resp = try dec.decode(LoginErr.self, from: newData)
                    DispatchQueue.main.async {
                        completion(false, resp)
                    }
                } catch {
                    DispatchQueue.main.async {
                        
                        completion(false, error)
                    }
                }//End inner catch
            } //End outer catch
            
        }
        task.resume()
    }//End login
    
    func logout (completion: @escaping (_ success: Bool, _ error : Error?)-> Void)  {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    
                    completion(false, error)
                    return
                }
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            do {
               let data = try JSONDecoder().decode(Session.self, from: newData!)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }//End logout
   
    func getAllStudents(limit: Int = 100, completion: @escaping ([StudentInfo]?, Error? )->() ){
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=\(limit)order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                DispatchQueue.main.async {
                    completion(nil, error)
                    return
                }
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObj = try decoder.decode(StudentResults.self, from: data!)
                DispatchQueue.main.async {
                    completion(responseObj.results, nil)
                }
            } catch{
                print(error.localizedDescription)
                completion(nil, error)
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }//End getAllStudents
    
    func postStudent(_ location: PostStudentLocation, completion: @escaping(_ success: Bool, _ error : Error? ) -> ()) {
        
        var data: Data?
       
        do {
            data = try JSONEncoder().encode(location)
        } catch {
          print(error.localizedDescription)
            return
        }
        
//        var uniqueKey = location.uniqueKey
//        var mapString = location.mapString
//        var mediaUrl = location.mediaURL
//        var lat = location.latitude
//        var long = location.longitude
        
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completion(false, error)
                    return
                }
                
            }
            if  let statusCode = response as? HTTPURLResponse {
                if ( (statusCode.statusCode >= 200) && (statusCode.statusCode < 300) ) {
                    do {
                         let data = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        print(data)
                        DispatchQueue.main.async {
//                            completion(true, error)
                            completion(true, nil)
                        }
                    }catch {
                        DispatchQueue.main.async {
                            completion(false, error)
                        }
                        return
                    }
                   
                }else {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
            
            
            
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }//End postStudent
    
    
}//End API
