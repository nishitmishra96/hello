//
//  Zelio.swift
//  Zelio
//
//  Created by Reddy Roja on 12/11/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
import EVReflection

class Zelio:EVObject {
    
    var switchBoardDeviceId: Int?
    var zelioName: String?
    var switchBoardUid: String?
    var id: Int?
    var name:String?
    var modelNumber: Int?
    var disChargingCurrent: Double? = 0.0
    var chargingCurrent: Double?
    var mainsVoltage: Double?
    var timeRemainForCharge: Int?
    var timeRemainForDisCharge: Int?
    var batteryCharge: Int?
    var batteryDisCharge: Int?
    var batteryVoltage: Double? = 0.0
    var switchStatus: Int?
    var mainsOkFlag: Int?
    var lowBatteryFlag: Int?
    var overLoadLEDflag: Int?
    var fuseBlownFlag: Int?
    var batteryType: String?
    var inverterUPSflag: Int?
    var holidayModeFlag: Int? = 0
    var inverterVoltReference: Int?
    var errorCases: Int?
    var highPowerMode: Int?
    var chargingProfile: Int?
    var chargingProfileType: String?
    var ecoOrUps: Int?
    var unusedString: String?
    var zelioBatteryType: String?
    var batteryBrand: String?
    var batteryCapacity: String?
    var optimizationStartTime: Double? = 0
    var optimizationResult: String?
    var optimizationProgress: Int? = 0
    var nfLoadPercentage: Int? = 1
    var nfLoadExceeds: Int? = 1
    var nfPowerCut: Int? = 1
    var nfLowBattery: Int? = 1
    var nfZelioOverLoaded: Int? = 1
    var nfMcbTripped: Int? = 1
    var nfWaterLevelLow: Int? = 1
    var nfVibrate: Int? = 1
    var bgNotification: Int? = 0
    var nfLoadExceedsPercentage:Int? = 80
    var uuid: String?
    var macId: String?
    var nfOverHeating:Int? = 1
    var nfShortCircuit:Int? = 1
    var nfWrongOutput:Int? = 1
    var nfMainsOn:Int? = 1
    var barCode: String?
    var countId:Int?
     func convertToDictionary() -> [String : Any] {
        let dict:[String:Any] = ["switchBoardDeviceId":self.switchBoardDeviceId ,"zelioName":zelioName,"switchBoardUid":switchBoardUid,"id":countId,"name":name,"modelNumber":modelNumber,"disChargingCurrent":disChargingCurrent,"chargingCurrent":chargingCurrent,"mainsVoltage":mainsVoltage,"timeRemainForCharge":timeRemainForCharge,"timeRemainForDisCharge":timeRemainForDisCharge,"batteryCharge":batteryCharge,"batteryDisCharge":batteryDisCharge,"batteryVoltage":batteryVoltage,"switchStatus":switchStatus,"mainsOkFlag":mainsOkFlag,"lowBatteryFlag":lowBatteryFlag,"overLoadLEDflag":overLoadLEDflag,"fuseBlownFlag":fuseBlownFlag,"batteryType":batteryType,"inverterUPSflag":inverterUPSflag,"holidayModeFlag":holidayModeFlag,"inverterVoltReference":inverterVoltReference,"errorCases":errorCases,"highPowerMode":highPowerMode,"chargingProfile":chargingProfile,"chargingProfileType":chargingProfileType,"ecoOrUps":ecoOrUps,"unusedString":unusedString,"zelioBatteryType":zelioBatteryType,"batteryBrand":batteryBrand,"batteryCapacity":batteryCapacity,"optimizationStartTime":optimizationStartTime,"optimizationResult":optimizationResult,"optimizationProgress":optimizationProgress,"nfLoadPercentage":nfLoadPercentage,"nfLoadExceeds":nfLoadExceeds,"nfPowerCut":nfPowerCut,"nfLowBattery":nfLowBattery,"nfZelioOverLoaded":nfZelioOverLoaded,"nfMcbTripped":nfMcbTripped,"nfWaterLevelLow":nfWaterLevelLow,"nfVibrate":nfVibrate,"bgNotification":bgNotification,"nfLoadExceedsPercentage":nfLoadExceedsPercentage,"uuid":uuid,"macId":macId,"nfOverHeating":nfOverHeating,"nfShortCircuit":nfShortCircuit,"nfWrongOutput":nfWrongOutput,"nfMainsOn":nfMainsOn,"barCode":barCode]
        return dict
    }
    
}
