//
//  BridgeStatus.swift
//  Zelio
//
//  Created by Reddy Roja on 04/12/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
class BridgeStatus:NSObject {
    
    var isBridgeConnected = false
    var isScanEnabled = false
    var isNotInMyZelio = true
    static let shared = BridgeStatus()
    
    @objc public static func sharedInstance()-> BridgeStatus {
        return BridgeStatus.shared
    }
}
class SharedClass:NSObject {
    var isUploading = false
    static let shared = SharedClass()
    @objc public static func sharedInstance() -> SharedClass {
        return SharedClass.shared
    }
    
}
