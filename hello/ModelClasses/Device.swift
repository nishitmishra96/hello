//
//  Device.swift
//  LuminousSmartSwitch
//
//  Created by ramakrishna on 11/04/18.
//  Copyright © 2018 3Frames. All rights reserved.
//

import UIKit
import EVReflection

class Device: EVObject {
    var id: Int?
    var status: Int = 0
    var name: String?
    var deviceId: Int!
    var resourceid: Int?
    var identifier: Int!
    var switchboardUid: String!
    var roomUid: String!
    var facilityUid: String?
    var floorUid: String!
    var ordinal: Int?
    var uuid: String?
    var deviceType: String?
    var favourite: Bool?
    var placeUid: String?
    var isSwitchBusy: Bool = false

//override init(){
//    
//}
    
}
