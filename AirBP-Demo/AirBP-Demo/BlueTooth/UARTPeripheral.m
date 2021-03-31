//
//  UARTPeripheral.m
//  nRF UART
//
//  Created by Ole Morten on 1/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import "UARTPeripheral.h"
#import "AppDelegate.h"

@interface UARTPeripheral ()
@property (nonatomic,retain) CBService *uartService;////uartService
@property (nonatomic,retain) CBCharacteristic *rxCharacteristic;//Write


@property (nonatomic,retain) CBService *devService;//devService
@property (nonatomic,retain) CBCharacteristic *devRxCharacteristic;//dev write RxCharacteristic
@property (nonatomic,retain) CBCharacteristic *devTxCharacteristic;////dev read RxCharacteristic

@end


@implementation UARTPeripheral

@synthesize peripheral = _peripheral;
@synthesize delegate = _delegate;

@synthesize uartService = _uartService;
@synthesize rxCharacteristic = _rxCharacteristic;
@synthesize txCharacteristic = _txCharacteristic;
@synthesize devService = _devService;
@synthesize devRxCharacteristic = _devRxCharacteristic;
@synthesize devTxCharacteristic = _devTxCharacteristic;

+ (CBUUID *) uartServiceUUID
{
    return [CBUUID UUIDWithString:@"569a1101-b87f-490c-92cb-11ba5ea5167c"];
}

+ (CBUUID *) devServiceUUID
{
    return [CBUUID UUIDWithString:@"14839ac4-7d7e-415c-9a42-167340cf2339"];
}

+ (CBUUID *) txCharacteristicUUID   //data going to the module
{
    return [CBUUID UUIDWithString:@"569a2001-b87f-490c-92cb-11ba5ea5167c"];
}

+ (CBUUID *) devTxCharacteristicUUID   //data going to the module
{
    return [CBUUID UUIDWithString:@"8B00ACE7-EB0B-49B0-BBE9-9AEE0A26E1A3"];
}

+ (CBUUID *) rxCharacteristicUUID  //data coming from the module
{
    return [CBUUID UUIDWithString:@"569a2000-b87f-490c-92cb-11ba5ea5167c"];
}

+ (CBUUID *) devRxCharacteristicUUID  //data coming from the module
{
    return [CBUUID UUIDWithString:@"0734594A-A8E7-4B1A-A6B1-CD5243059A57"];
}

+ (CBUUID *) deviceInformationServiceUUID
{
    return [CBUUID UUIDWithString:@"180A"];
}

+ (CBUUID *) hardwareRevisionStringUUID
{
    return [CBUUID UUIDWithString:@"2A27"];
}


#define kUUID       [CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"]
#define kCharaWUUID [CBUUID UUIDWithString:@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"]
#define kCharaNUUID [CBUUID UUIDWithString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"]

- (UARTPeripheral *) initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<UARTPeripheralDelegate>) delegate
{
    if (self = [super init])
    {
        self.peripheral = peripheral;
        _peripheral.delegate = self;//Become an agent
        self.delegate = delegate;//Set up proxy
    }
    return self;
}
//When the peripheral is connected to CBCentralPeripheral, the discoverServices method should be executed immediately to understand what kind of services are provided by the surroundings.
//Will also trigger the didDiscoverServices proxy method
- (void) didConnect
{
    [LXUserDefaults setBool:YES forKey:@"isConnect"];
    [VTSingletonClass sharedSingletonClass].isOffline = NO;
     [_peripheral discoverServices:@[self.class.uartServiceUUID, self.class.deviceInformationServiceUUID, self.class.devServiceUUID,kUUID]];
}

//did Disconnect
- (void) didDisconnect
{
    [VTSingletonClass sharedSingletonClass].isOffline = YES;  //Method.property
    [LXUserDefaults setBool:NO forKey:@"isConnect"];
   
}

//Write
- (void)writeString:(NSString *) string
{
    NSString *string1 = [NSString stringWithString:string];
    
    string1 = [string1 stringByAppendingString:@"\r"];
        
    NSData *data = [NSData dataWithBytes:string1.UTF8String length:string1.length];
    
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma warning Data writing...
- (void) writeRawData:(NSData *) data
{
    /**
     *  CBPeripheralStateDisconnected = 0,  Not connected (disconnected)
        CBPeripheralStateConnecting,    connection
        CBPeripheralStateConnected,     Connection Status
        CBPeripheralStateDisconnecting   Disconnected state
     */
    if (self.peripheral.state == CBPeripheralStateConnected) {//Connection Status
        
        //Write characteristic value
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
}
//======================================================*****

#pragma CBPeripheral delegate
//***************************** Connection part  ********************************************
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        return;
    }
    if ([peripheral services].count <= 0) {
        [LXUserDefaults setValue:peripheral.name forKey:MY_BP_ORIGINAL_NAME];
        DLog(@"Upgrade debugging：%@", peripheral.name);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotUpdateCompleted" object:nil];
    }
    else
    {
        for (CBService *s in [peripheral services])
        {
            if ([s.UUID isEqual:kUUID]) {
                [self.peripheral discoverCharacteristics:@[kCharaNUUID,kCharaWUUID] forService:s];
            }
            
            if ([s.UUID isEqual:self.class.uartServiceUUID])
            {
                self.uartService = s;
                
                [self.peripheral discoverCharacteristics:@[self.class.txCharacteristicUUID, self.class.rxCharacteristicUUID] forService:self.uartService];
            }
            else if ([s.UUID isEqual:self.class.deviceInformationServiceUUID])
            {
                [self.peripheral discoverCharacteristics:@[self.class.hardwareRevisionStringUUID] forService:s];
            }
            else if ([s.UUID isEqual:self.class.devServiceUUID])
            {
                self.devService = s;
                [self.peripheral discoverCharacteristics:@[self.class.devTxCharacteristicUUID, self.class.devRxCharacteristicUUID] forService:self.devService];
            }
        }
    }
}


//After the peripheral device finds the characteristics
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        DLog(@"Error discovering characteristics: %@", error);
        return;
    }
    
    if(!_rxCharacteristic || !_txCharacteristic)
    {
        for (CBCharacteristic *c in [service characteristics])
        {
            if ([c.UUID isEqual:kCharaNUUID])
            {
                self.rxCharacteristic = c;
//                [BTCommunication sharedInstance].characteristic = self.rxCharacteristic;
                [self.peripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
                //                [self.peripheral readValueForCharacteristic:self.rxCharacteristic];
            }
            else if ([c.UUID isEqual:kCharaWUUID])
            {
                self.txCharacteristic = c;
                [BTCommunication sharedInstance].characteristic = self.txCharacteristic;
//                [self.peripheral setNotifyValue:YES forCharacteristic:self.txCharacteristic];
            }
            
            if ([c.UUID isEqual:self.class.rxCharacteristicUUID] || [c.UUID isEqual:self.class.devRxCharacteristicUUID])
            {
                self.rxCharacteristic = c;
                [BTCommunication sharedInstance].characteristic = _txCharacteristic;
                
                [self.peripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
                
            }
            else if ([c.UUID isEqual:self.class.txCharacteristicUUID] || [c.UUID isEqual:self.class.devTxCharacteristicUUID])
            {
                self.txCharacteristic = c;
                [BTCommunication sharedInstance].characteristic = _txCharacteristic;
            }
        }
        if(_txCharacteristic && _rxCharacteristic)
            [_delegate didConnectSuccess];
    }
    if ([peripheral.name rangeOfString:@"BT"].location != NSNotFound) {
        [_delegate didConnectSuccess];
    }
}

/*!
 *  @param peripheral        The peripheral providing this information.
 *  @param characteristic    A <code>CBCharacteristic</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@",[error localizedDescription]);
        
    }
}

#pragma mark - An important part of data transmission, processing the data sent by Bluetooth
- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        return;
    }
        
    if (characteristic == self.rxCharacteristic)
    {
        [[BTCommunication sharedInstance] didReceiveData:characteristic.value];
        
    }
   
}

@end
