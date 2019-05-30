//
//  BluetoothManager.swift
//  Zelio
//
//  Created by Reddy Roja on 12/11/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//
import Foundation

protocol UpdatedZelioHomeDelegate {
    func updateZelioOffWithData(byteArray:[UInt8],deviceID:NSNumber)
    func updateZelioOnWithData(byteArray:[UInt8],deviceID:NSNumber)
}
protocol UpdatePowerCutsDelegate:class {
     func updatePowerCutsData(byteArray:[UInt8],deviceID:NSNumber)
}
protocol UpdateKnowZelioDelegate:class {
    func updateKnowZelioData(byteArray:[UInt8],deviceID:NSNumber)
}
protocol UpdateBetterHealthDelegate:class {
    func updateBtryHealthData(byteArray:[UInt8],deviceID:NSNumber)
}
protocol UpdateIcontrolDelegate:class {
    func updateIcontrolData(byteArray:[UInt8],deviceID:NSNumber)
}
protocol BluetoothNotificationsDelegate {
    func bridgeDidConnect()
    func bridgeDidDisconnect()
    func bluetoothDidPowerOn()
    func bluetoothDidPowerOff()
}

class BluetoothManager: NSObject {
    
    var bleNotificationDelegates = MulticastDelegate<BluetoothNotificationsDelegate>()
   
    static let shared = BluetoothManager()
    var genericQueryBytesArray = [UInt8](repeating: 0x00, count: 5)
    var isBridgeConnected = false
    @objc var isBleEnabled = false
    
    
    private override init() {
        super.init()
        genericQueryBytesArray[0] = 0xAA
        genericQueryBytesArray[1] = 0x10
        genericQueryBytesArray[4] = 0xff
    }
    @objc public static func getObj()-> BluetoothManager {
        return BluetoothManager.shared
    }
    
    func sendData(to deviceId: NSNumber, withId state: UInt8,with withByte: UInt8) {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else { return }
        let passPhrase = PassphraseUtil.generatePassphrase(position: 10, phasePraseSalt: "\(userId)", hasSalt: "\(userId)")
        CSRDevicesManager.sharedInstance().setNetworkPassPhrase(passPhrase)
        genericQueryBytesArray[1] = state
        genericQueryBytesArray[3] = withByte
        let data = NSData(bytes: genericQueryBytesArray, length: genericQueryBytesArray.count)
        print(data)
        CSRDevicesManager.sharedInstance().sendData(deviceId, data: data as Data?)
    }
//    func sendoPtStartData(to deviceId: NSNumber, withId state: UInt8,with withByte: UInt8) {
//        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else { return }
//        let passPhrase = PassphraseUtil.generatePassphrase(position: 10, phasePraseSalt: "\(userId)", hasSalt: "\(userId)")
//        CSRDevicesManager.sharedInstance().setNetworkPassPhrase(passPhrase)
//        genericQueryBytesArray[1] = state
//        genericQueryBytesArray[3] = withByte
//        let data = NSData(bytes: genericQueryBytesArray, length: genericQueryBytesArray.count)
//        print(data)
//        CSRDevicesManager.sharedInstance().sendData(deviceId, data: data as Data?)
//    }
    @objc func bridgeConected() {
        isBridgeConnected = true
        bleNotificationDelegates.invoke { (delegates) in
            delegates.bridgeDidConnect()
        }
    }
    
    @objc func bridgeDisconnected() {
        isBridgeConnected = false
        bleNotificationDelegates.invoke{ (delegates) in
            delegates.bridgeDidDisconnect()
        }
    }
    
    @objc func bluetoothConnected() {
        isBleEnabled = true
        bleNotificationDelegates.invoke { (delegates) in
            delegates.bluetoothDidPowerOn()
        }
    }
    
    @objc func bluetoothDisconnected() {
        isBleEnabled = false
        isBridgeConnected = false
        bleNotificationDelegates.invoke { (delegates) in
            delegates.bluetoothDidPowerOff()
        }
    }
    
}

