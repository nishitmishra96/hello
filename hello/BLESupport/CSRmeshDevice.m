//
// Copyright 2015 Qualcomm Technologies International, Ltd.
//


#import "CSRmeshDevice.h"
#import "CSRDevicesManager.h"
#import "CSRConstants.h"
#import "CSRUtilities.h"
#import <CSRmesh/LightModelApi.h>
#import <CSRmesh/PowerModelApi.h>
#import "CSRMeshUtilities.h"
#import "CSRDeviceEntity.h"
#import "CSRDatabaseManager.h"
#import "CSRBridgeRoaming.h"
#import <CSRmesh/DataModelApi.h>
#import <CSRmeshRestClient/CSRRestDataModelApi.h>

#define TENANT_ID  @"tenantid_123"
#define SITE_ID    @"siteid_123"
#define MESH_ID    @"2"
//#define DEVICE_ID  @"12"
#define GROUP_ID   @"1"
#define NUMBER_OF_MULTI_RESP   3
#define APP_CODE @"CSRMRC"

//const unsigned byteArray[10] = {0x7e, 0x10, 0x01, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};

@interface CSRmeshDevice() <LightModelApiDelegate,DataModelApiDelegate> {

    BOOL isAssociating;
    BOOL isPendingAssociation;
    BOOL actualPower, desiredPower;
    CGFloat desiredLevel, actualLevel;
    UIColor *desiredColor, *actualColor;
   // unsigned char byteArray[10];
    NSData * streamData;
    NSNumber *meshId;
    
}

@end

@implementation CSRmeshDevice

- (id)init
{
    self = [super init];
    if (self) {
        
        [[LightModelApi sharedInstance] addDelegate:self];
        [[DataModelApi sharedInstance] addDelegate:self];
        
        return self;
    }
    return self;
}

- (id)initDatabaseDevice:(NSDictionary *)deviceProperties {
    
    _modelsSet = [NSMutableArray new];
    
    if (deviceProperties[kDEVICE_NUMBER]) {
        _deviceId = deviceProperties[kDEVICE_NUMBER];
    }
    
    if (deviceProperties[kDEVICE_HASH]) {
        _deviceHash = deviceProperties[kDEVICE_HASH];
    }
    
    if (deviceProperties[kDEVICE_AUTH_CODE]) {
        _authCode = deviceProperties[kDEVICE_AUTH_CODE];
    }
    
    if (deviceProperties[kDEVICE_ISASSOCIATED]) {
        _isAssociated = [deviceProperties[kDEVICE_ISASSOCIATED] boolValue];
    }
    
    
    //_uuid = nil;
    isAssociating = NO;
    isPendingAssociation = NO;
    //_authCode = nil;
    actualPower = YES;
    desiredPower = YES;
    desiredLevel = 1.0;
    actualLevel = 1.0;
    
    if (deviceProperties[kDEVICE_MODELS_LOW]) {
        NSData *modelNumbers = deviceProperties[kDEVICE_MODELS_LOW];
        [self createModelsWithModelNumber:modelNumbers withInfoType:@(CSR_Model_low)];
    }
    
    if (deviceProperties[kDEVICE_MODELS_HIGH]) {
        NSData *modelNumbers = deviceProperties[kDEVICE_MODELS_HIGH];
        [self createModelsWithModelNumber:modelNumbers withInfoType:@(CSR_Model_high)];
        
    }
    
    if (deviceProperties[kDEVICE_NAME]) {
        _name = deviceProperties[kDEVICE_NAME];
    }
    if (deviceProperties[kDEVICE_DHM]) {
        _dhmKey = deviceProperties[kDEVICE_DHM];
    }
    
    _colorPosition = nil;
    
    return self;
}

- (void)dealloc {
    
    [[LightModelApi sharedInstance] removeDelegate:self];
    
}

- (id) initForArea:(NSNumber *) number
{
    [self resetVars];
    
    _deviceId = number;
    _isAssociated = YES;
    
    _colorPosition = nil;
    return self;
}

-(void) resetVars
{
    _deviceId = nil;
    _name = nil;
    _isAssociated = NO;
    isAssociating = NO;
    isPendingAssociation = NO;
    _authCode = nil;
    _networkKey = nil;
    actualPower = YES;
    desiredPower = YES;
    desiredLevel = 1.0;
    actualLevel = 1.0;
    _networkKey = nil;
    _colorPosition = nil;
    _pendingRemoval = NO;
    _failedToAssociate = @(NO);
    _stateValue = nil;
    _dhmKey = nil;
}


#pragma mark - Association

-(BOOL) isAssociated
{
    return (_isAssociated);
}

-(BOOL) isAssociating
{
    return (isAssociating);
}

-(BOOL) isPendingAssociation
{
    return (isPendingAssociation);
}


-(BOOL) startAssociation
{
    if (_isAssociated)
        return (NO);
    else {
        [CSRDevicesManager sharedInstance].isDeviceTypeGateway = NO;
        [[CSRDevicesManager sharedInstance] associateDeviceFromCSRDeviceManager:_deviceHash authorisationCode:_authCode deviceID:_deviceId];
  
        isAssociating = YES;
        _associationStepsCompleted = @(0);
        _associationStepsTotal = @(7);
    }
    return (YES);
}

- (void)updateAssociationStatusWithNumberofStepsCompleted:(NSNumber *)stepsCompleted ofTotalSteps:(NSNumber *)totalSteps
{
    _associationStepsCompleted = stepsCompleted;
    _associationStepsTotal = totalSteps;
    isAssociating = YES;
    isPendingAssociation = NO;
}

-(NSString *) getAssociationStatus {
    if (_isAssociated)
        return (@"Associated");
    else if (isAssociating) {
        NSString *str;
        int stepsCompleted = [_associationStepsCompleted intValue];
        int totalSteps     = [_associationStepsTotal intValue];
        
        _failedToAssociate = @(NO);
        if (stepsCompleted == 0)
            str = [NSString stringWithFormat:@"Pending"];
        else if (stepsCompleted > totalSteps) {
            str = [NSString stringWithFormat:@"Failed"];
            _failedToAssociate = @(YES);
        }
        else {
            str = [NSString stringWithFormat:@"Associating %@/%@",_associationStepsCompleted,_associationStepsTotal];
        }
        return (str);
    }
    else if (isPendingAssociation)
        return (@"Pending");
    
    else
        return (@" ");
}


-(void) didAssociateDevice:(NSNumber *)deviceId
{
    _isAssociated = YES;
    isAssociating = NO;
    isPendingAssociation = NO;
    _deviceId = deviceId;
}

#pragma mark - Operators

- (CGFloat)getLevel
{
    return (actualLevel);
}

- (void)setLevel:(CGFloat) level
{
    @synchronized (self) {
        if (level<0)
            level=0.0;
        desiredLevel = level;
        if (actualPower == NO) {
            desiredPower = YES;
            actualPower = YES;
        }
    }
    
}
 
- (UIColor *)getColor
{
    return (actualColor);
}

- (void)setColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    @synchronized (self) {
        desiredColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        _stateValue = desiredColor;
        if (actualPower == NO) {
            desiredPower = YES;
            actualPower = YES;
        }
    }
}

- (BOOL)getPower
{
    return (actualPower);
}

- (void)setPower:(BOOL)state
{
    @synchronized (self) {
        desiredPower = state;
    }
    
}

#pragma mark - Create Models Methods

// Create models from the given bit encoded model numbers
- (void)createModelsWithModelNumber:(NSData *)modelNumbers withInfoType:(NSNumber *)infoType
{
    uint8_t modelNumber = 0;
    BOOL    found = NO;
    
    if ([infoType unsignedCharValue] == CSR_Model_low) {
        modelNumber = 0;
        found = YES;
    }
    else if ([infoType unsignedCharValue] == CSR_Model_high) {
        modelNumber = 64;
        found = YES;
    }
    
    if (found) {
        uint8_t *modelDefinitionOctets = NULL;
        modelDefinitionOctets = (uint8_t *) modelNumbers.bytes;
        
        for (int octets = 0; octets < modelNumbers.length; octets++) {
            for (int bits = 1; bits < 0x100 ;bits*=2, modelNumber++) {
                if (modelDefinitionOctets[octets] & bits) {
                    [self createModelWithModelNumber:[NSNumber numberWithUnsignedChar:modelNumber]];
                    [_modelsSet addObject:[NSNumber numberWithUnsignedChar:modelNumber]];
                    
                }
            }
        }
    }
//    NSLog(@"_modelsSet :%@", _modelsSet);
}

// Create a model from the given model number
// if database is set then skip fetching groups and also skip set name
- (void)createModelWithModelNumber:(NSNumber *)modelNumber
{
    if ([[CSRBridgeRoaming sharedInstance] numberOfConnectedBridges] > 0) {
        [[GroupModelApi sharedInstance] getNumModelGroupIds:_deviceId
                                                    modelNo:modelNumber
         //nGroups
                                                    success:^(NSNumber *deviceId, NSNumber *modelNo, NSNumber *numberOfModelGroupIds) {
                                                        
                                                        CSRDeviceEntity *deviceEntity = [[CSRDatabaseManager sharedInstance] getDeviceEntityWithId:_deviceId];
                                                        
                                                        // Find minimum
                                                        BOOL replaceNumberOfGroups = NO;
                                                        int currentNumberOfGroups = [deviceEntity.nGroups intValue];
                                                        int newNumberOfGroups = [numberOfModelGroupIds intValue];
                                                        if (currentNumberOfGroups > 0) {
                                                            if (newNumberOfGroups > 0 && newNumberOfGroups < currentNumberOfGroups)
                                                            {
                                                                replaceNumberOfGroups = YES;
                                                            }
                                                        } else {
                                                            if (newNumberOfGroups > 0) {
                                                                replaceNumberOfGroups = YES;
                                                            }
                                                        }
                                                        
                                                        if (replaceNumberOfGroups)
                                                        {
                                                            uint16_t index = [numberOfModelGroupIds unsignedShortValue];
                                                            NSMutableData *groupInstancesData = [NSMutableData dataWithLength:(index*2)];
                                                            deviceEntity.nGroups = numberOfModelGroupIds;
                                                            
                                                            deviceEntity.groups = groupInstancesData;
                                                            //                                                        NSLog(@"numberOfModelGroupIds :%@ and groupInstancesData :%@", numberOfModelGroupIds, groupInstancesData);
                                                        }
                                                        
                                                        
                                                        [[CSRDatabaseManager sharedInstance] saveContext];
                                                        
                                                        
                                                    } failure:^(NSError *error) {
                                                        //                                                    NSLog(@"Error: Group Instances");
                                                    }];
    }
    
}

#pragma mark - Reset

-(void) didResetDevice
{
    _isAssociated = NO;
    isAssociating = NO;
    isPendingAssociation = NO;
    _deviceId = nil;
    _associationStepsCompleted = nil;
    _associationStepsTotal = nil;
    _name = nil;
    [self resetVars];
}


#pragma mark - LightModelAPI Delegate methods

- (void)didGetLightState:(NSNumber *)deviceId red:(NSNumber *)red green:(NSNumber *)green blue:(NSNumber *)blue level:(NSNumber *)level powerState:(NSNumber *)powerState colorTemperature:(NSNumber *)colorTemperature supports:(NSNumber *)supports meshRequestId:(NSNumber *)meshRequestId
{

    NSMutableDictionary *objects = [NSMutableDictionary dictionary];
    if (deviceId)
        [objects setObject:deviceId forKey:@"deviceIdString"];
    if (red)
        [objects setObject:red forKey:@"redString"];
    if (green)
        [objects setObject:green forKey:@"greenString"];
    if (blue)
        [objects setObject:blue forKey:@"blueString"];
    if (level)
        [objects setObject:level forKey:@"levelString"];
    if (powerState)
        [objects setObject:powerState forKey:@"powerStateString"];
    if (colorTemperature)
        [objects setObject:colorTemperature forKey:@"colorTemperatureString"];
    if (supports)
        [objects setObject:supports forKey:@"supportsString"];
    if (meshRequestId)
        [objects setObject:meshRequestId forKey:@"meshRequestIdString"];
}


#pragma mark - Timed methods

-(BOOL) timedMethods
{
    
    if ([self timedSetColor]) {
        
        return YES;
        
    }
    
    if ([self timedSetPower]) {
        
        return YES;
        
    }
    
    return NO;
    
}


- (BOOL)timedSetColor {
    
    @synchronized (self) {
        BOOL colourIsSame=NO;
        if (desiredColor==nil || [desiredColor isEqual:actualColor])
            colourIsSame=YES;
        else
            actualColor = desiredColor;
        
        if (desiredLevel == actualLevel && colourIsSame==YES)
            return (NO);
        
        actualLevel = desiredLevel;
        desiredColor = [desiredColor colorWithAlphaComponent:actualLevel];
    }
    
    
    if (actualColor == nil) {
        actualColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        desiredColor = actualColor;
    }
    
    actualColor = [actualColor colorWithAlphaComponent:actualLevel];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[CSRDevicesManager sharedInstance] setColor:_deviceId color:actualColor duration:@0];
    
    return YES;
}


- (BOOL)timedSetPower
{
    @synchronized (self) {
        
        if (desiredPower == actualPower) {
            
            return (NO);
            
        }
        
        actualPower = desiredPower;
    }
    
    NSNumber *powerState = [NSNumber numberWithBool:desiredPower];
//    const char dataArray[] = {
//        0x7E,0x10,0x01,0x01,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
//    };
    
    /*
     byte[] data = {(byte) 0x7e, (byte) 0x10, (byte) 0xff, (byte) 0xff,
     (byte) 0xff, (byte) 0xff, (byte) 0xff, (byte) 0xff, (byte) 0xff, (byte) 0xff};
     byte id = aSwitch.identifier;
     int status = aSwitch.status;
     byte action = 0;
     if (status == 0) {
     action = 0x01;
     } else {
     action = 0x00;
     }
     data[2] = id;
     data[3] = action;
     */

    //const Byte byte[] = {(Byte) 0x7E,(Byte) 0x10,(Byte) 0x01,(Byte) 0x01,(Byte) 0xFF,(Byte) 0xFF,(Byte) 0xFF,(Byte) 0xFF,(Byte) 0xFF,(Byte) 0xFF};
   // const Byte byte[] = {(Byte) 0x7e,(Byte) 0x10,(Byte) 0x00,(Byte) 0x01,(Byte) 0xff,(Byte) 0xff,(Byte) 0xff,(Byte) 0xff,(Byte) 0xff,(Byte) 0xff};
    meshId = [NSNumber numberWithInt:2];
//    UInt8 byteArray[10] =  { 0x7E,0x10,0x01,0x01,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};
//    [streamData initWithBytes: byteArray length:sizeof(byteArray)];
//    [[CSRDevicesManager sharedInstance] sendData:_deviceId data:streamData];
    //[[CSRDevicesManager sharedInstance] didSendData:_deviceId data:data meshRequestId:meshId];

    
//   unsigned char byteArray[10] = {0x7e, 0x10, 0x01, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
//    NSData *streamData = [[NSData alloc] initWithBytes:byteArray length:sizeof(byteArray)];
//    [[CSRDevicesManager sharedInstance] sendData:_deviceId data:streamData];

//    byteArray[3] = 0x00;
//    byteArray[2] = 0x02;
    //NSData* data = [NSData dataWithBytes:byte length:sizeof(Byte[10])];
    //uint8_t byteCount = 10;
   // NSData* data = [NSData dataWithBytes:byte length:sizeof(Byte[10])];
    
    //NSArray* arr = [NSArray arrayWithObjects:, nil];
    //NSArray *array = @[@0x7e, @0x10, @0x02, @0x00, @0xff, @0xff, @0xff, @0xff, @0xff, @0xff];
    //NSArray *array = @[@(0x7e), @(0x10), @(0x02), @(0x00), @(0xff), @(0xff), @(0xff), @(0xff), @(0xff), @(0xff)];

//    Byte UUID[10];
//    for (int i = 0; i < 10; i++) {
//        UUID[i] = strtoul([array[i] UTF8String], NULL, 10);
//    }
//
//    uint8_t *bytes = malloc(sizeof(*bytes) * array.count);
//
//    unsigned i;
//    for (i = 0; i < array.count; i++)
//    {
//        int byte = [array[i] intValue];
//        bytes[i] = byte;
//    }
    
    
   // NSData *data = [NSKeyedArchiver archivedDataWithRootObject:UUID];
    //NSArray* arr = [NSArray arrayWithObjects:0x7E,0x10,0x01,0x01,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, nil];
    
    //[[CSRDevicesManager sharedInstance] setPowerState:_deviceId state:powerState];
   // [[CSRDevicesManager sharedInstance] sendData:_deviceId data:data];
  //  [[CSRDevicesManager sharedInstance] sendData:_deviceId data:data];
    
//    __block NSError *errorReceived=NULL;
//    __block NSNumber *requestIdSent=NULL;
//    __block NSNumber *requestIdResponse=NULL;
//    __block CSRRestErrorResponse *errorResp = NULL;
//    __block CSRRestDataReceivedResponse *response=NULL;
//    CSRRestDataModelApi *dataModel = [CSRRestDataModelApi sharedInstance];
//    CSRRestDataSendRequest *request = [[CSRRestDataSendRequest alloc] initWithdataOctets:array];
//
//
//    NSNumber *requestId = [dataModel sendData:TENANT_ID siteId:SITE_ID meshId:MESH_ID deviceId:_deviceId csrmeshApplicationCode:APP_CODE meshType:nil multiple:nil repeats:nil ack:[NSNumber numberWithInt:NO] dataSendRequest:request requestHandler:^(NSNumber* meshRequestId, NSError* error, CSRRestErrorResponse *errorResponse){
//        errorReceived = error;
//        errorResp = errorResponse;
//        requestIdSent = meshRequestId;
//        if(error){
//            NSLog(@"error");
//        }
//
//    }
//                              responseHandler:^(NSNumber* meshRequestId, CSRRestDataReceivedResponse* output, NSError* error, CSRRestErrorResponse *errorResponse){
//                                  // GHTestLog(@"Response is %@",output);
//                                  errorReceived = error;
//                                  requestIdResponse = meshRequestId;
//                                  response = output;
//                                  //notify for the status
//                                  // [self notify:kGHUnitWaitStatusSuccess];
//                              }];
//
    return (YES);
}

@end
