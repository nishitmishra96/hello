//
// Copyright 2015 Qualcomm Technologies International, Ltd.
//

//  Connect to a Mesh bridge, discover its services and characteristics then
// subcribe for notifcations on that characteristics
//
#import "CSRBluetoothLE.h"
#import <CSRmesh/MeshServiceApi.h>
#import "CSRDatabaseManager.h"
#import "CSRBridgeRoaming.h"
#import "CSRmeshSettings.h"
#import "CSRConstants.h"
#import "hello-Swift.h"


// Uncomment to enable brige roaming
#define   BRIDGE_ROAMING_ENABLE
//#define BRIDGE_DISCONNECT_ALERT

    /****************************************************************************/
    /*			Private variables and methods									*/
    /****************************************************************************/
#define CSR_STORED_PERIPHERALS  @"StoredDevices"


@interface CSRBluetoothLE () <CBCentralManagerDelegate, CBPeripheralDelegate> {
	CBCentralManager    *centralManager;
    BOOL                pendingInit;
    NSMutableSet        *connectedPeripherals;
}

    // Set of objects that request the scanner to be turned On
    // Scanner will be turned off if there are no memebers in the Set
@property (atomic)  NSMutableSet  *scannerEnablers;

@end


@implementation CSRBluetoothLE


    /****************************************************************************/
    /*			Instantiate properties using @synthesise                        */
    /****************************************************************************/
@synthesize discoveredBridges;
@synthesize bleDelegate;
@synthesize scannerEnablers;

    /****************************************************************************/
    /*								Interface Methods                           */
    /****************************************************************************/
    // First call will instantiate the one object & initialise it.
    // Subsequent calls will simply return a pointer to the object.
+ (CSRBluetoothLE*)sharedInstance
{
    static dispatch_once_t token;
    static CSRBluetoothLE *shared = nil;
    
    dispatch_once(&token, ^{
        shared = [[CSRBluetoothLE alloc] init];
    });
    
    return shared;
}

    
    //============================================================================
    // One time initialisation, called after instantiation of this singleton class
    //

- (id) init
{
    self = [super init];
    
    if (self) {
        
        pendingInit = YES;
        connectedPeripherals = [NSMutableSet set];
        [self powerOnCentralManager];
        discoveredBridges = [NSMutableArray array];
        scannerEnablers = [NSMutableSet set];
        
        [[MeshServiceApi sharedInstance] setCentralManager:centralManager];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setScannerEnabledNotification:)
                                                     name:kCSRSetScannerEnabled
                                                   object:nil];
       
	}
    return self;
}

    
    //============================================================================
    // Connect peripheral, if already connected then disconnect first.
    // This should be called when the user selects a bridge
-(void) connectPeripheral:(CBPeripheral *) peripheral {
    
//    if ([[CSRmeshSettings sharedInstance] getBleListenMode] == CSRBleListenMode_ScanNotificationListen) {
    
//    } else {
     if ([[CSRmeshSettings sharedInstance] getBleConnectMode]==CSR_BLE_CONNECTIONS_MANUAL) {
        for (CBPeripheral *connectedPeripheral in connectedPeripherals) {
            if (connectedPeripheral && connectedPeripheral.state != CBPeripheralStateConnected)
                [centralManager cancelPeripheralConnection:peripheral];
        }
        
        [connectedPeripherals removeAllObjects];

        if ([peripheral state]!=CBPeripheralStateConnected) {
            [centralManager connectPeripheral:peripheral options:nil];
        }
    }
    
}

    //============================================================================
    // Connect peripheral without checking how many are connected
-(void) connectPeripheralNoCheck:(CBPeripheral *) peripheral {
    if ([peripheral state]!=CBPeripheralStateConnected) {
        [centralManager connectPeripheral:peripheral options:nil];
    }
}



    //============================================================================
    // Disconnect the given peripheral.
-(void) disconnectPeripheral:(CBPeripheral *) peripheral {
    [centralManager cancelPeripheralConnection:peripheral];
}


    //============================================================================
    // With exception of connected peripheral, remove all discovered peripherals
-(void) removeDiscoveredPeripheralsExceptConnected {
    
    [discoveredBridges removeAllObjects];
    
    for (CBPeripheral *connectedPeripheral in connectedPeripherals) {
        if (connectedPeripheral && connectedPeripheral.state == CBPeripheralStateConnected)
            [discoveredBridges addObject:connectedPeripheral];
    }
}

    //============================================================================
    // Start Scan
-(void) startScan {
    NSLog (@"Start Scan");
    @synchronized(self) {
        if ([centralManager state] == CBManagerStatePoweredOn) {
            NSDictionary *options = [self createDiscoveryOptions];
            [centralManager scanForPeripheralsWithServices:nil options:options];
        }
    }
}


    //============================================================================
    // Stop Scan
-(void) stopScan {
    @synchronized(self) {
        [centralManager stopScan];
    }
    NSLog (@"Stop Scan");
}

- (void)powerOnCentralManager
{
    if (centralManager) {
        
        [self powerOffCentralManager];
        
    }
    
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
}

- (void)powerOffCentralManager
{
    if (centralManager) {
        
        centralManager = nil;
        
    }
    
}


//============================================================================
// Create an NSDictionary of options that we wish to apply when scanning for advertising peripherals
-(NSDictionary *) createDiscoveryOptions {
    
    NSNumber *yesOption = @YES;
    NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey : yesOption};
    return (options);
}



    /****************************************************************************/
    /*								Callbacks                                   */
    /****************************************************************************/

    //============================================================================
    // This callback when the Bluetooth Module changes State (normally power state)
    // Bluetooth Module change of state
    // Mainly used to check the Bluetooth is powered up and to alert the user if it is not.

- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    static CBManagerState previousState = -1;
    
    switch ([centralManager state]) {
        case CBManagerStatePoweredOff: {
            NSLog(@"Central Powered OFF");
            if(bleDelegate && [bleDelegate respondsToSelector:@selector(CBPowerIsOff)])
                [bleDelegate CBPowerIsOff];
            [[BluetoothManager getObj] bluetoothDisconnected];
            break;
        }
        
        case CBManagerStateUnauthorized: {
            /* Tell user the app is not allowed. */
            break;
        }
        
        case CBManagerStateUnknown: {
            /* Bad news, let's wait for another event. */
            break;
        }
        
        case CBManagerStatePoweredOn: {
            NSLog(@"Central powered ON");
            if(bleDelegate && [bleDelegate respondsToSelector:@selector(CBPoweredOn)])
                [bleDelegate CBPoweredOn];
            [[BluetoothManager getObj] bluetoothConnected];
            NSDictionary *options = [self createDiscoveryOptions];
            [centralManager scanForPeripheralsWithServices:nil options:options];
            pendingInit = NO;
            break;
        }
        
        case CBManagerStateResetting: {
            NSLog(@"Central Resetting");
            
            pendingInit = YES;
            break;
        }
        
        case CBManagerStateUnsupported:
        break;
        
    }
    
    previousState = [centralManager state];
    self.cbCentralManagerState = previousState;
}
    

    //============================================================================
    // This callback occurs on discovery of a Peripheral.
    // If the Peripheral is a Mesh Bridge then
    //  - save it
    //  - go on to discover Services and then Characteristics
    //  - Inform delegate of new discovery (for UI refresh)

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {

    [peripheral setRssi:RSSI];

    NSMutableDictionary *enhancedAdvertismentData = [NSMutableDictionary dictionaryWithDictionary:advertisementData];
    enhancedAdvertismentData [CSR_PERIPHERAL] = peripheral;
    NSNumber *messageStatus = [[MeshServiceApi sharedInstance] processMeshAdvert:enhancedAdvertismentData RSSI:RSSI];
    //NSLog(@"num1 is %@", messageStatus);

    if ([messageStatus integerValue] == IS_BRIDGE_DISCOVERED_SERVICE) {
        [peripheral setIsBridgeService:@(YES)];
    } else {
        [peripheral setIsBridgeService:@(NO)];
    }

    if ([messageStatus integerValue] == IS_BRIDGE || [messageStatus integerValue] == IS_BRIDGE_DISCOVERED_SERVICE) {
#ifdef BRIDGE_ROAMING_ENABLE
        [[CSRBridgeRoaming sharedInstance] didDiscoverBridgeDevice:central peripheral:peripheral advertisment:advertisementData RSSI:RSSI];
#endif
        
        if (![discoveredBridges containsObject:peripheral]) {
            [discoveredBridges addObject:peripheral];
        }
        [peripheral setLocalName:advertisementData[CBAdvertisementDataLocalNameKey]];
        if(bleDelegate && [bleDelegate respondsToSelector:@selector(discoveredBridge)]) {
            [bleDelegate discoveredBridge];
        }
    }
}


    //============================================================================
    // This callback occurs if the RSSI has changed
//- (void) peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
//
////    [peripheral setRssi:peripheral.RSSI];
//
//    if(bleDelegate && [bleDelegate respondsToSelector:@selector(discoveredBridge)]) {
//        [bleDelegate discoveredBridge];
//    }
//}

-(void) peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    
    [peripheral setRssi:RSSI];
    NSLog(@"RSSI returned %@", [RSSI stringValue]);
}

    //============================================================================
    // This callback occurs on a Successful connection to a Mesh bridge device
    // - remove connection to other Mesh Bridges, if these exist.
    // - go on to Discover the Mesh Service
    // - and inform delegate of new connection (for UI refresh)

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"did connect peripheral %@",peripheral.name);
    
    // if also connected to another Bridge then disconnect from that.
    
    [connectedPeripherals addObject:peripheral];
    
    peripheral.delegate=self;
    
        [peripheral discoverServices:nil];
    
    if (bleDelegate && [bleDelegate respondsToSelector:@selector(didConnectBridge:)]) {
        
        [bleDelegate didConnectBridge:peripheral];
        
    }
    
#ifdef BRIDGE_ROAMING_ENABLE
        [[CSRBridgeRoaming sharedInstance] connectedPeripheral:peripheral];
        NSLog (@"BRIDGE CONNECTED %@",peripheral.name);
    [[BluetoothManager getObj] bridgeConected];
#endif
    
    if(bleDelegate && [bleDelegate respondsToSelector:@selector(discoveredBridge)])
        [bleDelegate discoveredBridge];


}

    //============================================================================
    // This callback occurs on a Successful disconnection to a Peripheral
- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if ([connectedPeripherals containsObject:peripheral]) {
        [connectedPeripherals removeObject:peripheral];
        [[MeshServiceApi sharedInstance] disconnectBridge:peripheral];

//#ifdef  BRIDGE_DISCONNECT_ALERT
        NSLog (@"BRIDGE DISCONNECTED : %@",peripheral.name);
        [[BluetoothManager getObj] bridgeDisconnected];
        
//#endif
        
        // Call up Bridge Select View
//#ifdef BRIDGE_ROAMING_ENABLE
        [[CSRBridgeRoaming sharedInstance] disconnectedPeripheral:peripheral];
//#endif

        // Call up Bridge Select View
        if (connectedPeripherals.count==0)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BridgeDisconnectedNotification" object:nil];
    }
}

    //============================================================================
    // peripheral:discoverServices initiated this callback

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error == nil) {
        if (peripheral.state==CBPeripheralStateConnected) {
            for (CBService *service in peripheral.services) {
                [peripheral discoverCharacteristics:nil forService:service];

            }
        }
    }
}
    

    //============================================================================
    // discoverCharacteristics initiated this callback

#define MESH_MTL_CHAR_ADVERT        @"C4EDC000-9DAF-11E3-800A-00025B000B00"

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error == nil) {
        [[MeshServiceApi sharedInstance] connectBridge:peripheral enableBridgeNotification:@([[CSRmeshSettings sharedInstance] getBleListenMode])];
        // Inform BridgeRoaming that a peripheral has disconnected
        
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MESH_MTL_CHAR_ADVERT]]) {
                [self subscribeToMeshSimNotifyChar:peripheral :characteristic];
            }
        }
        
        [peripheral setIsBridgeService:@(YES)];
        if(bleDelegate && [bleDelegate respondsToSelector:@selector(didConnectBridge:)])
            [bleDelegate didConnectBridge:peripheral];
        
#ifdef BRIDGE_ROAMING_ENABLE
        [[CSRBridgeRoaming sharedInstance] connectedPeripheral:peripheral];
#endif

    }
}
    

    //============================================================================
    // set scan enabled notification from Library
-(void) setScannerEnabledNotification :(NSNotification *)notification
{
    NSNumber *enabledNumber = notification.userInfo [kCSRSetScannerEnabled];
    BOOL    enabled = [enabledNumber boolValue];
    
    [self setScanner:enabled source:[MeshServiceApi sharedInstance]];
}


    //============================================================================
    // Manage Scanner Enable/Disable control
-(void) setScanner:(BOOL)stateRequired source:(id) source {
    
    BOOL    scannerCurrentState, scannerNewState;
    scannerCurrentState = (scannerEnablers.count > 0);
    
    if (stateRequired==YES)
        [scannerEnablers addObject:source];
    else
        [scannerEnablers removeObject:source];
    
    scannerNewState = (scannerEnablers.count > 0);
    
    if (scannerCurrentState != scannerNewState){
        if (scannerNewState == YES) {
            [self startScan];
            NSLog (@"Scan ON");
        }
        else {
            [self stopScan];
            NSLog (@"Scan OFF");
        }
    }
}


    //============================================================================
    // MeshSimulator Notification Charactersitic
-(void) subscribeToMeshSimNotifyChar :(CBPeripheral *) peripheral :(CBCharacteristic *) characteristic {
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error)
        NSLog (@"Can't subscribe for notification to %@ of %@", characteristic.UUID, peripheral.name);
    else
        NSLog (@"Did subscribe for notification to %@ of %@", characteristic.UUID, peripheral.name);
    
}

    //============================================================================
    // Incoming Mesh packets can also be received as bridge notifications.
    // If so, then an advertimentData dictionary should be built with
    //     Key = CBAdvertisementDataServiceDataKey object = (dictionary with key=0xfef1 object=value)
    //     Key = CBAdvertisementDataIsConnectable object = NSNumber of the BOOL NO
    //     Key = @"didUpdateValueForCharacteristic" object = handle to the characeterisic
-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

    
    NSMutableDictionary *advertisementData = [NSMutableDictionary dictionary];
    
    [advertisementData setObject:@(NO) forKey:CBAdvertisementDataIsConnectable];
    
    advertisementData [CBAdvertisementDataIsConnectable] = @(NO);
    [advertisementData setObject:characteristic.value forKey:CSR_NotifiedValueForCharacteristic];
    [advertisementData setObject:characteristic forKey:CSR_didUpdateValueForCharacteristic];
    [advertisementData setObject:peripheral forKey:CSR_PERIPHERAL];
    
    NSNumber* num = [[MeshServiceApi sharedInstance] processMeshAdvert:advertisementData RSSI:nil];
}

@end
