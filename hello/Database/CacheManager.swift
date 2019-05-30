//
//  CacheManager.swift
//  Zelio
//
//  Created by Reddy Roja on 12/11/18.
//  Copyright © 2018 3Frames . All rights reserved.
//
import Foundation
import SQLite

class CacheManager {
    
    // MARK: - Properties
    
    static let shared = CacheManager()
    
    private var connection: Connection?
    private var cacheStore:NWCacheStore
    let cacheDispatchQueue = DispatchQueue(label: "com.Zelio.cacheManager", qos: .background)
    
    // MARK: - Init
    
    private init () {
        self.cacheStore = NWCacheStore()
        self.connection = self.cacheStore.getConnection()
    }
    
    func setupDB() {
        guard let db = self.connection else { return }
        print("Setup Database and tables for CacheManager")
        //create tables
        cacheDispatchQueue.async {
            PlaceDataHelper.createTableUser(db)
            PlaceDataHelper.createTableSwitchBoard(db)
            PlaceDataHelper.createTableZelio(db)
            PlaceDataHelper.createTablePowerCuts(db)
            PlaceDataHelper.createNotificationTable(db)
           
        }
    }
    func recordUnits(_ units:[DeviceEntity]?, completion: @escaping (Bool) -> Void ) {
        guard let db = self.connection else { return completion(false) }
        cacheDispatchQueue.async {
            if let switchboards = units {
               completion(PlaceDataHelper.insertMultipleSwitchBoard(db, itemsSwitchBoards: switchboards))
                
            }
        }
    }
    func recordZelioUnits(_ units:[Zelio]?, completion: @escaping () -> Void ) {
        guard let db = self.connection else { return completion() }
        cacheDispatchQueue.async {
            if let zelio = units {
                PlaceDataHelper.insertZelio(db, itemsSwitchBoards: zelio)
            }
        }
    }
    func insertUser(_ units:User?, completion: @escaping () -> Void ) {
        guard let db = self.connection else { return completion() }
        cacheDispatchQueue.async {
            if let unit = units {
                PlaceDataHelper.insertMultipleUser(db, item: unit)
            }
            completion()
        }
    }
    func retrieveUser(userUid: String ,completion: @escaping (User?) -> Void) {
        guard let db = self.connection else { return completion(nil) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.fetchUser(userUid: userUid, db))
        }
    }
    func updateUserName(userUid: String ,name:String,completion: @escaping () -> Void) {
        guard let db = self.connection else { return }
        cacheDispatchQueue.async {
            PlaceDataHelper.updateUserName(userUid: userUid, name: name, db)
        }
    }
    // record all notifications
    func inserNotifications(notification:[Notifications]?,completion: @escaping () -> Void) {
        guard let db = self.connection else { return completion() }
        cacheDispatchQueue.async {
            if let object = notification {
                PlaceDataHelper.insertNotifications(db, itemNotifications: object)
            }
        }
    }
    func fectchNotifications(devId:Int,switchbrdUid:String,completion: @escaping ([Notifications]?) -> Void) {
        guard let db = self.connection else { return completion(nil) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.fetchAllotifications(db, devId: devId, switchbrdUid: switchbrdUid))
        }
    }

//fetch the deviceEntityList
func fetchDeviceEntityList(completion: @escaping ([DeviceEntity]?) -> Void) {
    guard let db = self.connection else { return completion(nil) }
    cacheDispatchQueue.async {
        completion(PlaceDataHelper.fetchAssociatedDevices(db))
    }
 }
    func fetchZelioList(deviceId:Int,switchbrdUId:String,completion: @escaping (Zelio?) -> Void) {
        guard let db = self.connection else { return completion(nil) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.fetchZelioData(db,deviceId:deviceId, switchBrdUid: switchbrdUId))
        }
    }
    //fetch all zelio list
    func fetchAllZelioDeviecs(completion: @escaping ([Zelio]?) -> Void) {
        guard let db = self.connection else { return completion(nil) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.fetchAllZelioLIst(db))
        }
    }
    func fetchAllZelioDeviceList(completion: @escaping ([Zelio]?) -> Void) {
        guard let db = self.connection else { return completion(nil) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.fetchAllZelioData(db))
        }
    }
    //fetch settins data from zelio
    func fetchNotificationSettingsData(deviceId:Int,switchbrdUid:String,completion: @escaping (Zelio?) -> Void) {
        guard let db = self.connection else {  return completion(nil) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.fectchSettingsViewData(db,deviceId: deviceId, switchbrdUId: switchbrdUid))
        }
    }
    func fetchZelioName(deviceId:Int,switchbrdUid:String,completion: @escaping (String?) -> Void) {
        guard let db = self.connection else {  return completion(nil) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.fetchZelioName(db, devId: deviceId, switchBrdUid: switchbrdUid))
        }
    }
    // updateSettings data
    func updateNotificationSettings(data:Zelio,deviceID:Int,switchbrdUid:String,completion: @escaping () -> Void) {
        guard let db = self.connection else {  return completion() }
          cacheDispatchQueue.async {
            PlaceDataHelper.updateNotificationSettingsInSettings(db, data: data, deviceid: deviceID, switchbrdUid: switchbrdUid)
        }
    }
    func updateAppSettings(data:Zelio,deviceID:Int,switchbrdUid:String,completion: @escaping () -> Void) {
        guard let db = self.connection else {  return completion() }
          cacheDispatchQueue.async {
            PlaceDataHelper.updateAppSettingsInSettings(db, data: data, deviceId: deviceID, switchbrdUid: switchbrdUid)
        }
    }
    //update notifications
    func updateNotifications(notification:Notifications?,completion: @escaping () -> Void) {
        guard let db = self.connection else {  return completion() }
        cacheDispatchQueue.async {
            PlaceDataHelper.updateNotifications(db, item: notification)
        }
    }
    //fetch battery health check
    func fetchBatteryHealthCheckData(devId:Int?,switchberdUid:String?,completion: @escaping (Zelio?) -> Void)  {
        guard let db = self.connection else {  return completion(nil) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.fetchBatteryHealthCheckData(db,deviceID:devId, switchbrdUid: switchberdUid))
        }
    }
    //update battery health check
    func updateZelioBatteryHealthCheck(object:Zelio?,completion: @escaping () -> Void) {
        if let device = object {
            guard let db = self.connection else {  return completion() }
            cacheDispatchQueue.async {
                PlaceDataHelper.updateBatteryHealthCheck(db, data: device)
            }
        }
    }
    //update knowzelio deviceDetails
    func updateKnowZelioDetails(data:Zelio,completion: @escaping (Bool) -> Void) {
        guard let db = self.connection else { return completion(false) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.updateKnowZelioDetails(db,data: data))
        }
    }
    //update zelio name
    func updateZeioName(name:String,deviceId:Int,switchbrdUid:String,completion: @escaping () -> Void) {
        guard let db = self.connection else { return completion() }
        cacheDispatchQueue.async {
            PlaceDataHelper.updateZelioName(db, name: name, deviceID: deviceId, switchbrdUid: switchbrdUid)
            
        }
    }
    func updateZelioUUID(deviceID:Int,uuid:String,switchbrdUId:String?,completion: @escaping () -> Void) {
        guard let db = self.connection else { return completion() }
        cacheDispatchQueue.async {
            PlaceDataHelper.updateZelioUUID(db, deviceID: deviceID, uuid: uuid,switchbrdUId:switchbrdUId)
        }
    }
    //update zelio barcode
    func updateZelioBarCode(deviceID:Int,uuid:String?,barCode:String?,switchbrdUid:String?,completion: @escaping (Bool) -> Void)  {
        guard let db = self.connection else { return completion(false) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.updateZelioBarcode(db, deviceID: deviceID, uuid: uuid,barCode:barCode, switchbrdUid: switchbrdUid))
        }
    }
    //update zelio battery details
    func updateZelioBatteryDetails(brand:String?,type:String?,capacity:String?,deviceId:Int,switchbrdUid:String,completion: @escaping () -> Void) {
        guard let db = self.connection else { return completion() }
        cacheDispatchQueue.async {
            PlaceDataHelper.updateZelioBatteryData(db, brand: brand, type: type, capacity: capacity, deviceId: deviceId, switchbrdUid: switchbrdUid)
            
        }
    }
    func updateZelioMainOnStatus(_ units:Zelio, completion: @escaping (Bool) -> Void) {
        guard let db = self.connection else { return completion(false) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.updateHomeMainsOnData(db,data: units))
        }
    }
    func updateZelioMainOffStatus(_ units:Zelio,completion: @escaping (Bool) -> Void) {
        guard let db = self.connection else { return completion(false) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.updateHomeMainsOffData(db, data: units))
        }
    }
    //update faults status
    func updateZelioFaultsStatus(_ units:Zelio,completion: @escaping () -> Void) {
        guard let db = self.connection else { return completion() }
        cacheDispatchQueue.async {
          PlaceDataHelper.updateFaultsBits(db, data: units)
        }
    }
    func updateZelioIControlData(_ units:Zelio,completion: @escaping (Bool) -> Void) {
        guard let db = self.connection else { return completion(false) }
        cacheDispatchQueue.async {
            completion(PlaceDataHelper.updateZelioIcontrolData(db, data: units))
        }
    }
    // delete a notification in table
    
    // delete a device in table
    func deleteDevice(deviceId: Int,switchbrdUid:String, completion: @escaping() -> Void) {
        guard let db = self.connection else { return completion() }
        cacheDispatchQueue.async {
            PlaceDataHelper.deleteDevice(db, deviceId: deviceId, switchbrdUId: switchbrdUid)
            completion()
        }
    }
    //delete all tables
    // MARK: - Delete Tables
    func deleteAll(completion: @escaping () -> Void) {
        guard let db = self.connection else { return completion() }
        cacheDispatchQueue.async {
            PlaceDataHelper.deleteAll(db)
            completion()
        }
    }
}
//updateZelioForOndata


