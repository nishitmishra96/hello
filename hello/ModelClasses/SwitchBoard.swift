//
//  SwitchBoard.swift
//  LuminousSmartSwitch
//
//  Created by ramakrishna on 13/04/18.
//  Copyright © 2018 3Frames. All rights reserved.
//

import UIKit
import EVReflection

class Switchboards: EVObject {
    
    var appearance: Int?
    var authCode: Int?
    var deviceId: Int?
    var deviceHash: Int?
    var favourite: Int?
    var groups:Data?
    var isAssociated: Int?
    var modelHigh: Int?
    var modelLow: Int?
    var name: String?
    var nGroups: Int?
    var uuid: String?
    var areas:NSSet?
    var dhmKey:NSData?

}
