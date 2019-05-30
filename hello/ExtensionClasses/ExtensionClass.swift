//
//  ExtensionClass.swift
//  Zelio
//
//  Created by Reddy Roja on 31/10/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    static func color(fromHex hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    static func toHexString(val: Int) -> String {
        let red =   CGFloat((val & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((val & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(val & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        var code = UIColor(red: red, green: green, blue: blue, alpha: alpha).toHexString()
        if(code == "#000000"){
            code = "#FFFFFF"
        }
        return code
    }
    
}

extension UIButton {
    func buttonWithShadow(radius:CGFloat,backgroundColor:UIColor,titleColor:UIColor) {
        self.layer.shadowColor = UIColor(red: 78.0/255.0, green: 97.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 6.0
//        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius = 0.0
        self.layer.cornerRadius = radius
        self.setTitleColor(titleColor, for: .normal)
    }
}
extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension UITextField {
    var validText: String? {
        return text != nil && text!.count > 0 ? text! : nil
    }
}

extension UIViewController {
    public func extendVerticalConstraint() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436, 2688, 1792:
                return true
            default:
                return false
            }
        }
        return false
    }    
    func createBoldText(for boldText:String, normalText:String) -> NSMutableAttributedString {
        if let boldFont = UIFont(name: "Rubik-Regular", size: 32), let normalFont = UIFont(name: "Rubik-Regular", size: 16) {
            let boldAttrs = [NSAttributedString.Key.font: boldFont]
            let normalAttrs = [NSAttributedString.Key.font: normalFont]
            let attributedString = NSMutableAttributedString(string:boldText, attributes:boldAttrs)
            let normalString = NSMutableAttributedString(string:normalText, attributes:normalAttrs)
            attributedString.append(normalString)
            return attributedString
        }
        return NSAttributedString(string: "") as! NSMutableAttributedString
    }
}
