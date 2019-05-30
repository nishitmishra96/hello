//
//  CacheManager.swift
//  CrewForce
//
//  Created by Reddy Roja on 20/02/18.
//  Copyright © 2018 3Frames . All rights reserved.
//

import Foundation
import SQLite


class NWCacheStore {
    
    let version = 1.0
    
    private let fileName = "LuminousZelio.sqlite3"
    private let folderName =  "NWCache"
    
    private let applicationSupportPath = NSSearchPathForDirectoriesInDomains(
        .applicationSupportDirectory, .userDomainMask, true
        ).first!
    
    var fileAccessor:FileAccessor
    
    func storeRootPath() -> String {
        return "\(applicationSupportPath)/\(folderName)"
    }
    
    private var connection: Connection?
    
    init() {
        
        self.fileAccessor = FileAccessor(rootPath: applicationSupportPath)
        
        do {
            try fileAccessor.createDirectoryAtRelativepath(folderName)
            
            try fileAccessor.createNewFileAtPathIfNotAvailable(filename: fileName)
            
        } catch {
            print( "NWCache Store - Create Dir & File Error - \(error.localizedDescription)")
        }
        
        do {
            print("NWCache Store - try Connection")
            connection = try Connection("\(applicationSupportPath)/\(folderName)/\(fileName)")
        } catch {
            print("NWCache Store - Connection error \(error)")
        }
    }
    
    func getConnection() -> Connection? {
        self.connection?.trace{ print($0) }
        return self.connection
    }
    
}
