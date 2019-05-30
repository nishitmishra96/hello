//
//  BLEManager.swift
//  Zelio
//
//  Created by Reddy Roja on 09/11/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

protocol BLEManagerDelegate: class {
    func bluetoothStateDidChange(bluetoothState state: CBManagerState)
}

class BLEManager: NSObject {
    
    static let shared = BLEManager()
    var bluetoothManager: CBCentralManager!
    weak var delegate: BLEManagerDelegate?
    var isBluetoothOn: Bool!
    
    private override init() {
        super.init()
        let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
        bluetoothManager = CBCentralManager(delegate: self,
                                            queue: nil,
                                            options: opts)
        
    }
    
    func bluetoothONOFF() -> Bool {
        return isBluetoothOn
    }
    
}

extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            isBluetoothOn = true
            delegate?.bluetoothStateDidChange(bluetoothState: .poweredOn)
        case .poweredOff:
            isBluetoothOn = false
            delegate?.bluetoothStateDidChange(bluetoothState: .poweredOff)
        case .resetting:
            delegate?.bluetoothStateDidChange(bluetoothState: .resetting)
        case .unauthorized:
            isBluetoothOn = false
            delegate?.bluetoothStateDidChange(bluetoothState: .unauthorized)
        case .unsupported:
            isBluetoothOn = false
            delegate?.bluetoothStateDidChange(bluetoothState: .unsupported)
        case .unknown:
            isBluetoothOn = false
            delegate?.bluetoothStateDidChange(bluetoothState: .unknown)
        }
    }
}

