//
//  ServiceUtility.swift
//  Zelio
//
//  Created by Reddy Roja on 12/11/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation

enum ModelNumber:Int {
    case modelOne = 1100
    case modelTwo = 1700
}
struct ZelioModel {
    var switchBoardDeviceId: Int?
    var id: Int?
    var modelNumber: Int?
    var disChargingCurrent: Double? = 0.0
    var chargingCurrent: Double?
    var mainsVoltage: Double?
    var timeRemainForCharge: Int?
    var timeRemainForDisCharge: Int?
    var batteryCharge: Int?
    var batteryDisCharge: Int?
    var batteryVoltage: Double? = 0.0
    var mainsOKFlag:Int?
    var ecoOrUps:Int?
     var chargingProfile: Int?
    var lowBatteryFlag:Int?
    var overLoadLEDflag: Int?
    var fuseBlownFlag: Int?
}

import Foundation
class ServiceUtility:NSObject {
    
    static let  shared = ServiceUtility()
    public static var mDeviceIdNum: NSNumber?
    public static var device: Device = Device()
    var zelioDevice:[Zelio] = []
    var delegate:UpdatedZelioHomeDelegate?
    weak var powerCutsdelegate:UpdatePowerCutsDelegate?
    weak var knowZelioDelegate:UpdateKnowZelioDelegate?
    weak var updateBtryHealthDelegate:UpdateBetterHealthDelegate?
    weak var updateIcontrolDelegate:UpdateIcontrolDelegate?
    
    
    override init() {
        super.init()
    }
    @objc public static func getObj()-> ServiceUtility {
        return ServiceUtility.shared
    }
    
    @objc func processRecievedDataFromMesh(deviceId: NSNumber, data: Data) {
         convertDataAsDB(deviceId: deviceId, data: data)
        
        //PlaceDataHelper.updateSwitchBoardDevicesStatus(with: deviceId)
    }
    @objc func generatePhaprase() ->String {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else { return "" }
        let passPhrase = PassphraseUtil.generatePassphrase(position: 10, phasePraseSalt: "\(userId)", hasSalt: "\(userId)")
        return passPhrase
    }
    public func convertDataAsDB(deviceId: NSNumber, data: Data) {
        print(data.hexEncodedString().uppercased())
        
        let byteArray = ServiceUtility.convertDataToBytes(data: data)
        ServiceUtility.mDeviceIdNum = deviceId
        
        let authID = Data(bytes: [byteArray[0]]).hexEncodedString().lowercased()
        if authID == "cc" ||  authID == "ec" {
            
            let stateID = Data(bytes: [byteArray[1]]).hexEncodedString().lowercased()
            switch stateID {
              //Home screen
            case "03":knowZelio(byteArray: byteArray, deviceId: deviceId)
            case "00":delegate?.updateZelioOffWithData(byteArray: byteArray, deviceID: deviceId)
            case "01":delegate?.updateZelioOnWithData(byteArray: byteArray, deviceID: deviceId)
                //icontrol screen
            case "02":updateZelioIcontrolStatus(byteArray: byteArray, deviceId: deviceId)
                //powercuts screen
            case "08" :updateZelioPowercutsData(byteArray: byteArray, deviceId: deviceId)
            case "09":updateZelioPowercutsData(byteArray: byteArray, deviceId: deviceId)
            case "0a":updateZelioPowercutsData(byteArray: byteArray, deviceId: deviceId)
            case "0b" :updateZelioPowercutsData(byteArray: byteArray, deviceId: deviceId)
            case "0c":updateZelioPowercutsData(byteArray: byteArray, deviceId: deviceId)
            case "0d":updateBtryHealthDelegate?.updateBtryHealthData(byteArray: byteArray, deviceID: deviceId)
            default:
                return
            }
        }
    }
    
    //Intially create a zelio table with mode number device id and mains flag
    func knowZelio(byteArray:[UInt8],deviceId: NSNumber) {
        let modelID = Data(bytes: [byteArray[6]]).hexEncodedString().lowercased()
        let modelNumber = modelID == "4d" ? ModelNumber.modelOne.rawValue : ModelNumber.modelTwo.rawValue
        let modeStatus = Helper.returnIntFromByte(byteArray: [byteArray[8]])
        let mode = modeStatus == 1 ? 1 : 0
        let authID = Data(bytes: [byteArray[0]]).hexEncodedString().lowercased()
        let zelioDevice = Zelio()
        
        zelioDevice.mainsOkFlag = authID == "cc" ? 0 :1
        zelioDevice.chargingCurrent = Double(Helper.returnIntFromByte(byteArray:[byteArray[2],byteArray[3]]))
        zelioDevice.batteryVoltage = Double(Float(Helper.returnIntFromByte(byteArray: [byteArray[4],byteArray[5]]))/100.0)
        zelioDevice.ecoOrUps = mode
        zelioDevice.modelNumber = modelNumber
        zelioDevice.id = deviceId.intValue
        zelioDevice.switchBoardDeviceId = deviceId.intValue
        
        if let switchBrdUId = UserDefaults.standard.value(forKey: "selectedSwitchBoardUid") as? String {
            zelioDevice.switchBoardUid = switchBrdUId
        }
        zelioDevice.chargingProfile = Helper.returnIntFromByte(byteArray: [byteArray[7]])
        let faultsArray = Helper.bits(fromByte:byteArray[9])
        CacheManager.shared.updateKnowZelioDetails(data: zelioDevice) { (status) in
            if BridgeStatus.sharedInstance().isScanEnabled == false {
                HelperClass.showRequiredAlertswith(flagArray:faultsArray)
            }
            self.knowZelioDelegate?.updateKnowZelioData(byteArray: byteArray, deviceID: deviceId)
        }
    }

    //update icontrolscreen
    func updateZelioIcontrolStatus(byteArray:[UInt8],deviceId: NSNumber) {
        updateIcontrolDelegate?.updateIcontrolData(byteArray: byteArray,deviceID:deviceId)
    }
    //update zelio powercutsdata
    func updateZelioPowercutsData(byteArray:[UInt8],deviceId: NSNumber) {
        powerCutsdelegate?.updatePowerCutsData(byteArray:byteArray,deviceID:deviceId)
        
    }
    
    public static func convertDataToBytes(data: Data) -> [UInt8] {
        let byteArray = data.withUnsafeBytes { [UInt8](UnsafeBufferPointer(start: $0, count: data.count)) }
        return byteArray
    }
}
extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

