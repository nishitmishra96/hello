//
//  Parser.swift
//  Zelio
//
//  Created by Reddy Roja on 12/11/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
import SwiftyJSON

class Parser:  NSObject {
    static let shared = Parser()
    static func sharedInsatnce()->Parser {
        return Parser.shared
    }
    func parseNotifications(from dataArray:[JSON])->[Notifications]? {
        var notifications = [Notifications]()
        dataArray.forEach({ (deviceJson) in
            let notification = Notifications()
            var deviceDict = deviceJson.dictionary
            notification.id = deviceDict?["id"]?.int
            notification.uuid = deviceDict?["uuid"]?.string
            notification.userUid = deviceDict?["userUid"]?.string
            notification.switchBoardDeviceId = deviceDict?["switchBoardDeviceId"]?.int
            notification.switchBoardUid = deviceDict?["switchBoardUid"]?.string
            notification.zelioName = deviceDict?["zelioName"]?.string
            notification.notification = deviceDict?["notification"]?.string
            notification.type = deviceDict?["type"]?.string
            notification.imageType = deviceDict?["imageType"]?.string
            notification.backedUp = deviceDict?["backedUp"]?.int
            notification.receivedOn = deviceDict?["receivedOn"]?.double
            notification.createdOn = deviceDict?["createdOn"]?.string
            notification.createdTime = deviceDict?["createdTime"]?.double
            notification.status = deviceDict?["status"]?.int
            notifications.append(notification)
        })
        return notifications
    }
    func parseDevices(from dataArray: [JSON] ) -> [Zelio] {
        var devices = [Zelio]()
        dataArray.forEach({ (deviceJson) in
            let newdevice = Zelio()
            var deviceDict = deviceJson.dictionary
            newdevice.id = deviceDict?["switchBoardDeviceId"]?.int
            newdevice.switchBoardUid = deviceDict?["switchBoardUid"]?.string
            newdevice.switchBoardDeviceId = deviceDict?["switchBoardDeviceId"]?.int
            newdevice.name = deviceDict?["name"]?.string
            newdevice.modelNumber = deviceDict?["modelNumber"]?.int
            newdevice.disChargingCurrent = deviceDict?["disChargingCurrent"]?.double
            newdevice.chargingCurrent = deviceDict?["chargingCurrent"]?.double
            newdevice.mainsVoltage = deviceDict?["mainsVoltage"]?.double
            newdevice.timeRemainForCharge = deviceDict?["timeRemainForCharge"]?.int
            newdevice.timeRemainForDisCharge = deviceDict?["timeRemainForDisCharge"]?.int
            newdevice.batteryCharge = deviceDict?["batteryCharge"]?.int
            newdevice.batteryDisCharge = deviceDict?["batteryDisCharge"]?.int
            newdevice.batteryVoltage = deviceDict?["batteryVoltage"]?.double
            newdevice.switchStatus = deviceDict?["switchStatus"]?.int
            newdevice.mainsOkFlag = deviceDict?["mainsOkFlag"]?.int
            newdevice.lowBatteryFlag = deviceDict?["lowBatteryFlag"]?.int
            newdevice.overLoadLEDflag = deviceDict?["overLoadLEDflag"]?.int
            newdevice.fuseBlownFlag = deviceDict?["fuseBlownFlag"]?.int
            newdevice.batteryType = deviceDict?["batteryType"]?.string
            newdevice.inverterUPSflag = deviceDict?["inverterUPSflag"]?.int
            newdevice.holidayModeFlag = deviceDict?["holidayModeFlag"]?.int
            newdevice.inverterVoltReference = deviceDict?["inverterVoltReference"]?.int
            newdevice.errorCases = deviceDict?["errorCases"]?.int
            newdevice.highPowerMode = deviceDict?["highPowerMode"]?.int
            newdevice.chargingProfile = deviceDict?["chargingProfile"]?.int
            newdevice.chargingProfileType = deviceDict?["chargingProfileType"]?.string
            newdevice.ecoOrUps = deviceDict?["ecoOrUps"]?.int
            newdevice.unusedString = deviceDict?["unusedString"]?.string
            newdevice.zelioBatteryType = deviceDict?["zelioBatteryType"]?.string
            newdevice.batteryBrand = deviceDict?["batteryBrand"]?.string
            newdevice.batteryCapacity = deviceDict?["batteryCapacity"]?.string
            newdevice.optimizationStartTime = deviceDict?["optimizationStartTime"]?.double
            newdevice.optimizationResult = deviceDict?["optimizationResult"]?.string
            newdevice.optimizationProgress = deviceDict?["optimizationProgress"]?.int
            newdevice.nfLoadPercentage = deviceDict?["nfLoadPercentage"]?.int
            newdevice.nfLoadExceeds = deviceDict?["nfLoadExceeds"]?.int
            newdevice.nfPowerCut = deviceDict?["nfPowerCut"]?.int
            newdevice.nfLowBattery = deviceDict?["nfLowBattery"]?.int
            newdevice.nfZelioOverLoaded = deviceDict?["nfZelioOverLoaded"]?.int
            newdevice.nfMcbTripped = deviceDict?["nfMcbTripped"]?.int
            newdevice.nfWaterLevelLow = deviceDict?["nfWaterLevelLow"]?.int
            newdevice.nfVibrate = deviceDict?["nfVibrate"]?.int
            newdevice.bgNotification = deviceDict?["bgNotification"]?.int
            newdevice.nfLoadExceedsPercentage = deviceDict?["nfLoadExceedsPercentage"]?.int
            newdevice.uuid = deviceDict?["uuid"]?.string
            newdevice.macId = deviceDict?["macId"]?.string
            newdevice.zelioName = deviceDict?["zelioName"]?.string
            newdevice.nfOverHeating = deviceDict?["nfOverHeating"]?.int
            newdevice.nfWrongOutput = deviceDict?["nfWrongOutput"]?.int
            newdevice.nfShortCircuit = deviceDict?["nfShortCircuit"]?.int
            newdevice.barCode = deviceDict?["barCode"]?.string
            newdevice.nfMainsOn = deviceDict?["nfMainsOn"]?.int
            newdevice.countId = deviceDict?["id"]?.int
            
            devices.append(newdevice)
        })
        return devices
    }
    
    func getDeviceEntity(device: CSRDeviceEntity?) -> DeviceEntity {
        let deviceEntity = DeviceEntity()
        deviceEntity.appearance = device?.appearance.intValue ?? nil
        deviceEntity.authCode = nil //device?.authCode ?? nil
        deviceEntity.deviceHash = nil//device?.deviceHash  ?? nil
        deviceEntity.deviceId = device?.deviceId == nil ? nil : device?.deviceId.intValue
        deviceEntity.isFavourite = device?.favourite == nil ? nil : device?.favourite.intValue
        deviceEntity.isAssociated = device?.isAssociated == nil ? nil : device?.isAssociated.intValue
        deviceEntity.modelLow = nil//device?.modelLow  ?? nil
        deviceEntity.modelHigh = nil//device?.modelHigh  ?? nil
        deviceEntity.name = device?.name  ?? nil
        deviceEntity.uid = nil//device?.uuid  ?? nil
        deviceEntity.dmKey = nil //nildevice?.dhmKey  ?? nil
        deviceEntity.placeUid = nil
        deviceEntity.devices = nil
        deviceEntity.floorUid = nil
        deviceEntity.facilityUid = nil
        deviceEntity.roomUid = nil
        deviceEntity.strDmKey = nil
        deviceEntity.refId = nil
        deviceEntity.uuidHigh = nil
        
        return deviceEntity
        
    }
 func getZelioEntity(device: ZelioModel?) -> Zelio {
    let deviceEntity = Zelio()
    deviceEntity.switchBoardDeviceId = device?.switchBoardDeviceId ?? nil
    deviceEntity.modelNumber = device?.modelNumber ?? nil
    deviceEntity.id = device?.id ?? nil
    deviceEntity.mainsOkFlag = device?.mainsOKFlag ?? nil
    deviceEntity.chargingCurrent = device?.chargingCurrent ?? nil
    deviceEntity.chargingProfile = device?.chargingProfile ?? nil
    deviceEntity.batteryVoltage = device?.batteryVoltage ?? nil
    deviceEntity.ecoOrUps = device?.ecoOrUps ?? nil
    deviceEntity.fuseBlownFlag = device?.fuseBlownFlag ?? nil
    deviceEntity.overLoadLEDflag = device?.overLoadLEDflag ?? nil
    deviceEntity.lowBatteryFlag = device?.lowBatteryFlag ?? nil
    return deviceEntity
    }
    func parserUser(serverUser : [String: Any?]) -> User {
        let  user = User()
        user.id = serverUser["id"] as? Int
        user.phoneNumber = serverUser["contactNumber"] as? String
        user.firstName = serverUser["firstName"] as? String
        user.lastName = serverUser["lastName"] as? String
        user.countryCode = serverUser["countryCode"] as? String
        user.validationCode = serverUser[" validationCode"] as? String
        user.uuid = serverUser["uuid"] as? String
        user.password = serverUser["password"] as? String
        user.roles = serverUser["roles"] as? String
        user.createdTime = serverUser["createdTime"] as? Double
        user.email = serverUser["email"] as? String
        user.status = serverUser["status"] as? Int
        user.flags = serverUser["flags"] as? Int
        return user
    }

}

