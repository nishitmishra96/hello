//
//  NetworkUtility.swift
//  Zelio
//
//  Created by Reddy Roja on 31/10/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkUtility: NSObject {
    
    class func postRequest(url: URL,postData:[String: Any], completion: @escaping (JSON?) -> ()) {
        var credentialData:Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        var base64Credentials: String!
        if credentialData != nil {
            base64Credentials  = credentialData?.base64EncodedString()
        } else {
        }
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials ?? "")",
            "Accept": "application/json",
            "Content-Type": "application/json",
            "tenantUid":"zelio"
        ]
        Alamofire.request(url, method: .post, parameters: postData, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                //                print(response)
                switch response.result {
                case .success:
                    if(response.result.value != nil){
                        let json = JSON(response.result.value!)
                        completion(json)
                    }
                case .failure( _):
                    completion(nil)
                }
        }
    }
    class func postRequestWithOutTenentUid(url: URL,postData:[String: Any], completion: @escaping (JSON?) -> ()) {
        var credentialData:Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {
            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        var base64Credentials: String!
        if credentialData != nil {
            base64Credentials  = credentialData?.base64EncodedString()
        } else {
        }
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials ?? "")",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        Alamofire.request(url, method: .post, parameters: postData, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                //                print(response)
                switch response.result {
                case .success:
                    if(response.result.value != nil){
                        let json = JSON(response.result.value!)
                        completion(json)
                    }
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
    
    class func postRequestWithoutHeader(url: URL,postData:[String: Any], completion: @escaping (JSON?) -> ()) {
        var credentialData:Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {
            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        
        var base64Credentials: String?
        if credentialData != nil {
            base64Credentials  = credentialData?.base64EncodedString()
        } else {
        }
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials ?? "")",
            "Accept": "application/json",
            "Content-Type": "application/json",
            "tenantUid":"zelio"
        ]
        Alamofire.request(url, method: .post, parameters: postData, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                //                print(response)
                switch response.result {
                case .success:
                    if(response.result.value != nil){
                        let json = JSON(response.result.value!)
                        completion(json)
                    }
                case .failure(let error):
                    completion(nil)
                }
        }
    }
    class func putUserRequest(url: URL,postData:[String: Any], completion: @escaping (JSON?) -> ()) {
        var credentialData:Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {
            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        let base64Credentials = credentialData?.base64EncodedString()
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials ?? "")",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .put, parameters: postData, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                //                print(response)
                switch response.result {
                case .success:
                    if(response.result.value != nil){
                        let json = JSON(response.result.value!)
                        completion(json)
                    }
                case .failure(let error):
                    completion(nil)
                }
        }
    }
    class func getRequest(url:URL,completion: @escaping (JSON?) -> ()) {
        
        var credentialData:Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {
            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        let base64Credentials = credentialData?.base64EncodedString()
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials ?? "")",
            "Accept": "application/json",
            "Content-Type": "application/json",
            "tenantUid":"zelio"
        ]
        
        Alamofire.request(url,headers:headers).responseJSON { response in
            switch response.result {
            case .success:
                //                print("response:",response)
                if(response.result.value != nil){
                    let json = JSON(response.result.value!)
                    completion(json)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
        
    }
    class func getRequestWithOutTenentId(url:URL,completion: @escaping (Data?) -> ()) {
        
        var credentialData:Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {
            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        let base64Credentials = credentialData?.base64EncodedString()
      
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64Credentials ?? "")",
            forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            completion(data)
           
        }
        
        task.resume()
     

    }
    
    class func putRequest(url: URL,postData:[String: Any], completion: @escaping (JSON?) -> ()) {
        var credentialData:Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {
            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        let base64Credentials = credentialData?.base64EncodedString()
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials ?? "")",
            "Accept": "application/json",
            "Content-Type": "application/json",
            "tenantUid":"zelio"
        ]
        
        Alamofire.request(url, method: .put, parameters: postData, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                //                print(response)
                switch response.result {
                case .success:
                    if(response.result.value != nil){
                        let json = JSON(response.result.value!)
                        completion(json)
                    }
                case .failure(let error):
                    completion(nil)
                }
        }
    }
    
    class func deleteRequest(url: URL,json:Data, completion: @escaping (JSON?) -> ()) {
        var credentialData: Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {
            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        let base64Credentials = credentialData?.base64EncodedString()
        var request = URLRequest(url:url)
        request.httpMethod = "DELETE"
        request.setValue("Basic \(base64Credentials ?? "")",
            forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json;//json.data(using: .utf8)!

        Alamofire.request(request).responseJSON { response in
            switch (response.result) {
            case .success:
                if(response.result.value != nil) {
                    let json = JSON(response.result.value!)
                    completion(json)
                }
                
            case .failure(let error):
                completion(nil)
            }
        }
    }
    
    class func putRequestRaw(url: URL,json:Data, completion: @escaping (JSON?) -> ()) {
        var credentialData:Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {
            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        let base64Credentials = credentialData?.base64EncodedString()
        var request = URLRequest(url:url)
        request.httpMethod = "PUT"
        request.setValue("Basic \(base64Credentials ?? "")",
            forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        request.httpBody = json;//json.data(using: .utf8)!
        Alamofire.request(request).responseJSON { response in
            switch (response.result) {
            case .success:
                if(response.result.value != nil) {
                    let json = JSON(response.result.value!)
                    completion(json)
                }
                
            case .failure(let error):
                completion(nil)
            }
        }
        
    }
    class func uploadMultipartImage(fileName:String,url: URL,json:Data, completion: @escaping (JSON?) -> ()) {
     
        var credentialData:Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {
            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        let base64Credentials = credentialData?.base64EncodedString()

        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials ?? "")",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(json, withName: "file", fileName: "name", mimeType: "image/png")
            }, to:url,headers:headers)
            { (result) in
                switch result {
                case .success(let upload,_,_ ):
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    upload.responseJSON
                        { response in
                            //print response.result
                            if response.result.value != nil
                            {
                                completion(JSON(response.result.value!))
                            }}
                case .failure(let _):
                    completion(nil)
                    break
                }
            }
    }
    
    
    class func downloadFirwareFile(url: URL,completion:@escaping (Int?) -> ()) {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        
        var credentialData: Data? = nil
        if let name = UserDefaults.standard.string(forKey: "UserName"),let pwd = UserDefaults.standard.string(forKey: "Password") {
            credentialData = "\(name):\(pwd)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        }
        let base64Credentials = credentialData?.base64EncodedString()
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials ?? "")",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        Alamofire.download(
            url,
            method: .get,
            parameters: headers,
            encoding: JSONEncoding.default,
            headers: headers,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
            }).response(completionHandler: { (DefaultDownloadResponse) in
                print(DefaultDownloadResponse)
                if DefaultDownloadResponse.response?.statusCode == 200 {
                    completion(DefaultDownloadResponse.response?.statusCode)
                    print("aa")
                }
            })
    }
}

