//
//  PlaceDataHelper.swift
//  Zelio
//
//  Created by Reddy Roja on 12/11/18.
//  Copyright © 2018 3Frames. All rights reserved.
//
import Foundation
import SQLite
class PlaceDataHelper {
    //User
    static let userTableName = "user"
    private static let UserTable = Table(userTableName)
    private static let UserId = "id"
    private static let UserfirstName = "firstName"
    private static let UserlastName = "lastName"
    private static let UsercountryCode = "countryCode"
    private static let UservalidationCode = "validationCode"
    private static let Useruuid = "uuid"
    private static let Userpassword = "password"
    private static let Userstatus = "status"
    private static let Useremail = "email"
    private static let Userroles = "roles"
    private static let UsercreatedTime = "createdTime"
    private static let UsermodifiedTIme = "modifiedTIme"
    private static let Usertimezone = "timezone"
    private static let UsertimezoneOffset = "timezoneOffset"
    private static let Usertag = "tag"
    private static let UserparentTag = "parentTag"
    private static let UserphoneNumber = "phoneNumber"
    private static let UsersecurityAnswer = "securityAnswer"
    private static let Userotp = "otp"
    private static let flags = "flags"
    //zelio
    static let switchBoardTableName = "switchboards"
    private static let SwitchBoardDataTable = Table(switchBoardTableName)
    private static let SwitchBoardId = "id"
    private static let SwitchBoardDeviceHash = "deviceHash"
    private static let SwitchBoardIsAssociated = "isAssociated"
    private static let SwitchBoardIsFavourite = "isFavourite"
    private static let SwitchBoardDeviceId = "deviceId"
    private static let SwitchBoardName = "name"
    private static let SwitchBoardAppearance = "appearance"
    private static let SwitchBoardModelHigh = "modelHigh"
    private static let SwitchBoardModelLow = "modelLow"
    private static let SwitchBoardAuthCode = "authCode"
    private static let SwitchBoardModel = "model"
    private static let SwitchBoardPlaceId = "placeId"
    private static let SwitchBoardRefId = "refId"
    private static let SwitchBoardNumGroups = "numGroups"
    private static let SwitchBoardDatabaseId = "databaseId"
    private static let SwitchBoardUuidHigh = "uuidHigh"
    private static let SwitchBoardUuidLow = "uuidLow"
    private static let SwitchBoardDmKey = "dmKey"
    private static let SwitchBoardStrDmKey = "strDmKey"
    private static let SwitchBoardAssociated = "associated"
    private static let SwitchBoardUid = "uid"
    private static let SwitchBoardRoomUid = "roomUid"
    private static let SwitchBoardFacilityUid = "facilityUid"
    private static let SwitchBoardFloorUid = "floorUid"
    private static let SwitchBoardPlaceUid = "placeUid"
    
    //zelio table
    static let ZelioTableName = "zelio"
    private static let ZelioTableDataTable = Table(ZelioTableName)
    private static let ZelioswitchBoardDeviceId = "switchBoardDeviceId"
    private static let ZelioName = "zelioName"
    private static let ZelioswitchBoardUid = "switchBoardUid"
    private static let Zelioid = "id"
    private static let ZeliomodelNumber = "modelNumber"
    private static let ZeliodisChargingCurrent = "disChargingCurrent"
    private static let ZeliochargingCurrent = "chargingCurrent"
    private static let ZeliomainsVoltage = "mainsVoltage"
    private static let ZeliotimeRemainForCharge = "timeRemainForCharge"
    private static let ZeliotimeRemainForDisCharge = "timeRemainForDisCharge"
    private static let ZeliobatteryCharge = "batteryCharge"
    private static let ZeliobatteryDischarge = "batteryDischarge"
    private static let ZeliobatteryVoltage = "batteryVoltage"
    private static let ZelioswitchStatus = "switchStatus"
    private static let ZeliomainsOkFlag = "mainsOkFlag"
    private static let ZeliolowBatteryFlag = "lowBatteryFlag"
    private static let ZeliooverLoadLEDflag = "overLoadLEDflag"
    private static let ZeliofuseBlownFlag = "fuseBlownFlag"
    private static let ZeliobatteryType = "batteryType"
    private static let ZelioinverterUPSflag = "inverterUPSflag"
    private static let ZelioholidayModeFlag = "holidayModeFlag"
    private static let ZelioinverterVoltReference = "inverterVoltReference"
    private static let ZelioerrorCases = "errorCases"
    private static let ZeliohighPowerMode = "highPowerMode"
    private static let ZeliochargingProfile = "chargingProfile"
    private static let ZeliochargingProfileType = "chargingProfileType"
    private static let ZelioecoOrUps = "ecoOrUps"
    private static let ZeliounusedString = "unusedString"
    private static let ZeliozelioBatteryType = "zelioBatteryType"
    private static let ZeliobatteryBrand = "batteryBrand"
    private static let ZeliobatteryCapacity = "batteryCapacity"
    private static let ZelioOptStrtTime = "optimizationStartTime"
    private static let ZelioOptResult = "optimizationResult"
    private static let ZelioOptPrgress = "optimizationProgress"
    private static let ZelioNfLoadPernt = "nfLoadPercentage"
    private static let ZelioNfExceeds = "nfLoadExceeds"
    private static let ZelioNfPowercuts = "nfPowerCut"
    private static let ZelioNfLowBtry = "nfLowBattery"
    private static let ZelioNfOverLoad = "nfZelioOverLoaded"
    private static let zelionfMcbTrippped = "nfMcbTripped"
    private static let ZelioNfWaterLevel = "nfWaterLevelLow"
    private static let ZelioNfVibrate = "nfVibrate"
    private static let ZelioBgNotification = "bgNotification"
    private static let ZelioNfLaodExdPer = "nfLoadExceedsPercentage"
    private static let ZelioUuid = "uuid"
    private static let ZelioMacId = "macId"
    private static let ZelioNfOverHeating = "nfOverHeating"
    private static let ZelioNfShortCicuit = "nfShortCircuit"
    private static let ZelioNfWrongOutput = "nfWrongOutput"
    private static let ZelioMainsOn = "nfMainsOn"
    private static let ZelioBarCode = "barCode"
    private static let ZelioCountId = "zelioCounId"//store id from server to
    private static let ZelioBatteryDetailsUpdated = "isBatteryDetailsUpdated"

    
    //powerCuts
    static let powerCutsTableName = "powerCuts"
    private static let PowerCutsDataTable = Table(powerCutsTableName)
    private static let  powerCutsid = "id"
    private static let  powerCutsstatus = "status"
    private static let  powerCutsday = "day"
    private static let  numberofCuts = "numberofCuts"
    private static let  powerCutstime = "time"
    
    //notification table
    static let notificationTableName = "notifications"
    private static let NoificationsDataTable = Table(notificationTableName)
    private static let  noificationDevId = "id"
    private static let  noificationSbrdDevId = "switchBoardDeviceId"
    private static let  noificationSbrdUid = "switchBoardUid"
    private static let  noificationZname = "zelioName"
    private static let  noificationsDecp = "notification"
    private static let  noificationType = "type"
    private static let  noificationImgType = "imageType"
    
    private static let  noificationsUuid = "uuid"
    private static let  noificationUserUid = "userUid"
    private static let  noificationBckUpd = "backedUp"
    private static let  noificationsRcved = "receivedOn"
    private static let  noificationCreated = "createdOn"
    private static let  noificationCreatedTime = "createdTime"
    private static let  noificationStatus = "status"
    
    //user
    private static let userId = Expression<Int?>(UserId)
    private static let userFirstName = Expression<String?>(UserfirstName)
    private static let userLastName = Expression<String?>(UserlastName)
    private static let userCountryCode = Expression<String?>(UsercountryCode)
    private static let userValidationCode = Expression<String?>(UservalidationCode)
    private static let userUuid = Expression<String?>(Useruuid)
    private static let userPassword = Expression<String?>(Userpassword)
    private static let userStatus = Expression<Int?>(Userstatus)
    private static let userEmail = Expression<String?>(Useremail)
    private static let userRoles = Expression<String?>(Userroles)
    private static let userCreatedTime = Expression<Double?>(UsercreatedTime)
    private static let userModifiedTIme = Expression<Double?>(UsermodifiedTIme)
    private static let userTimezone = Expression<String?>(Usertimezone)
    private static let userTimezoneOffset = Expression<String?>(UsertimezoneOffset)
    private static let userTag = Expression<String?>(Usertag)
    private static let userParentTag = Expression<String?>(UserparentTag)
    private static let userPhoneNumber = Expression<String?>(UserphoneNumber)
    private static let userSecurityAnswer = Expression<String?>(UsersecurityAnswer)
    private static let userOtp = Expression<String?>(Userotp)
    private static let userFlag = Expression<Int?>(flags)
  
    //powerCuts
    private static let pId = Expression<Int?>(powerCutsid)
    private static let pstatus = Expression<Int?>(powerCutsstatus)
    private static let pday = Expression<String?>(powerCutsday)
    private static let pnumberofCuts = Expression<Int?>(numberofCuts)
    private static let ptimes = Expression<Double?>(powerCutstime)
    
    //Notification

    private static let nId = Expression<Int?>(noificationDevId)
    private static let nsbrdDevId = Expression<Int?>(noificationSbrdDevId)
    private static let nsbrdUid = Expression<String?>(noificationSbrdUid)
    private static let nZname = Expression<String?>(noificationZname)
    private static let notification = Expression<String?>(noificationsDecp)
    private static let nType = Expression<String?>(noificationType)
    private static let nImgType = Expression<String?>(noificationImgType)
    private static let nUuid = Expression<String?>(noificationsUuid)
    private static let nUserId = Expression<String?>(noificationUserUid)
    private static let nBackupd = Expression<Int?>(noificationBckUpd)
    private static let nRcved = Expression<Double?>(noificationsRcved)
    private static let nCreated = Expression<String?>(noificationCreated)
    private static let nCreatedRime = Expression<Double?>(noificationCreatedTime)
    private static let nStatus = Expression<Int?>(noificationStatus)

    //SwitchBoard
    private static let sId = Expression<Int?>(SwitchBoardId)
    private static let sdeviceHash = Expression<Int?>(SwitchBoardDeviceHash)
    private static let sisAssociated = Expression<Int?>(SwitchBoardIsAssociated)
    private static let sisFavourite = Expression<Int?>(SwitchBoardIsFavourite)
    private static let sdeviceId = Expression<Int?>(SwitchBoardDeviceId)
    private static let sname = Expression<String?>(SwitchBoardName)
    private static let sappearance = Expression<Int?>(SwitchBoardAppearance)
    private static let smodelHigh = Expression<Int?>(SwitchBoardModelHigh)
    private static let smodelLow = Expression<Int?>(SwitchBoardModelLow)
    private static let sauthCode = Expression<Int?>(SwitchBoardAuthCode)
    private static let smodel = Expression<Int?>(SwitchBoardModel)
    private static let splaceId = Expression<Int?>(SwitchBoardPlaceId)
    private static let srefId = Expression<Int?>(SwitchBoardRefId)
    private static let snumGroups = Expression<Int?>(SwitchBoardNumGroups)
    private static let sdatabaseId = Expression<Int?>(SwitchBoardDatabaseId)
    private static let suuidHigh = Expression<Double?>(SwitchBoardUuidHigh)
    private static let suuidLow = Expression<Double?>(SwitchBoardUuidLow)
    private static let sdmKey = Expression<Blob?>(SwitchBoardDmKey)
    private static let sstrDmKey = Expression<String?>(SwitchBoardStrDmKey)
    private static let sassociated = Expression<Int?>(SwitchBoardAssociated)
    private static let suid = Expression<String?>(SwitchBoardUid)
    private static let sroomUid = Expression<String?>(SwitchBoardRoomUid)
    private static let sfacilityUid = Expression<String?>(SwitchBoardFacilityUid)
    private static let sfloorUid = Expression<String?>(SwitchBoardFloorUid)
    private static let splaceUid = Expression<String?>(SwitchBoardPlaceUid)
    
    //zelio

    private static let zswitchBrdId = Expression<Int>(ZelioswitchBoardDeviceId)
    private static let zname = Expression<String?>(ZelioName)
    private static let zswitchBrdUid = Expression<String?>(ZelioswitchBoardUid)
    private static let zId = Expression<Int>(Zelioid)
    private static let zmodel = Expression<Int?>(ZeliomodelNumber)
    private static let zdischargnCrnt = Expression<Double?>(ZeliodisChargingCurrent)
    private static let zchargnCrnt = Expression<Double?>(ZeliochargingCurrent)
    private static let zMnsVoltage = Expression<Double?>(ZeliomainsVoltage)
    private static let ztmRmnForCharge = Expression<Int?>(ZeliotimeRemainForCharge)
    private static let ztmRmnFordisCharge = Expression<Int?>(ZeliotimeRemainForDisCharge)
    private static let zBtryCharge = Expression<Int?>(ZeliobatteryCharge)
    private static let zBtryDischarge = Expression<Int?>(ZeliobatteryDischarge)
    private static let zBtryVoltage = Expression<Double?>(ZeliobatteryVoltage)
    private static let zSwitchStatus = Expression<Int?>(ZelioswitchStatus)
    private static let zmainOkFlag = Expression<Int?>(ZeliomainsOkFlag)
    private static let zlowBtryFlg = Expression<Int?>(ZeliolowBatteryFlag)
    private static let zBtryoverLedFlag = Expression<Int?>(ZeliooverLoadLEDflag)
    private static let zfuseBlown = Expression<Int?>(ZeliofuseBlownFlag)
    private static let zbatteryType = Expression<Int?>(ZeliobatteryType)
    private static let zinverterUPSflg = Expression<Int?>(ZelioinverterUPSflag)
    private static let zhldMode = Expression<Int?>(ZelioholidayModeFlag)
    private static let zinverteRef = Expression<Int?>(ZelioinverterVoltReference)
    private static let zerrorCases = Expression<Int?>(ZelioerrorCases)
    private static let zhighPwrMode = Expression<Int?>(ZeliohighPowerMode)
    private static let zchargngPrfl = Expression<Int?>(ZeliochargingProfile)
    private static let zchargngPrflType = Expression<String?>(ZeliochargingProfileType)
    private static let zecoOrUps = Expression<Int?>(ZelioecoOrUps)
    private static let zunusedStrng = Expression<String?>(ZeliounusedString)
    private static let zzelioBtryType = Expression<String?>(ZeliozelioBatteryType)
    private static let zbatteryBrand = Expression<String?>(ZeliobatteryBrand)
    private static let zbatteryCpcty = Expression<String?>(ZeliobatteryCapacity)
    private static let zoptStrtTime = Expression<Double?>(ZelioOptStrtTime)
    private static let zoptResult = Expression<String?>(ZelioOptResult)
    private static let zoptProgress = Expression<Int?>(ZelioOptPrgress)
    private static let znfLoadPer = Expression<Int?>(ZelioNfLoadPernt)
    private static let znfExceds = Expression<Int?>(ZelioNfExceeds)
    private static let znfpowercuts = Expression<Int?>(ZelioNfPowercuts)
    private static let znfLowbtry = Expression<Int?>(ZelioNfLowBtry)
    private static let znfOverLoad = Expression<Int?>(ZelioNfOverLoad)
    private static let znfMcbTripped = Expression<Int?>(zelionfMcbTrippped)
    private static let znfWterLvl = Expression<Int?>(ZelioNfWaterLevel)
    private static let ZnfVibrate = Expression<Int?>(ZelioNfVibrate)
    private static let zBgNotification = Expression<Int?>(ZelioBgNotification)
    private static let znfLoadExcPer = Expression<Int?>(ZelioNfLaodExdPer)
    private static let zuuid = Expression<String?>(ZelioUuid)
    private static let zMacId = Expression<String?>(ZelioMacId)
    private static let znfOverHeat = Expression<Int?>(ZelioNfOverHeating)
    private static let znfShrtCircuit = Expression<Int?>(ZelioNfShortCicuit)
    private static let ZnfWrngOutput = Expression<Int?>(ZelioNfWrongOutput)
    private static let znfMainsOn = Expression<Int?>(ZelioMainsOn)
    private static let ZnfBarcode = Expression<String?>(ZelioBarCode)
    private static let zCountId = Expression<Int?>(ZelioCountId)
    private static let zbtryDetilsUpdated = Expression<Int?>(ZelioBatteryDetailsUpdated)
    
    static func createTableUser(_ connection: Connection) {
        do {
            try connection.run(UserTable.create(ifNotExists: true) { table in
                table.column(userId)
                table.column(userFirstName)
                table.column(userLastName)
                table.column(userCountryCode)
                table.column(userValidationCode)
                table.column(userUuid, unique: true)
                table.column(userPassword)
                table.column(userStatus)
                table.column(userEmail)
                table.column(userRoles)
                table.column(userCreatedTime)
                table.column(userModifiedTIme)
                table.column(userTimezone)
                table.column(userTimezoneOffset)
                table.column(userTag)
                table.column(userParentTag)
                table.column(userPhoneNumber)
                table.column(userSecurityAnswer)
                table.column(userOtp)
                table.column(userFlag)
                
            })
            print( "NWCache - User table created")
            
        } catch {
            print( "NWCache - DB Connection Error User \(error.localizedDescription)")
        }
    }
 

    static func createTableSwitchBoard(_ connection: Connection) {
        do {
            try connection.run(SwitchBoardDataTable.create(ifNotExists: true) { table in
                table.column(sId)
                table.column(sdeviceHash)
                table.column(sisAssociated)
                table.column(sisFavourite)
                table.column(sdeviceId)
                table.column(sname)
                table.column(sappearance)
                table.column(smodelHigh)
                table.column(smodelLow)
                table.column(sauthCode)
                table.column(smodel)
                table.column(splaceId)
                table.column(srefId)
                table.column(snumGroups)
                table.column(sdatabaseId)
                table.column(suuidHigh)
                table.column(suuidLow)
                table.column(sdmKey)
                table.column(sstrDmKey)
                table.column(sassociated)
                table.column(suid, unique: true)
                table.column(sroomUid)
                table.column(sfacilityUid)
                table.column(sfloorUid)
                table.column(splaceUid)
                
            })
            print( "NWCache - RoomData table created")
            
        } catch {
            print( "NWCache - DB Connection Error Room \(error.localizedDescription)")
        }
    }

    static func createTableZelio(_ connection: Connection) {
        do {
            try connection.run(ZelioTableDataTable.create(ifNotExists: true) { table in
                table.column(zswitchBrdId)
                table.column(zname)
                table.column(zswitchBrdUid)
                table.column(zId, primaryKey: true)
                table.column(zmodel)
                table.column(zdischargnCrnt)
                table.column(zchargnCrnt)
                table.column(zMnsVoltage)
                table.column(ztmRmnForCharge)
                table.column(ztmRmnFordisCharge)
                table.column(zBtryCharge)
                table.column(zBtryDischarge)
                table.column(zBtryVoltage)
                table.column(zSwitchStatus)
                table.column(zmainOkFlag)
                table.column(zlowBtryFlg)
                table.column(zBtryoverLedFlag)
                table.column(zfuseBlown)
                table.column(zbatteryType)
                table.column(zinverterUPSflg)
                table.column(zhldMode)
                table.column(zinverteRef)
                table.column(zerrorCases)
                table.column(zhighPwrMode)
                table.column(zchargngPrfl)
                table.column(zchargngPrflType)
                table.column(zecoOrUps)
                table.column(zunusedStrng)
                table.column(zzelioBtryType)
                table.column(zbatteryBrand)
                table.column(zbatteryCpcty)
                table.column(zoptStrtTime)
                table.column(zoptResult)
                table.column(zoptProgress)
                table.column(znfLoadPer)
                table.column(znfExceds)
                table.column(znfpowercuts)
                table.column(znfLowbtry)
                table.column(znfOverLoad)
                table.column(znfMcbTripped)
                table.column(znfWterLvl)
                table.column(ZnfVibrate)
                table.column(zBgNotification)
                table.column(znfLoadExcPer)
                table.column(zuuid)
                table.column(zMacId)
                table.column(znfOverHeat)
                table.column(znfShrtCircuit)
                table.column(ZnfWrngOutput)
                table.column(znfMainsOn)
                table.column(ZnfBarcode)
                table.column(zCountId)
                
            })
            print( "NWCache - Zelio table created")
            
        } catch {
            print( "NWCache - DB Connection Error Room \(error.localizedDescription)")
        }
    }
    
    static func createTablePowerCuts(_ connection: Connection) {
        do {
            try connection.run(PowerCutsDataTable.create(ifNotExists: true) { table in
                table.column(pId)
                table.column(pstatus)
                table.column(pday)
                table.column(pnumberofCuts)
                table.column(ptimes)
                
            })
            print( "NWCache - Power Cuts table created")
            
        } catch {
            print( "NWCache - DB Connection Error Power Cuts \(error.localizedDescription)")
        }
    }
    static func createNotificationTable(_ connection: Connection) {
        do {
            try connection.run(NoificationsDataTable.create(ifNotExists: true) { table in
       
                table.column(nId)
                table.column(nsbrdDevId)
                table.column(nsbrdUid)
                table.column(nZname)
                table.column(notification)
                table.column(nType)
                table.column(nImgType)
                table.column(nUuid, unique:true)
                table.column(nUserId)
                table.column(nBackupd)
                table.column(nRcved)
                table.column(nCreated)
                table.column(nCreatedRime)
                table.column(nStatus)
      
            })
            print( "NWCache - Notification table created")
            
        } catch {
            print( "NWCache - DB Connection Error Notification \(error.localizedDescription)")
        }
    }
    static func insertMultipleUser(_ connection: Connection, item: User) {
        do {
            let insertStmt = try connection.prepare("INSERT OR REPLACE INTO \(userTableName) (\(UserId),\(UserfirstName),\(UserlastName),\(UsercountryCode),\(UservalidationCode),\(Useruuid),\(Userpassword),\(Userstatus),\(Useremail),\(Userroles),\(UsercreatedTime),\(UsermodifiedTIme),\(Usertimezone),\(UsertimezoneOffset),\(Usertag),\(UserparentTag),\(UserphoneNumber),\(UsersecurityAnswer),\(Userotp),\(flags)) VALUES (?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?,?,?,?,?,?)")
            try connection.transaction {
                try insertStmt.run(item.id,item.firstName, item.lastName,item.countryCode,item.validationCode, item.uuid,item.password,item.status, item.email,item.roles,item.createdTime, item.modifiedTIme,item.timezone,item.timezoneOffset, item.tag,item.parentTag, item.phoneNumber,item.securityAnswer,item.otp,item.flags)
            }
            print("NWCache - multiple insert successful User")
        } catch {
            print("NWCache - mulitple Insert error User \(error.localizedDescription)")
        }
    }
    static func insertMultipleSwitchBoard(_ connection: Connection, itemsSwitchBoards: [DeviceEntity]) ->Bool {
        if (itemsSwitchBoards.count < 1) {
            return false
        }
        do {
            let insertStmt = try connection.prepare("INSERT OR REPLACE INTO \(switchBoardTableName) (\(SwitchBoardId),\(SwitchBoardDeviceHash),\(SwitchBoardIsAssociated),\(SwitchBoardIsFavourite),\(SwitchBoardDeviceId),\(SwitchBoardName),\(SwitchBoardAppearance),\(SwitchBoardModelHigh),\(SwitchBoardModelLow),\(SwitchBoardAuthCode),\(SwitchBoardModel),\(SwitchBoardPlaceId),\(SwitchBoardRefId),\(SwitchBoardNumGroups),\(SwitchBoardDatabaseId),\(SwitchBoardUuidHigh),\(SwitchBoardUuidLow),\(SwitchBoardDmKey),\(SwitchBoardStrDmKey),\(SwitchBoardAssociated),\(SwitchBoardUid),\(SwitchBoardRoomUid),\(SwitchBoardFacilityUid),\(SwitchBoardFloorUid),\(SwitchBoardPlaceUid) ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?)")
            
            try connection.transaction {
                for item in itemsSwitchBoards {
                    try insertStmt.run(item.id,item.deviceHash, item.isAssociated,item.isFavourite,item.deviceId,item.name,item.appearance,item.modelHigh,item.modelLow,item.authCode,item.model,item.placeId, item.refId,item.numGroups,item.databaseId,item.uuidHigh,item.uuidLow,item.dmKey as? Binding,item.strDmKey,item.associated,item.uid,item.roomUid,item.facilityUid,item.floorUid,item.placeUid)
                }
            }
            print("NWCache - multiple insert successful SwitchBoard")
             return true
        } catch {
            print("NWCache - mulitple Insert error SwitchBoard \(error.localizedDescription)")
             return false
        }
    }
    static func insertZelio(_ connection: Connection, itemsSwitchBoards: [Zelio]) {
        if (itemsSwitchBoards.count < 1) {
            return
        }
        do {
            let insertStmt = try connection.prepare("INSERT OR REPLACE INTO \(ZelioTableName) (\(ZelioswitchBoardDeviceId),\(ZelioName),\(ZelioswitchBoardUid),\(Zelioid),\(ZeliomodelNumber),\(ZeliodisChargingCurrent),\(ZeliochargingCurrent),\(ZeliomainsVoltage),\(ZeliotimeRemainForCharge),\(ZeliotimeRemainForDisCharge),\(ZeliobatteryCharge),\(ZeliobatteryDischarge),\(ZeliobatteryVoltage),\(ZelioswitchStatus),\(ZeliomainsOkFlag),\(ZeliolowBatteryFlag),\(ZeliooverLoadLEDflag),\(ZeliofuseBlownFlag),\(ZeliobatteryType),\(ZelioinverterUPSflag),\(ZelioholidayModeFlag),\(ZelioinverterVoltReference),\(ZelioerrorCases),\(ZeliohighPowerMode),\(ZeliochargingProfile),\(ZeliochargingProfileType),\(ZelioecoOrUps),\(ZeliounusedString),\(ZeliozelioBatteryType),\(ZeliobatteryBrand),\(ZeliobatteryCapacity),\(ZelioOptStrtTime),\(ZelioOptResult),\(ZelioOptPrgress),\(ZelioNfLoadPernt),\(ZelioNfExceeds),\(ZelioNfPowercuts),\(ZelioNfLowBtry),\(ZelioNfOverLoad),\(zelionfMcbTrippped),\(ZelioNfWaterLevel),\(ZelioNfVibrate),\(ZelioBgNotification),\(ZelioNfLaodExdPer),\(ZelioUuid),\(ZelioMacId),\(ZelioNfOverHeating),\(ZelioNfShortCicuit),\(ZelioNfWrongOutput),\(ZelioMainsOn),\(ZelioBarCode),\(ZelioCountId)) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?,?, ?, ?, ?, ?,?, ?, ?, ?, ?,?, ?, ?, ?, ?,?,?,?,?,?,?,?, ?, ?, ?, ?, ?, ?, ?, ?,?,?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?)")
            try connection.transaction {
                for item in itemsSwitchBoards {
                    try insertStmt.run(item.switchBoardDeviceId,item.zelioName,item.switchBoardUid,item.id, item.modelNumber,item.disChargingCurrent,item.chargingCurrent,item.mainsVoltage,item.timeRemainForCharge,item.timeRemainForDisCharge,item.batteryCharge,item.batteryDisCharge,item.batteryVoltage,item.switchStatus,item.mainsOkFlag,item.lowBatteryFlag,item.overLoadLEDflag,item.fuseBlownFlag,item.batteryType,item.inverterUPSflag,item.holidayModeFlag,item.inverterVoltReference,item.errorCases,item.highPowerMode,item.chargingProfile,item.chargingProfileType,item.ecoOrUps,item.unusedString,item.zelioBatteryType,item.batteryBrand,item.batteryCapacity,item.optimizationStartTime,item.optimizationResult,item.optimizationProgress,item.nfLoadPercentage,item.nfLoadExceeds,item.nfPowerCut,item.nfLowBattery,item.nfZelioOverLoaded,item.nfMcbTripped,item.nfWaterLevelLow,item.nfVibrate,item.bgNotification,item.nfLoadExceedsPercentage,item.uuid,item.macId,item.nfOverHeating,item.nfShortCircuit,item.nfWrongOutput,item.nfMainsOn,item.barCode,item.countId)
                }
            }
            print("NWCache - multiple insert successful zelio")
           
        } catch {
            print("NWCache - mulitple Insert error zelio \(error.localizedDescription)")
            
        }
    }
    //powercuts insertion
    static func insertPowercuts(_ connection:Connection,itemPowerCuts:[PowerCuts]) {
        if itemPowerCuts.count > 0 {
            return
        }
        
        do {
            let insertStmt = try connection.prepare("INSERT OR REPLACE INTO \(powerCutsTableName) (\(pId),\(pstatus),\(pday),\(pnumberofCuts),\(ptimes))  VALUES (?, ?, ?, ?, ?)")
            try connection.transaction {
                for item in itemPowerCuts {
                    try insertStmt.run(item.id,item.status, item.day,item.numberofCuts,item.time)
                }
            }
            print("NWCache - multiple insert successful Powercuts")
            return
        } catch {
            print("NWCache - mulitple Insert error Powercuts \(error.localizedDescription)")
            return
        }
    }

    static func insertNotifications(_ connection:Connection,itemNotifications:[Notifications]) {
        do {
            let insertStmt = try connection.prepare("INSERT OR REPLACE INTO \(notificationTableName) (\(noificationDevId),\(noificationSbrdDevId),\(noificationSbrdUid),\(noificationZname),\(noificationsDecp),\(noificationType),\(noificationImgType),\(noificationsUuid),\(noificationUserUid),\(noificationBckUpd),\(noificationsRcved),\(noificationCreated),\(noificationCreatedTime),\(noificationStatus)) VALUES (?, ?, ?, ?, ?, ?, ?,?,?,?, ?, ?,?,?)")
            try connection.transaction {
                 for itemNotification in itemNotifications {
                try insertStmt.run(itemNotification.id,itemNotification.switchBoardDeviceId,itemNotification.switchBoardUid,itemNotification.zelioName,itemNotification.notification,itemNotification.type,itemNotification.imageType,itemNotification.uuid,itemNotification.userUid,itemNotification.backedUp,itemNotification.receivedOn,itemNotification.createdOn,itemNotification.createdTime,itemNotification.status)
                }
            }
            print("NWCache - multiple insert successful User")
        } catch {
            print("NWCache - mulitple Insert error User \(error.localizedDescription)")
        }
    }


 
    static func fetchAllotifications(_ connection: Connection,devId:Int,switchbrdUid:String) -> [Notifications]? {
        var notifications:[Notifications] = []
        do {
            for data in try connection.prepare(PlaceDataHelper.NoificationsDataTable.filter(nsbrdDevId == devId && nsbrdUid == switchbrdUid )) {
                let object = Notifications()
                object.id = (data[nId] != nil) ? data[nId] : nil
                object.switchBoardDeviceId = (data[nsbrdDevId] != nil) ? data[nsbrdDevId] : nil
                object.switchBoardUid = (data[nsbrdUid] != nil) ? data[nsbrdUid] : nil
                object.zelioName = (data[nZname] != nil) ? data[nZname] : nil
                object.notification = (data[notification] != nil) ? data[notification] : nil
                object.type = (data[nType] != nil) ? data[nType] : nil
                object.imageType = (data[nImgType] != nil) ? data[nImgType] : nil
                object.uuid = (data[nUuid] != nil) ? data[nUuid] : nil
                object.userUid = (data[nUserId] != nil) ? data[nUserId] : nil
                object.backedUp = (data[nBackupd] != nil) ? data[nBackupd] : nil
                object.receivedOn = (data[nRcved] != nil) ? data[nRcved] : nil
                object.createdOn = (data[nCreated] != nil) ? data[nCreated] : nil
                object.createdTime = (data[nCreatedRime] != nil) ? data[nCreatedRime] : nil
                object.status = (data[nStatus] != nil) ? data[nStatus] : nil
                notifications.append(object)
            }
        } catch {
            
        }
        return notifications
    }
    
   static func fetchAssociatedDevices(_ connection: Connection) -> [DeviceEntity] {
        var associatedDevices:[DeviceEntity] = []
        do {
            for switchData in try connection.prepare(PlaceDataHelper.SwitchBoardDataTable) {
                let switchBoard = DeviceEntity()
                switchBoard.id = (switchData[sId] != nil) ? switchData[sId] : nil
                switchBoard.deviceHash = (switchData[sdeviceHash] != nil) ? switchData[sdeviceHash] : nil
                switchBoard.isAssociated = (switchData[sisAssociated] != nil) ? switchData[sisAssociated] : nil
                switchBoard.isFavourite = (switchData[sisFavourite] != nil) ? switchData[sisFavourite] : nil
                switchBoard.deviceId = (switchData[sdeviceId] != nil) ? switchData[sdeviceId] : nil
                switchBoard.name = (switchData[sname] != nil) ? switchData[sname] : nil
                switchBoard.appearance = (switchData[sappearance] != nil) ? switchData[sappearance] : nil
                switchBoard.modelHigh = (switchData[smodelHigh] != nil) ? switchData[smodelHigh] : nil
                switchBoard.modelLow = (switchData[smodelLow] != nil) ? switchData[smodelLow] : nil
                switchBoard.authCode = (switchData[sauthCode] != nil) ? switchData[sauthCode] : nil
                switchBoard.model = (switchData[smodel] != nil) ? switchData[smodel] : nil
                switchBoard.placeId = (switchData[splaceId] != nil) ? switchData[splaceId] : nil
                switchBoard.refId = (switchData[srefId] != nil) ? switchData[srefId] : nil
                switchBoard.numGroups = (switchData[snumGroups] != nil) ? switchData[snumGroups] : nil
                switchBoard.databaseId = (switchData[sdatabaseId] != nil) ? switchData[sdatabaseId] : nil
                switchBoard.uuidHigh = (switchData[suuidHigh] != nil) ? switchData[suuidHigh] : nil
                switchBoard.uuidLow = (switchData[suuidLow] != nil) ? switchData[suuidLow] : nil
                //switchBoard.dmKey = (switchData[sdmKey] != nil) ? UInt8(switchData[sdmKey]) : nil
                switchBoard.strDmKey = (switchData[sstrDmKey] != nil) ? switchData[sstrDmKey] : nil
                switchBoard.associated = (switchData[sassociated] != nil) ? switchData[sassociated] : nil
                switchBoard.uid = (switchData[suid] != nil) ? switchData[suid] : nil
                switchBoard.roomUid = (switchData[sroomUid] != nil) ? switchData[sroomUid] : nil
                switchBoard.facilityUid = (switchData[sfacilityUid] != nil) ? switchData[sfacilityUid] : nil
                switchBoard.floorUid = (switchData[sfloorUid] != nil) ? switchData[sfloorUid] : nil
                switchBoard.placeUid = (switchData[splaceUid] != nil) ? switchData[splaceUid] : nil
                associatedDevices.append(switchBoard)
    
                
            }
            } catch {
        }
        
        return associatedDevices
        
    }
 // get zelioData
    static func fetchZelioData(_ connection: Connection,deviceId:Int,switchBrdUid:String)->Zelio {
    let zelio:Zelio = Zelio()
    do {
        let query = ZelioTableDataTable.filter((zId == deviceId && zswitchBrdUid == switchBrdUid))
        for device in try connection.prepare(query) {
            
             zelio.switchBoardDeviceId  = device[zswitchBrdId]
             zelio.zelioName = device[zname] != nil ? device[zname] : nil
             zelio.switchBoardUid = device[zswitchBrdUid] != nil ? device[zswitchBrdUid] : nil
             zelio.id = device[zId]
             zelio.modelNumber = device[zmodel] != nil ? device[zmodel] : nil
             zelio.disChargingCurrent = device[zdischargnCrnt] != nil ? device[zdischargnCrnt] : nil
             zelio.chargingCurrent = device[zchargnCrnt] != nil ? device[zchargnCrnt] : nil
             zelio.mainsVoltage = device[zMnsVoltage] != nil ? device[zMnsVoltage] : nil
             zelio.timeRemainForCharge = device[ztmRmnForCharge] != nil ? device[ztmRmnForCharge] : nil
             zelio.timeRemainForDisCharge = device[ztmRmnFordisCharge] != nil ? device[ztmRmnFordisCharge] : nil
             zelio.batteryCharge = device[zBtryCharge] != nil ? device[zBtryCharge] : nil
             zelio.batteryDisCharge = device[zBtryDischarge] != nil ? device[zBtryDischarge] : nil
             zelio.batteryVoltage = device[zBtryVoltage] != nil ? device[zBtryVoltage] : nil
             zelio.switchStatus = device[zSwitchStatus] != nil ? device[zSwitchStatus] : nil
             zelio.mainsOkFlag = device[zmainOkFlag] != nil ? device[zmainOkFlag] : nil
            zelio.lowBatteryFlag = device[zlowBtryFlg] != nil ? device[zlowBtryFlg] : nil
            zelio.overLoadLEDflag = device[zBtryoverLedFlag] != nil ? device[zBtryoverLedFlag] : nil
            zelio.fuseBlownFlag = device[zfuseBlown] != nil ? device[zfuseBlown] : nil
            zelio.inverterUPSflag = device[zinverterUPSflg] != nil ? device[zinverterUPSflg] : nil
            zelio.inverterVoltReference = device[zinverteRef] != nil ? device[zinverteRef] : nil
            zelio.holidayModeFlag = device[zhldMode] != nil ? device[zhldMode] : nil
            zelio.errorCases = device[zerrorCases] != nil ? device[zerrorCases] : nil
            zelio.highPowerMode = device[zhighPwrMode] != nil ? device[zhighPwrMode] : nil
            zelio.chargingProfile = device[zchargngPrfl] != nil ? device[zchargngPrfl] : nil
            zelio.chargingProfileType = device[zchargngPrflType] != nil ? device[zchargngPrflType] : nil
            zelio.ecoOrUps = device[zecoOrUps] != nil ? device[zecoOrUps] : nil
            zelio.unusedString = device[zunusedStrng] != nil ? device[zunusedStrng] : nil
            zelio.zelioBatteryType = device[zzelioBtryType] != nil ? device[zzelioBtryType] : nil
            zelio.batteryBrand = device[zbatteryBrand] != nil ? device[zbatteryBrand] : nil
            zelio.batteryCapacity = device[zbatteryCpcty] != nil ? device[zbatteryCpcty] : nil
            zelio.optimizationResult = device[zoptResult] != nil ? device[zoptResult] : nil
            zelio.optimizationStartTime = device[zoptStrtTime] != nil ? device[zoptStrtTime] : nil
            zelio.optimizationProgress = device[zoptProgress] != nil ? device[zoptProgress] : nil
            zelio.nfLoadExceeds = device[znfExceds] != nil ? device[znfExceds] : nil
            zelio.nfLoadPercentage = device[znfLoadPer] != nil ? device[znfLoadPer] : nil
            zelio.nfPowerCut = device[znfpowercuts] != nil ? device[znfpowercuts] : nil
            zelio.nfLowBattery = device[znfLowbtry] != nil ? device[znfLowbtry] : nil
             zelio.nfZelioOverLoaded = device[znfOverLoad] != nil ? device[znfOverLoad] : nil
             zelio.nfMcbTripped = device[znfMcbTripped] != nil ? device[znfMcbTripped] : nil
             zelio.nfWaterLevelLow = device[znfWterLvl] != nil ? device[znfWterLvl] : nil
             zelio.nfVibrate = device[ZnfVibrate] != nil ? device[ZnfVibrate] : nil
             zelio.bgNotification = device[zBgNotification] != nil ? device[zBgNotification] : nil
             zelio.nfLoadExceedsPercentage = device[znfLoadExcPer] != nil ? device[znfLoadExcPer] : nil
            zelio.uuid = device[zuuid] != nil ? device[zuuid] : nil
            zelio.macId = device[zMacId] != nil ? device[zMacId] : nil
            zelio.nfMainsOn = device[znfMainsOn] != nil ? device[znfMainsOn] : nil
            zelio.barCode = device[ZnfBarcode] != nil ? device[ZnfBarcode] : nil
            zelio.countId = device[zCountId] != nil ? device[zCountId] : nil
        }
    } catch {}
    return zelio
    }
    // get zelioData
    static func fetchAllZelioData(_ connection: Connection) -> [Zelio]? {
        var zelioDevices:[Zelio] = []
        do {
            let query = ZelioTableDataTable
            for device in try connection.prepare(query) {
                let zelio:Zelio = Zelio()
                zelio.switchBoardDeviceId  = device[zswitchBrdId]
                zelio.zelioName = device[zname] != nil ? device[zname] : nil
                zelio.switchBoardUid = device[zswitchBrdUid] != nil ? device[zswitchBrdUid] : nil
                zelio.id = device[zId]
                zelio.modelNumber = device[zmodel] != nil ? device[zmodel] : nil
                zelio.disChargingCurrent = device[zdischargnCrnt] != nil ? device[zdischargnCrnt] : nil
                zelio.chargingCurrent = device[zchargnCrnt] != nil ? device[zchargnCrnt] : nil
                zelio.mainsVoltage = device[zMnsVoltage] != nil ? device[zMnsVoltage] : nil
                zelio.timeRemainForCharge = device[ztmRmnForCharge] != nil ? device[ztmRmnForCharge] : nil
                zelio.timeRemainForDisCharge = device[ztmRmnFordisCharge] != nil ? device[ztmRmnFordisCharge] : nil
                zelio.batteryCharge = device[zBtryCharge] != nil ? device[zBtryCharge] : nil
                zelio.batteryDisCharge = device[zBtryDischarge] != nil ? device[zBtryDischarge] : nil
                zelio.batteryVoltage = device[zBtryVoltage] != nil ? device[zBtryVoltage] : nil
                zelio.switchStatus = device[zSwitchStatus] != nil ? device[zSwitchStatus] : nil
                zelio.mainsOkFlag = device[zmainOkFlag] != nil ? device[zmainOkFlag] : nil
                zelio.lowBatteryFlag = device[zlowBtryFlg] != nil ? device[zlowBtryFlg] : nil
                zelio.overLoadLEDflag = device[zBtryoverLedFlag] != nil ? device[zBtryoverLedFlag] : nil
                zelio.fuseBlownFlag = device[zfuseBlown] != nil ? device[zfuseBlown] : nil
                zelio.inverterUPSflag = device[zinverterUPSflg] != nil ? device[zinverterUPSflg] : nil
                zelio.inverterVoltReference = device[zinverteRef] != nil ? device[zinverteRef] : nil
                zelio.holidayModeFlag = device[zhldMode] != nil ? device[zhldMode] : nil
                zelio.errorCases = device[zerrorCases] != nil ? device[zerrorCases] : nil
                zelio.highPowerMode = device[zhighPwrMode] != nil ? device[zhighPwrMode] : nil
                zelio.chargingProfile = device[zchargngPrfl] != nil ? device[zchargngPrfl] : nil
                zelio.chargingProfileType = device[zchargngPrflType] != nil ? device[zchargngPrflType] : nil
                zelio.ecoOrUps = device[zecoOrUps] != nil ? device[zecoOrUps] : nil
                zelio.unusedString = device[zunusedStrng] != nil ? device[zunusedStrng] : nil
                zelio.zelioBatteryType = device[zzelioBtryType] != nil ? device[zzelioBtryType] : nil
                zelio.batteryBrand = device[zbatteryBrand] != nil ? device[zbatteryBrand] : nil
                zelio.batteryCapacity = device[zbatteryCpcty] != nil ? device[zbatteryCpcty] : nil
                zelio.optimizationResult = device[zoptResult] != nil ? device[zoptResult] : nil
                zelio.optimizationProgress = device[zoptProgress] != nil ? device[zoptProgress] : nil
                zelio.optimizationStartTime = device[zoptStrtTime] != nil ? device[zoptStrtTime] : nil
                zelio.nfLoadExceeds = device[znfExceds] != nil ? device[znfExceds] : nil
                zelio.nfLoadPercentage = device[znfLoadPer] != nil ? device[znfLoadPer] : nil
                zelio.nfPowerCut = device[znfpowercuts] != nil ? device[znfpowercuts] : nil
                zelio.nfLowBattery = device[znfLowbtry] != nil ? device[znfLowbtry] : nil
                zelio.nfZelioOverLoaded = device[znfOverLoad] != nil ? device[znfOverLoad] : nil
                zelio.nfMcbTripped = device[znfMcbTripped] != nil ? device[znfMcbTripped] : nil
                zelio.nfWaterLevelLow = device[znfWterLvl] != nil ? device[znfWterLvl] : nil
                zelio.nfVibrate = device[ZnfVibrate] != nil ? device[ZnfVibrate] : nil
                zelio.bgNotification = device[zBgNotification] != nil ? device[zBgNotification] : nil
                zelio.nfLoadExceedsPercentage = device[znfLoadExcPer] != nil ? device[znfLoadExcPer] : nil
                zelio.uuid = device[zuuid] != nil ? device[zuuid] : nil
                zelio.macId = device[zMacId] != nil ? device[zMacId] : nil
                zelio.nfMainsOn = device[znfMainsOn] != nil ? device[znfMainsOn] : nil
                zelio.barCode = device[ZnfBarcode] != nil ? device[ZnfBarcode] : nil
                zelio.countId = device[zCountId] != nil ? device[zCountId] : nil
                zelioDevices.append(zelio)
            }
        } catch {}
        return zelioDevices
    }
    //fetch user
    static func fetchUser(userUid: String ,_ connection: Connection) -> User? {
        let user = User()
        do {
            for deviceData in try connection.prepare(UserTable.filter(userUid == userUuid)) {
                user.id = (deviceData[userId] != nil) ? deviceData[userId] : nil
                user.firstName = (deviceData[userFirstName] != nil) ? deviceData[userFirstName] : nil
                user.lastName = (deviceData[userLastName] != nil) ? deviceData[userLastName] : nil
                user.countryCode = (deviceData[userCountryCode] != nil) ? deviceData[userCountryCode] : nil
                user.validationCode = (deviceData[userValidationCode] != nil) ? deviceData[userValidationCode] : nil
                user.uuid = (deviceData[userUuid] != nil) ? deviceData[userUuid] : nil
                user.password = (deviceData[userPassword] != nil) ? deviceData[userPassword] : nil
                user.status = (deviceData[userStatus] != nil) ? deviceData[userStatus] : nil
                user.email = (deviceData[userEmail] != nil) ? deviceData[userEmail] : nil
                user.roles = (deviceData[userRoles] != nil) ? deviceData[userRoles] : nil
                user.createdTime = (deviceData[userCreatedTime] != nil) ? deviceData[userCreatedTime] : nil
                user.modifiedTIme = (deviceData[userModifiedTIme] != nil) ? deviceData[userModifiedTIme] : nil
                user.timezone = (deviceData[userTimezone] != nil) ? deviceData[userTimezone] : nil
                user.timezoneOffset = (deviceData[userTimezoneOffset] != nil) ? deviceData[userTimezoneOffset] : nil
                user.tag = (deviceData[userTag] != nil) ? deviceData[userTag] : nil
                user.parentTag = (deviceData[userParentTag] != nil) ? deviceData[userParentTag] : nil
                user.phoneNumber = (deviceData[userPhoneNumber] != nil) ? deviceData[userPhoneNumber] : nil
                user.securityAnswer = (deviceData[userSecurityAnswer] != nil) ? deviceData[userSecurityAnswer] : nil
                user.otp = (deviceData[userOtp] != nil) ? deviceData[userOtp] : nil
                
            }
        } catch {
            print("NWCache - fetch error User \(error.localizedDescription)")
        }
        
        return user
    }
    
    //fetch all zelio devicesList
    static func fetchAllZelioLIst(_ connection:Connection) -> [Zelio]? {
        var zelioDeviceList:[Zelio] = []
        do {
            let query = ZelioTableDataTable
            for device in try connection.prepare(query) {
                let zelio = Zelio()
                zelio.switchBoardDeviceId  = device[zswitchBrdId]
                zelio.switchBoardUid  = device[zswitchBrdUid] != nil ? device[zswitchBrdUid] : nil
                zelio.zelioName = device[zname] != nil ? device[zname] : nil
                zelio.id = device[zId]
                zelioDeviceList.append(zelio)
            }
        } catch {
        }
        return zelioDeviceList
    }
    static func fetchZelioName(_ connection:Connection,devId:Int,switchBrdUid:String)->String? {
        var name:String?
        do {
            let query = ZelioTableDataTable.filter((zId == devId && zswitchBrdUid == switchBrdUid))
            for device in try connection.prepare(query) {
                name = device[zname] != nil ? device[zname] : nil
            }
        } catch {
            
        }
        return name
    }
    //fetch powercuts data
    static func fetchAssociatedDevices(_ connection: Connection) -> [PowerCuts] {
        var powerCutsDevices:[PowerCuts] = []
        do {
            for pData in try connection.prepare(PlaceDataHelper.SwitchBoardDataTable) {
                let powerCuts = PowerCuts()
                powerCuts.id = (pData[pId] != nil) ? pData[pId] : nil
                powerCuts.status = (pData[pstatus] != nil) ? pData[pstatus] : nil
                powerCuts.day = (pData[pday] != nil) ? pData[pday] : nil
                powerCuts.numberofCuts = (pData[pnumberofCuts] != nil) ? pData[pnumberofCuts] : nil
                powerCuts.time = (pData[ptimes] != nil) ? pData[ptimes] : nil
                powerCutsDevices.append(powerCuts)
            }
        }  catch { }
        return powerCutsDevices
    }
    //update zelio name after association
    static func updateZelioName(_ connection: Connection, name:String,deviceID:Int,switchbrdUid:String) {
        do {
            let query = ZelioTableDataTable.filter((zId == deviceID && zswitchBrdUid == switchbrdUid))
            try connection.run(query.update( zname <- name,zId <- deviceID))
            print("NWCache - Update successful Zelio")
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")           
        }
    }
    //update zelio name after association
    static func updateZelioUUID(_ connection: Connection, deviceID:Int,uuid:String,switchbrdUId:String?) {
        do {
            let query = ZelioTableDataTable.filter((zId == deviceID))
            try connection.run(query.update( zId <- deviceID,zuuid <- uuid,zswitchBrdUid <- switchbrdUId))
            print("NWCache - Update successful Zelio")
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
        }
    }
    //update zelio name after association
    static func updateZelioBarcode(_ connection: Connection, deviceID:Int,uuid:String?,barCode:String?,switchbrdUid:String?) ->Bool {
        do {
            let query = ZelioTableDataTable.filter((zId == deviceID && zswitchBrdUid == switchbrdUid))
            try connection.run(query.update(zuuid <- uuid,ZnfBarcode <- barCode,zswitchBrdUid <- switchbrdUid ))
            print("NWCache - Update successful Zelio")
            return true
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
            return false
        }
    }
    //update know zeliodeevice details
    static func updateKnowZelioDetails(_ connection:Connection,data:Zelio) -> Bool {
        do {
            let query = ZelioTableDataTable.filter((zId == data.id! && zswitchBrdUid == data.switchBoardUid))
            try connection.run(query.update( zmodel <- data.modelNumber,zchargnCrnt <- data.chargingCurrent,zBtryVoltage <- data.batteryVoltage,zchargngPrfl<-data.chargingProfile,zecoOrUps<-data.ecoOrUps,zmainOkFlag <- data.mainsOkFlag,zswitchBrdId <- data.id! ))
            print("NWCache - Update successful Zelio")
            return true
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
            return false
        }
        
    }
    //update zelio battery details
    static func updateZelioBatteryData(_ connection:Connection,brand:String?,type:String?,capacity:String?,deviceId:Int,switchbrdUid:String) {
        do {
            let query = ZelioTableDataTable.filter((zId == deviceId && zswitchBrdUid == switchbrdUid))
            try connection.run(query.update( zbatteryBrand <- brand,zzelioBtryType <- type,zbatteryCpcty <- capacity))
            print("NWCache - Update successful Zelio")
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
        }
    }
    //update zelio on off status in home screen

    static func updateHomeMainsOffData(_ connection: Connection, data:Zelio) -> Bool {
        do {
            let query = ZelioTableDataTable.filter((zId == data.id! && zswitchBrdUid == data.switchBoardUid))
            try connection.run(query.update( ztmRmnFordisCharge <- data.timeRemainForDisCharge,zBtryDischarge <- data.batteryDisCharge,zdischargnCrnt <- data.disChargingCurrent,zBtryVoltage <- data.batteryVoltage,zmainOkFlag <- data.mainsOkFlag,zswitchBrdId <- data.switchBoardDeviceId!))
            print("NWCache - Update successful Zelio")
            return true
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
            return false
        }
    }
    //update zelio on off status in home screen
    static func updateHomeMainsOnData(_ connection: Connection, data:Zelio) -> Bool {
        do {
            let query = ZelioTableDataTable.filter((zId == data.id! && zswitchBrdUid == data.switchBoardUid))
            try connection.run(query.update( ztmRmnForCharge <- data.timeRemainForCharge,zBtryCharge <- data.batteryCharge,zMnsVoltage <- data.mainsVoltage,zmainOkFlag <- data.mainsOkFlag,zswitchBrdId <- data.switchBoardDeviceId!))
            print("NWCache - Update successful Zelio")
            return true
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
            return false
        }
    }
      //update zelio data in icontrol screen
    static func updateZelioIcontrolData(_ connection: Connection, data:Zelio) -> Bool {
        do {
            let query = ZelioTableDataTable.filter((zId == data.id! && zswitchBrdUid == data.switchBoardUid!))
            try connection.run(query.update( zSwitchStatus <- data.switchStatus,zhighPwrMode <- data.highPowerMode,zhldMode <- data.holidayModeFlag,zinverteRef <- data.inverterVoltReference,zmainOkFlag <- data.mainsOkFlag,zlowBtryFlg <- data.lowBatteryFlag,zBtryoverLedFlag <- data.overLoadLEDflag,zfuseBlown <- data.fuseBlownFlag))
            print("NWCache - Update successful Zelio")
            return true
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
            return false
        }
    }
    static func updateFaultsBits(_ connection:Connection, data:Zelio) {
        do {
            let query = ZelioTableDataTable.filter((zId == data.id!))
            try connection.run(query.update(zlowBtryFlg <- data.lowBatteryFlag,zBtryoverLedFlag <- data.overLoadLEDflag,zfuseBlown <- data.fuseBlownFlag))
            print("NWCache - Update successful Zelio")
            return
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
            return
        }
    }
    static func updateBatteryHealthCheck(_ connection:Connection, data:Zelio) {
        do {
            let query = ZelioTableDataTable.filter((zId == data.id! && zswitchBrdUid == data.switchBoardUid!))
            try connection.run(query.update(zoptStrtTime <- data.optimizationStartTime,zoptResult <- data.optimizationResult,zoptProgress <- data.optimizationProgress))
            print("NWCache - Update successful Zelio")
            return
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
            return
        }
    }
    static func fetchBatteryHealthCheckData(_ connection:Connection, deviceID:Int?,switchbrdUid:String?) -> Zelio? {
        let zelio = Zelio()
        do {
            let query = ZelioTableDataTable.filter((zId == deviceID! && zswitchBrdUid == switchbrdUid!))
            for device in try connection.prepare(query) {
                zelio.optimizationStartTime  = device[zoptStrtTime] != nil ? device[zoptStrtTime] : nil
                zelio.optimizationResult = device[zoptResult] != nil ? device[zoptResult] : nil
                zelio.optimizationProgress = device[zoptProgress] != nil ? device[zoptProgress] : nil
                return zelio
            }
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
        }
        return zelio
    }
    
    static func updateAppSettingsInSettings(_ connection: Connection, data:Zelio,deviceId:Int,switchbrdUid:String) {
        do {
            let query = ZelioTableDataTable.filter((zId == deviceId && zswitchBrdUid == switchbrdUid))
            try connection.run(query.update(zBgNotification <- data.bgNotification,ZnfVibrate <- data.nfVibrate,znfLoadExcPer <- data.nfLoadExceedsPercentage))
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
        }
    }
    //update notification settings
    static func updateNotificationSettingsInSettings(_ connection: Connection, data:Zelio,deviceid:Int,switchbrdUid:String) {
        do {
            let query = ZelioTableDataTable.filter((zId == deviceid && zswitchBrdUid == switchbrdUid))
            try connection.run(query.update(znfLoadPer <- data.nfLoadPercentage,znfExceds <- data.nfLoadExceeds,znfpowercuts <- data.nfPowerCut,znfLowbtry <- data.nfLowBattery,znfOverLoad <- data.nfZelioOverLoaded,znfMcbTripped <- data.nfMcbTripped,znfWterLvl <- data.nfWaterLevelLow,znfOverHeat <- data.nfOverHeating,znfShrtCircuit <- data.nfShortCircuit,ZnfWrngOutput <- data.nfWrongOutput,znfMainsOn <- data.nfMainsOn))
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
        }
    }

    static func updateNotifications(_ connection:Connection,item:Notifications?) {
        do {
            let query = NoificationsDataTable.filter((nsbrdDevId == item?.switchBoardDeviceId && nsbrdUid == item?.switchBoardUid))
            try connection.run(query.update(nId <- item?.switchBoardDeviceId,nStatus <- item?.status,nUuid <- item?.uuid,nUserId <- item?.userUid,nBackupd <- item?.backedUp,nRcved <- item?.receivedOn,nCreated <- item?.createdOn,nCreatedRime <- item?.createdTime))
            print("NWCache - Update successful notifications")
        } catch {
            print("NWCache - Update successful notifications \(error.localizedDescription)")
        }
    }
    static func updateUserName(userUid:String,name:String, _ connection:Connection) {
        do {
            let query = UserTable.filter(userUuid == userUid)
            try connection.run(query.update( userFirstName <- name))
            print("NWCache - Update successful Zelio")
        } catch {
            print("NWCache - Update error Zelio \(error.localizedDescription)")
        }
    }
    static func fectchSettingsViewData(_ connection:Connection,deviceId:Int,switchbrdUId:String) -> Zelio{
        let zelio = Zelio()
        do {
            let query = ZelioTableDataTable.filter(zId == deviceId && zswitchBrdUid == switchbrdUId)
            for zelioData in try connection.prepare(query) {
                
                zelio.nfVibrate = zelioData[ZnfVibrate] != nil ? zelioData[ZnfVibrate] : nil
                zelio.bgNotification = zelioData[zBgNotification] != nil ? zelioData[zBgNotification] : nil
                zelio.nfLoadExceeds = zelioData[znfExceds] != nil ? zelioData[znfExceds] : nil
                zelio.nfPowerCut = zelioData[znfpowercuts] != nil ? zelioData[znfpowercuts] : nil
                zelio.nfLowBattery = zelioData[znfLowbtry] != nil ? zelioData[znfLowbtry] : nil
                zelio.nfZelioOverLoaded = zelioData[znfOverLoad] != nil ? zelioData[znfOverLoad] : nil
                zelio.nfMcbTripped = zelioData[znfMcbTripped] != nil ? zelioData[znfMcbTripped] : nil
                zelio.nfWaterLevelLow = zelioData[znfWterLvl] != nil ? zelioData[znfWterLvl] : nil
                zelio.nfLoadExceedsPercentage = zelioData[znfLoadExcPer] != nil ? zelioData[znfLoadExcPer] : nil
                zelio.nfOverHeating = zelioData[znfOverHeat] != nil ? zelioData[znfOverHeat] : nil
                zelio.nfWrongOutput = zelioData[ZnfWrngOutput] != nil ? zelioData[ZnfWrngOutput] : nil
                zelio.nfShortCircuit = zelioData[znfShrtCircuit] != nil ? zelioData[znfShrtCircuit] : nil
                zelio.zelioName = zelioData[zname] != nil ? zelioData[zname] : nil
                zelio.nfMainsOn = zelioData[znfMainsOn] != nil ? zelioData[znfMainsOn] : nil
                return zelio
            }
        } catch {
            
        }
        return zelio
    }
    //delete top column
    static func deleteTopNotification(_ connection:Connection,deviceId:Int,nswitchbrdUId:String) {
        do {
            let deleteQuery = NoificationsDataTable.filter(nId == deviceId && nsbrdUid == nswitchbrdUId)
            try connection.run(deleteQuery.delete())
            
            print("NWCache - delete successful for Device")
        } catch {
            print("NWCache - delete error  Device\(error.localizedDescription)")
        }
        
    }
    // delete device
    static func deleteDevice(_ connection: Connection, deviceId: Int,switchbrdUId:String) {
        do {
            let alice = ZelioTableDataTable.filter(zswitchBrdUid == switchbrdUId)
            try connection.run(alice.delete())
            let alice1 = NoificationsDataTable.filter(nsbrdUid == switchbrdUId)
            try connection.run(alice1.delete())
            
            print("NWCache - delete successful for Device")
        } catch {
            print("NWCache - delete error  Device\(error.localizedDescription)")
        }
    }
    //deletedatabse
    static func deleteAll(_ connection: Connection) {
        do {
            try connection.run(SwitchBoardDataTable.delete())
            try connection.run(ZelioTableDataTable.delete())
            try connection.run(NoificationsDataTable.delete())
            try connection.run(PowerCutsDataTable.delete())
            try connection.run(UserTable.delete())
            
            print("NWCache - delete successful for Place")
        } catch {
            print("NWCache - delete error \(error.localizedDescription)")
        }
    }
    static func delete(_ connection: Connection) {
        do {
            try connection.run(NoificationsDataTable.delete())
            print("NWCache - delete successful for Place")
        } catch {
            print("NWCache - delete error \(error.localizedDescription)")
        }
    }
    
}
//deletedatabse


//protocol TableHelper {
//
//    associatedtype T
//
//    static func createTable(_ connection: Connection) throws
//
//    static func insert(_ connection: Connection, item: T) throws
//
//    static func insertMultiple(_ connection: Connection,switchBoard :[T]) throws
//
//    //    static func deleteAll(_ connection: Connection, uuid:T) throws
//}

