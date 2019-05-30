//
//  User.swift
//  Zelio
//
//  Created by Reddy Roja on 31/10/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    var id:Int?
    var firstName: String?
    var lastName: String?
    var countryCode: String?
    var validationCode: String?
    var uuid: String?
    var password: String?
    var status: Int?
    var email: String?
    var roles: String?
    var createdTime: Double?
    var modifiedTIme: Double?
    var timezone: String?
    var timezoneOffset: String?
    var tag: String?
    var parentTag: String?
    var phoneNumber: String?
    var securityAnswer: String?
    var otp: String?
    var flags:Int?
    var tenantUid:String = "zelio"
    
    
    override init() {
        
    }
    
    init(email: String, password: String, securityAns: String, mobileNum: String,uuid: String,firstName:String) {
        super.init()
        
        self.email = email
        self.password = password
        self.securityAnswer = securityAns
        self.phoneNumber = mobileNum
        self.uuid = uuid
        self.firstName = firstName
    }
    
    init(email: String, password: String, phoneNumber: String? = nil, uuid: String) {
        super.init()
        
        //        var phoneNumberIn = email
        //        if let phone = phoneNumber {
        //            phoneNumberIn = phone
        //        }
        
        self.phoneNumber = phoneNumber
        self.email = email
        self.password = password
        self.uuid = uuid
    }
    
    init?(firstName: String?, lastName: String?, countryCode:String?, validationCode:String?, uuid:String?, password: String?, status: Int?, email: String?, roles: String?, createdTime: Double?, modifiedTIme: Double?, timezone: String?, timezoneOffset: String?, tag: String?, parentTag: String?, phoneNumber: String?, securityAnswer: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.countryCode = countryCode
        self.validationCode = validationCode
        self.uuid = uuid
        self.password = password
        self.status = status
        self.email = email
        self.roles = roles
        self.createdTime = createdTime
        self.modifiedTIme = modifiedTIme
        self.timezone = timezone
        self.timezoneOffset = timezoneOffset
        self.tag = tag
        self.parentTag = parentTag
        self.phoneNumber = phoneNumber
        self.securityAnswer = securityAnswer
    }
}
