//
//  ProgressView.swift
//  Zelio
//
//  Created by Reddy Roja on 31/10/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
import SVProgressHUD
class ProgressView {
    static func showActivityLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.setFadeInAnimationDuration(0.0)
            SVProgressHUD.setFadeOutAnimationDuration(0.0)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
            SVProgressHUD.show()
        }
    }
    static func dismissActivityLoader() {
        DispatchQueue.main.async {
            
            SVProgressHUD.dismiss()
        }
    }
    static func showActivityLoader(withStatus status:String?) {
        DispatchQueue.main.async {
            SVProgressHUD.setFadeInAnimationDuration(0.0)
            SVProgressHUD.setFadeOutAnimationDuration(0.0)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
            SVProgressHUD.show(withStatus: status)
            
        }
    }
    static func showActivityLoader(withError error:String?) {
        DispatchQueue.main.async {
            SVProgressHUD.setFadeInAnimationDuration(0.0)
            SVProgressHUD.setFadeOutAnimationDuration(0.0)
            SVProgressHUD.showError(withStatus:error)
        }
    }
    static func dismissActivityLoader(withDelay delay:TimeInterval) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss(withDelay: delay)
        }
    }
    
}
class Helper {
    static func displayToastMessage(_ message : String) {
        
        let toastView = UILabel()
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastView.textColor = UIColor.white
        toastView.textAlignment = .center
        toastView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        toastView.layer.cornerRadius = 5
        toastView.layer.masksToBounds = true
        toastView.text = message
        toastView.numberOfLines = 0
        toastView.alpha = 0
        toastView.translatesAutoresizingMaskIntoConstraints = false
        
        let window = UIApplication.shared.delegate?.window!
        window?.addSubview(toastView)
        let horizontalCenterContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
        
        let widthContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 275)
        
        let verticalContraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=200)-[loginView(==50)]-68-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["loginView": toastView])
        
        NSLayoutConstraint.activate([horizontalCenterContraint, widthContraint])
        NSLayoutConstraint.activate(verticalContraint)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 1
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                toastView.alpha = 0
            }, completion: { finished in
                toastView.removeFromSuperview()
            })
        })
    }
    // get current time
    // get diffrence between two times
    static func getTimeDiff(time:Double?)->Int? {
        
        
        if time != nil {
            let time1Str = self.getStringFromDate(date: Date())
            let time2Str = self.getDateFromMills(date: time!)
            let timeformatter = DateFormatter()
            timeformatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
            
            let time1 = timeformatter.date(from: time1Str)
            let time2 = timeformatter.date(from: time2Str)
            let seconds = time1!.seconds(from: time2!)
            return seconds
        }
        
        return 0
    }
    static func getDateFromMills(date:Double)->String {
        let milisecond = date
        let dateVar = Date(timeIntervalSince1970: (milisecond / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        return dateFormatter.string(from: dateVar)
    }
    static func getStringFromDate(date:Date) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        let currentDate = Date()
        return dateFormatter.string(from:currentDate)
    }
    // return Int value from bytes
    static func returnIntFromByte(byteArray:[UInt8])->Int {
        let data = Data(bytes: byteArray).hexEncodedString()
        if let num = Int(data, radix: 16) {
            return num
        }
        return 0
    }
    static func bits(fromByte byte: UInt8) -> [Bit] {
        var byte = byte
        var bits = [Bit](repeating: .zero, count: 8)
        for i in 0..<8 {
            let currentBit = byte & 0x01
            if currentBit != 0 {
                bits[i] = .one
            }
            
            byte >>= 1
        }
        
        return bits
    }
    
}

enum Bit: UInt8, CustomStringConvertible {
    case zero, one
    
    var description: String {
        switch self {
        case .one:
            return "1"
        case .zero:
            return "0"
        }
    }
}
extension Date {
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
