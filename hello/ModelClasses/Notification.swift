//
//  Notification.swift
//  Zelio
//
//  Created by Reddy Roja on 25/11/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation

class Notifications {
    var  id:Int?
    var uuid:String?
    var userUid:String?
    var switchBoardDeviceId: Int?
    var switchBoardUid: String!
    var zelioName: String?
    var  notification:String?
    var  type:String?
    var  imageType:String?
    var backedUp:Int?
    var receivedOn:Double?
    var createdOn:String?
    var createdTime:Double?
    var status:Int?
    
    func convertToDictionary() ->[String:Any] {
        let dict:[String:Any] = ["switchBoardDeviceId":switchBoardDeviceId,"switchBoardUid":switchBoardUid,"zelioName":zelioName,"notification":notification,"type":type,"imageType":imageType,"receivedOn":receivedOn]
        return dict
        
    }


}


