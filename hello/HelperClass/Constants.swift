//
//  Constants.swift
//  Zelio
//
//  Created by Reddy Roja on 31/10/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
struct Constants {
    static let greenPrimaryColor:String =  "#00b58c"
    static let blueColor:String = "#0067b1"
    
    static let icontrolHolidayMode:String = "Holiday mode will not allow Zelio to enter in backup mode. This will ensure full back up when you come back. Make sure you disable this mode after coming back."
    static let icontrolHighPowerMode = "This mode can be enabled for 10 minutes only once in one discharge cycle. This mode allows you to use heavy appliances such as iron, mixer etc. in case of urgency."
    static let icontrolOptimization = "This allows to choose between Maximum Backup and Maximum performance as per your choice."
    static let networkError = "Please check your internet connection"
}
struct StatusID {
    //myzelioscreen
    static let KnowZelio:UInt8 = 0x03
    static let ZelioOn:UInt8 = 0x01
    static let ZelioOff:UInt8 = 0x00
    
    //Icontrolscreeen
    static let ZelioIControl:UInt8 = 0x02
    static let ZelioSwitchOn:UInt8 = 0x14
    static let ZelioSwitchOff:UInt8 = 0x15
    static let HoldyModeOn:UInt8 = 0x16
    static let HoldyModeOff:UInt8 = 0x17
    static let HiPowerModeOn:UInt8 = 0x19
    static let HiPowerModeOff:UInt8 = 0x19
    static let PerformanceOpt:UInt8 = 0x18
    
    //power cuts screen
    static let powerCutOne:UInt8 = 0x08
    static let powerCutTwo:UInt8 = 0x09
    static let powerCutThree:UInt8 = 0x0A
    static let powerCutFour:UInt8 = 0x0B
    static let powerCutFive:UInt8 = 0x0C
    
    ///begin optimization
    static let beginOptimization:UInt8 = 0x1a
    static let readOptimization:UInt8 = 0x0D
}
struct NetworkConstants {
    
   // static let baseURL = "http://luminous.3frameslab.com:7002/api/"
    //static let baseURL = "http://52.74.173.92:7002/api/"
    static let baseURL = "https://smartglo.westindia.cloudapp.azure.com/api/"
    struct CloudIds {
        static let devices = "light/"
        static let groups = "light/group"
        static let modes = "light/scene"
        static let schedules = "light/schedule"
    }
}
struct ControllerIdentifiers {
    static let registration = "RegistrationViewController"
 //   static let mobileRegistration = "RegistrationMobileNumberEntryViewController"
    static let otpHandler = "OTPVerificationViewController"
  // static let emailConfirmation = "EmailConfirmationViewController" as
    static let setNewPassword = "SetNewPasswordViewController"
    static let resetPassword = "ForgotPasswordViewController"
    static let login = "LoginViewController"
    static let scanZelio = "ScanZelioViewController"
    static let renameZelio = "RenameZelioViewController"
    
    static let knowYourZelio = "KnowYourZelioViewController"
}
struct Error {
    
    static let shrotCircuit:String = "Your Zelio has encountered a short-circuit. We recommend that you switch off all the load on Zelio, reset the MCB and on/off switch. Try running the load one-by-one to identify the faulty load which is causing the short-circuit, then separate it from your Zelio and get it fixed. However, if the problem persists request you to contact authorized service center."
    
    static let wrongOutPut:String = "Your Zelio has encountered a fault, we recommend that you reset your Zelio by pressing on the On/Off switch. However, if the problem persists request you contact authorized service center."
    
    static let overHeating:String = "Your Zelio is overheating, Don’t worry the Zelio will automatically reset after 15 minutes. However, if the problem persists request you contact the authorized service center."
    
    static let mcbTripped:String = "Your Zelio has encountered a fault. We recommend that you reset your Zelio by pushing the MCB switch upwards. However, if the Zelio doesn’t turn on request you to contact authorized service center."
    
    static let overLoad:String = "Your Zelio is overloaded. We recommend that you reduce the load by switching of some appliances and reset the MCB and on/off switch. However, if the problem persists request you to contact authorized service center."
    
    static let loadExceed:String = "Zelio overloaded  set limit"
    
    static let powerCuts:String = "Zelio Mains Off"
    static let mainsOn:String = "Zelio Mains On"
    static let lowBattery:String = "Your Zelio encountered Low Battery"
    
}
struct NotificationImage {
    static let powercuts:String = "power_cuts"
    static let mainsOn:String = "power_cuts"
    static let mcbTripped:String = "mcb_tripped"
    static let overLoad:String = "overload"
    static let lowBattery:String = "power_cuts"
    static let shrotCircuit:String = "short_circuit"
    static let wrongOutPut = "power_cuts"
    static let overHeating:String = "overheating"
    static let loadExceed = "overload"
}
struct ErrorName {
    static let powercuts:String = "Power Cut"
    static let mainsOn:String = "Zelio Mains On"
    static let mcbTripped:String = "MCB is Tripped"
    static let overLoad:String = "Zelio Overloaded"
    static let lowBattery:String = "Low Battery"
    static let shrotCircuit:String = "Short Circuit"
    static let wrongOutPut = "Wrong Output Connection"
    static let overHeating:String = "Overheating"
    static let loadExceed:String = "Zelio Overloaded"
}
struct NotificationDecp {
    static let powercuts:String = "Zelio Mains Off"
    static let mainsOn:String = "Zelio Mains On"
    static let mcbTripped:String = "Your Zelio MCB is tripped"
    static let overLoad:String = "Your Zelio is Overloaded"
    static let lowBattery:String = "Your Zelio  Battery is Low"
    static let shrotCircuit:String = "Your Zelio encountered Short Circuit"
    static let wrongOutPut = "Your Zelio has encountered a fault"
    static let overHeating:String = "Your Zelio is OverHeating"
    static let loadExceed:String = "Your Zelio is Overloaded"
}

