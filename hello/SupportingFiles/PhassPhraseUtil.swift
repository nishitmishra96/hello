//
//  PhassPhraseUtil.swift
//  Zelio
//
//  Created by Reddy Roja on 13/12/18.
//  Copyright © 2018 Reddy Roja. All rights reserved.

import Foundation

 class PassphraseUtil {
    
    class func encodedString() ->String {
        
        let text = "nsVjV2nxyyHKbZh7ftBVOsxv+X34Q27R9i2CannzqS+UYlFtZBVmd549BDTXjPuZtEn2dpgZGGNSs9mDX7QAgU0H7VC4G33/LHmLEmKKiLY=";
        if let base64Str = text.base64Encoded() {
            print("Base64 encoded string: \"\(base64Str)\"")
            return base64Str
        }
        return ""
    }
    class func generatePassphrase(position: Int, phasePraseSalt: String, hasSalt: String) ->String{
        
        let decryptedText = PassphraseUtil.encodedString()
        let decpText = decryptedText.prefix(position) + phasePraseSalt
        let finalTxt = decpText + decryptedText.dropFirst(position)
        let finalValtext = "\(finalTxt)"+"\(hasSalt)"
        let pasphrse = finalValtext.sha1()
        return pasphrse
        
    }
    
}
extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
