//
//  UserProfileUtility.swift
//  Zelio
//
//  Created by Reddy Roja on 31/10/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
import SwiftyJSON
class UserProfileNetworkInterface:NSObject {
  
    static let shared = UserProfileNetworkInterface()
    
    func processRegistrationFor(user: User, completion: @escaping (JSON?) -> ()) {
        guard let email = user.email, let answer = user.securityAnswer, let password = user.password, let mobileNum = user.phoneNumber,let name = user.firstName else {
            print("Show alert here")
            return
        }
        
        var userObjDictionary: [String: Any]
        if email.count  > 2 {
            userObjDictionary = ["email": email, "password": password,"firstName":name,"tenantUid":"zelio"]
            print(userObjDictionary)
        } else {
            userObjDictionary = ["contactNumber" : mobileNum, "password": password,"firstName":name,"tenantUid":"zelio"]
            print(userObjDictionary)
        }
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["postUser"] as! String)")!
                
                NetworkUtility.postRequest(url: url, postData:userObjDictionary) { (resObj) in
                    completion(resObj)
                }
            }
        }
    }
    
    func processLoginFor(user: User, completion: @escaping (JSON?) -> ()) {
        _ = ["userName": user.firstName, "password": user.password]
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["getUser"] as! String)")!
                NetworkUtility.getRequest(url: url, completion: { (respObj) in
                    completion(respObj)
                })
                
            }
        }
    }
    
    
    func processForgotPasswordFor(user: User, completion: @escaping (JSON?) -> ()) {
        guard  let userName = user.email, let _ = user.securityAnswer else {
            print("Show alert here")
            return
        }
        var userObjDictionary: [String: Any]
        userObjDictionary = [ "userName": userName,"tenantUid":"zelio"];
        
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["forgotPassword"] as! String)")!
                
                NetworkUtility.postRequestWithoutHeader(url: url, postData:userObjDictionary) { (resObj) in
                    completion(resObj)
                    
                }
            }
        }
    }
    func saveUserObject(user:User?,completion: @escaping (JSON?) -> ()) {
        guard let userObj = user else { return }
        let object:[String:Any] = ["firstName":userObj.firstName,"lastName":userObj.lastName,"countryCode":userObj.countryCode,"validationCode":userObj.validationCode,"uuid":userObj.uuid,"email":userObj.email,"securityAnswer":userObj.securityAnswer,"phoneNumber":userObj.phoneNumber,"createdTime":userObj.createdTime,"modifiedTIme":userObj.modifiedTIme]
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                var url:URL
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["updateUser"] as! String)")!
                NetworkUtility.putUserRequest(url: url, postData: object) { (response) in
                    completion(response)
                }
            }
        }
    }
    
    func processOtpGenerationFor(phoneNumber: String,email: String, completion: @escaping (JSON?) -> ()) {
        var phoneNumObj = [String: Any]()
        phoneNumObj =  ["uuid": email, "contactNumber": phoneNumber]
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["generateOtp"] as! String)")!
                
                NetworkUtility.postRequest(url: url, postData: phoneNumObj,completion: { (respObj) in
                    completion(respObj)
                })
            }
        }
    }
    
    func processOtpVerificationFor(email: String,otp: String, completion: @escaping (JSON?) -> Void) {
        var postDataObj = [String: Any]()
        postDataObj =  ["uuid": email, "otp": otp]
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["generateOtp"] as! String)")!
                
                NetworkUtility.putRequest(url: url, postData: postDataObj) { (respObj) in
                    completion(respObj)
                }
            }
        }
    }
    
    func processResendOtpFor(email: String, completion: @escaping (JSON?) -> ()) {
        var postDataObj = [String: Any]()
        postDataObj =  ["uuid": email]
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["resendOtp"] as! String)")!
                
                NetworkUtility.postRequest(url: url, postData: postDataObj,completion: { (respObj) in
                    completion(respObj)
                })
            }
        }
    }
    
    func processResetPasswordFor(phoneNumber: String,email: String,otp: String, completion: @escaping (JSON?) -> ()) {
        var postDataObj = [String: Any]()
        
        postDataObj =  ["uuid": email, "password": phoneNumber]
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["resetPassword"] as! String)")!
                
                NetworkUtility.postRequest(url: url, postData: postDataObj,completion: { (respObj) in
                    completion(respObj)
                })
            }
        }
    }
    
    func processSaveprofilePicture(with filename:String,image:UIImage,completion: @escaping (JSON?) -> ()) {
        let imgData = image.jpegData(compressionQuality: 0.2)
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist"),let data = imgData {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                let url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["profilePic"] as! String)")!
                NetworkUtility.uploadMultipartImage(fileName: filename, url: url, json: data) { (resObj) in
                     completion(resObj)
                }
            }
        } else {
            completion(nil)
        }
    }
    func fetchUserProfilePhoto(completion: @escaping (Data?) -> ()) {
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["profilePic"] as! String)")!
                NetworkUtility.getRequestWithOutTenentId(url: url, completion: { (respObj) in
                    completion(respObj)
                })
                
            }
        }
    }
    func processAddNewUser(phoneNumber: String,email: String,name: String, completion: @escaping (JSON?) -> ()) {
        var postDataObj = [String: Any]()
        
        postDataObj =  ["contactNumber": phoneNumber, "email": email,"firstName":name]
        print(postDataObj)
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["share"] as! String)")!
                NetworkUtility.postRequestWithOutTenentUid(url: url, postData: postDataObj,completion: { (respObj) in
                    completion(respObj)
                })
            }
        }
    }
    func saveDevice(devices: Zelio, completion: @escaping (JSON?) -> ()) {
        print(devices)
        var zeliodevices = [Zelio]()
        zeliodevices.append(devices)
        let dicArray = zeliodevices.map { $0.convertToDictionary() }
        let data = try? JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted)
        print(String(data: data!, encoding: String.Encoding.utf8) ?? "")
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["saveDevice"] as! String)")!
                NetworkUtility.putRequestRaw(url: url, json:data!) { (resObj) in
                    completion(resObj)
                }
            }
        }
    }
    func saveDevices(devices: [Zelio], completion: @escaping (JSON?) -> ()) {
        let dicArray = devices.map { $0.convertToDictionary() }
        let data = try? JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted)
        print(String(data: data!, encoding: String.Encoding.utf8) ?? "")
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["saveDevice"] as! String)")!
                NetworkUtility.putRequestRaw(url: url, json:data!) { (resObj) in
                    completion(resObj)
                }
            }
        }
    }
    func deleteDevices(devices: Zelio, completion: @escaping (JSON?) -> ()) {
        print(devices)
        var zeliodevices = [Zelio]()
        zeliodevices.append(devices)
        let dicArray = zeliodevices.map { $0.convertToDictionary() }
        let data = try? JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted)
        print(String(data: data!, encoding: String.Encoding.utf8) ?? "")
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["saveDevice"] as! String)")!
                NetworkUtility.deleteRequest(url: url, json: data!) { (response) in
                    completion(response)
                }
            }
        }
    }
    public func getData(completion: @escaping (JSON?) -> ()) {
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist"),let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
            guard let url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["getDevices"] as! String)") else { return }
            NetworkUtility.getRequest(url: url, completion: { (respObj) in
            completion(respObj)
            })
        }
    }
    
    func saveDeviceNotifications(devices: [Notifications], completion: @escaping (JSON?) -> ()) {
        print(devices)
        var zeliodevices = devices
      
        let dicArray = zeliodevices.map { $0.convertToDictionary() }
        let data = try? JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted)
        print(String(data: data!, encoding: String.Encoding.utf8) ?? "")
        var url: URL
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist") {
            if let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["notifications"] as! String)")!
                NetworkUtility.putRequestRaw(url: url, json:data!) { (resObj) in
                    completion(resObj)
                }
            }
        }
    }
    public func getDeviceNotifications(completion: @escaping (JSON?) -> ()) {
        if let path = Bundle.main.path(forResource: "Communication", ofType: "plist"),let dicPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
            guard let url = URL(string: "\(NetworkConstants.baseURL)\(dicPlist["notifications"] as! String)") else { return }
            NetworkUtility.getRequest(url: url, completion: { (respObj) in
                completion(respObj)
            })
        }
    }
   
    
}
