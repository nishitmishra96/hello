//
//  CSRDeviceEntity.swift
//  Zelio
//
//  Created by Reddy Roja on 12/11/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
import EVReflection

class DeviceEntity: EVObject {
    var id: Int?
    var deviceHash: Int?
    var isAssociated: Int?
    var isFavourite: Int?
    var deviceId: Int?
    var name: String?
    var appearance: Int?
    var modelHigh: Int?
    var modelLow: Int?
    var authCode: Int?
    var model: Int?
    var placeId: Int?
    var refId: Int?
    var numGroups: Int?
    var databaseId: Int?
    var uuidHigh: Double?
    var uuidLow: Double?
    var dmKey: UInt8?
    var strDmKey: String?
    var associated: Int?
    var uid: String?
    var roomUid: String?
    var facilityUid: String?
    var floorUid: String?
    var devices: [Device]? = [Device]()
    var placeUid: String?

}
