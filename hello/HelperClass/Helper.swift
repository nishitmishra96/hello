//
//  Helper.swift
//  Zelio
//
//  Created by Reddy Roja on 10/12/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
import AudioToolbox.AudioServices
import UIKit
class HelperClass:NSObject {

    static func createNotificationObject(devId:Int?,decp:String,type:String,zelioName:String?,imgType:String) {
        let notification = Notifications()
    
        notification.zelioName = zelioName
        notification.notification = decp
        notification.type = type
        notification.imageType = imgType
        notification.switchBoardDeviceId = devId
        notification.receivedOn = Double(Date().millisecondsSince1970)
        notification.createdOn = getStringFromDate(date: Date())
        notification.createdOn = HelperClass.getStringFromDate(date: Date())
        
        if let switchBrdUId = UserDefaults.standard.value(forKey: "selectedSwitchBoardUid") as? String {
            notification.switchBoardUid = switchBrdUId
        }
        
        if Reachability.isConnectedToNetwork() == true {
            UserProfileNetworkInterface.shared.saveDeviceNotifications(devices: [notification]) { (responseObj) in
                if let response = responseObj,let array = response.array, array.count > 0 {
                    let devices = Parser.sharedInsatnce().parseNotifications(from: array)
                    CacheManager.shared.inserNotifications(notification: devices){}
                } else {
                    CacheManager.shared.inserNotifications(notification: [notification]){}
                }
            }
        } else {
            CacheManager.shared.inserNotifications(notification: [notification]){}
        }
    }
    static func showRequiredAlertswith(flagArray:[Bit]) {
        
        //show powercuts  alert
        
        if Int(flagArray[7].rawValue) == 1 && Int(flagArray[6].rawValue) == 1 && Int(flagArray[5].rawValue) == 1 && Int(flagArray[4].rawValue) == 1 && Int(flagArray[3].rawValue) == 1 && Int(flagArray[2].rawValue) == 1 && Int(flagArray[1].rawValue) == 1 && Int(flagArray[0].rawValue) == 1 {
            return
        } else {
            if Int(flagArray[7].rawValue) == 0 && Int(flagArray[6].rawValue) == 0 && Int(flagArray[5].rawValue) == 0 && Int(flagArray[4].rawValue) == 0 && Int(flagArray[3].rawValue) == 0 && Int(flagArray[2].rawValue) == 0 && Int(flagArray[1].rawValue) == 0 && Int(flagArray[0].rawValue) == 0 && NotificationSettings.sharedInstance().isPowerCutEnabled == true && ShownNotifications.sharedInstance().powercuts == false {
                
                HelperClass.showNotificationWithName(name: ErrorName.powercuts)
                ShownNotifications.sharedInstance().powercuts = true
                HelperClass.delayWithSeconds(20) {
                    ShownNotifications.sharedInstance().powercuts = false
                }
                return
            }
            
            if Int(flagArray[7].rawValue) == 1  && NotificationSettings.sharedInstance().isMainsOnEnabled == true && ShownNotifications.sharedInstance().mainsOn == false  {
                HelperClass.showNotificationWithName(name: ErrorName.mainsOn)
                ShownNotifications.sharedInstance().mainsOn = true
                HelperClass.delayWithSeconds(20) {
                    ShownNotifications.sharedInstance().mainsOn = false
                }
            }
            //show mcb tripped  alert
            if Int(flagArray[6].rawValue) == 1 && NotificationSettings.sharedInstance().isMcbTripEnabled == true && ShownNotifications.sharedInstance().mcbTripped == false {
                HelperClass.showNotificationWithName(name: ErrorName.mcbTripped)
                ShownNotifications.sharedInstance().mcbTripped = true
                HelperClass.delayWithSeconds(20) {
                    ShownNotifications.sharedInstance().mcbTripped = false
                }
            }
            //show low battery alert
            if Int(flagArray[4].rawValue) == 1 && NotificationSettings.sharedInstance().isWrongOutputEnabled && ShownNotifications.sharedInstance().wrongOutput == false {
                HelperClass.showNotificationWithName(name: ErrorName.wrongOutPut)
                ShownNotifications.sharedInstance().wrongOutput = true
                HelperClass.delayWithSeconds(20) {
                    ShownNotifications.sharedInstance().wrongOutput = false
                }
            }
            //show overloaded alert
            if Int(flagArray[3].rawValue) == 1 && NotificationSettings.sharedInstance().isShortCircuitEnabled == true && ShownNotifications.sharedInstance().shortcircuit == false {
                HelperClass.showNotificationWithName(name: ErrorName.shrotCircuit)
                ShownNotifications.sharedInstance().shortcircuit = true
                HelperClass.delayWithSeconds(20) {
                    ShownNotifications.sharedInstance().shortcircuit = false
                }
            }
            if Int(flagArray[2].rawValue) == 1 &&  NotificationSettings.sharedInstance().isOverLoadEnabled == true && ShownNotifications.sharedInstance().overload == false {
                HelperClass.showNotificationWithName(name: ErrorName.overLoad)
                ShownNotifications.sharedInstance().overload = true
                HelperClass.delayWithSeconds(20) {
                    ShownNotifications.sharedInstance().overload = false
                }
            }
            if Int(flagArray[1].rawValue) == 1  && NotificationSettings.sharedInstance().isLowBatteryEnabled == true && ShownNotifications.sharedInstance().lowBattery == false {
                HelperClass.showNotificationWithName(name: ErrorName.lowBattery)
                ShownNotifications.sharedInstance().lowBattery = true
                HelperClass.delayWithSeconds(20) {
                    ShownNotifications.sharedInstance().lowBattery = false
                }
            }
            if Int(flagArray[0].rawValue) == 1 &&  NotificationSettings.sharedInstance().isOverHeatEnabled == true && ShownNotifications.sharedInstance().overHeating == false {
                HelperClass.showNotificationWithName(name: ErrorName.overHeating)
                ShownNotifications.sharedInstance().overHeating = true
                HelperClass.delayWithSeconds(20) {
                    ShownNotifications.sharedInstance().overHeating = false
                }
            }
        }
    }
    static func checkIfApplicationIsInBackgroundOrNot(completion: @escaping () -> ()) -> Bool {
        var boolValue:Bool = false
        DispatchQueue.main.async {
            if ((UIApplication.shared.applicationState == .background) && (NotificationSettings.sharedInstance().isEnabledBgNotifications == true)) {
                boolValue = true
            } else {
                boolValue = false
            }
        }
        return boolValue
    }
    
    private var isApplicationInBackground:Bool {
        DispatchQueue.main.async {
            return
        }
        return false
    }
    
    //show notification in foreground or background
    static func showNotificationWithName(name:String) {
        var zelioName:String?
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,let devId = UserDefaults.standard.value(forKey: "selectedDeviceId") as? Int,let switchBrdUId = UserDefaults.standard.value(forKey: "selectedSwitchBoardUid") as? String else { return }
            CacheManager.shared.fetchZelioName(deviceId: devId, switchbrdUid: switchBrdUId) { (zelio) in
                guard let zelioDevName = zelio else {return}
                zelioName = zelioDevName
                
                if NotificationSettings.sharedInstance().isVibrateEnable  == true {
                    self.vibrate()
                }
                DispatchQueue.main.async {
                    if name == ErrorName.powercuts {
                        HelperClass.createNotificationObject(devId:devId,decp:NotificationDecp.powercuts,type:ErrorName.powercuts,zelioName:zelioName,imgType:NotificationImage.powercuts)
                        
                        
                        if ((UIApplication.shared.applicationState == .background) && (NotificationSettings.sharedInstance().isEnabledBgNotifications == true)) {
                            
                        }
                    } else if name == ErrorName.mainsOn {
                        HelperClass.createNotificationObject(devId:devId,decp:NotificationDecp.mainsOn,type:ErrorName.mainsOn,zelioName:zelioName,imgType:NotificationImage.mainsOn)
                        
                        
                        if ((UIApplication.shared.applicationState == .background) && (NotificationSettings.sharedInstance().isEnabledBgNotifications == true)) {
                            
                        }
                    } else if name == ErrorName.mcbTripped {
                        HelperClass.createNotificationObject(devId:devId,decp:NotificationDecp.mcbTripped,type:ErrorName.mcbTripped,zelioName:zelioName,imgType:NotificationImage.mcbTripped)
                       
                        
                        if ((UIApplication.shared.applicationState == .background) && (NotificationSettings.sharedInstance().isEnabledBgNotifications == true)) {
                            
                        }
                    } else if name == ErrorName.shrotCircuit {
                        
                        
                        if ((UIApplication.shared.applicationState == .background) && (NotificationSettings.sharedInstance().isEnabledBgNotifications == true)) {
                            
                        }
                    } else if name == ErrorName.lowBattery {
                        
                    } else if name == ErrorName.wrongOutPut {
                        HelperClass.createNotificationObject(devId:devId,decp:NotificationDecp.wrongOutPut,type:ErrorName.wrongOutPut,zelioName:zelioName,imgType:NotificationImage.wrongOutPut)
                        
                        
                        if ((UIApplication.shared.applicationState == .background) && (NotificationSettings.sharedInstance().isEnabledBgNotifications == true)) {
                            
                        }
                    } else if name == ErrorName.overHeating {
                        HelperClass.createNotificationObject(devId:devId,decp:NotificationDecp.overHeating,type:ErrorName.overHeating,zelioName:zelioName,imgType:NotificationImage.overHeating)
                        
                        
                        if ((UIApplication.shared.applicationState == .background) && (NotificationSettings.sharedInstance().isEnabledBgNotifications == true)) {
                            
                        }
                    } else if name == ErrorName.overLoad {
                        HelperClass.createNotificationObject(devId:devId,decp:NotificationDecp.overHeating,type:ErrorName.overLoad,zelioName:zelioName,imgType:NotificationImage.overLoad)
                        
                        
                        if ((UIApplication.shared.applicationState == .background) && (NotificationSettings.sharedInstance().isEnabledBgNotifications == true)) {
                            
                        }
                    }
                }
            }
        }
    }
    static func vibrate() {
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) {
            // do what you'd like now that the sound has completed playing
        }
    }
    static func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
   static func getStringFromDate(date:Date) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM dd hh:mm:ss Z yyyy"
        let currentDate = Date()
        return dateFormatter.string(from:currentDate)
    }
    
   static func getDateFromMills(date:Double)->String {
        let milisecond = date
        let dateVar = Date(timeIntervalSince1970: (milisecond / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: dateVar)
    }
}

class NotificationSettings:NSObject {
    
    var isVibrateEnable:Bool = true
    var isEnabledBgNotifications:Bool = false
    var isLoadExceedEnabled:Bool = true
    var isPowerCutEnabled:Bool = true
    var isMainsOnEnabled:Bool = true
    var isLowBatteryEnabled:Bool = true
    var isOverLoadEnabled:Bool = true
    var isMcbTripEnabled:Bool = true
    var isBatteryWaterLevelEnabled:Bool = true
    var isWrongOutputEnabled:Bool = true
    var isShortCircuitEnabled:Bool = true
    var isOverHeatEnabled:Bool = true
    var loadExceedPercentage:Int?
    
    static let shared:NotificationSettings = NotificationSettings()
    
    class func sharedInstance() -> NotificationSettings {
        return NotificationSettings.shared
    }
}
class ShownNotifications: NSObject {
    
    var mainsOn = false
    var powercuts = false
    var mcbTripped = false
    var overload = false
    var loadexceeds = false
    var lowBattery = false
     var shortcircuit = false
    var wrongOutput = false
    var overHeating = false
    
    
    static let shared:ShownNotifications = ShownNotifications()
    
    class func sharedInstance() -> ShownNotifications {
        return ShownNotifications.shared
    }
}
class PreviousStatus: NSObject {
    var shortCircuit:Int?
    var wrongOutput:Int?
    var overTemperature:Int?
    static let shared:PreviousStatus = PreviousStatus()
    
    class func sharedInstance() -> PreviousStatus {
        return PreviousStatus.shared
    }
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
