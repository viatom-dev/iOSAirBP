//
//  BTUtils.m
//  Checkme Mobile
//
//  Created by Joe on 14/9/20.
//  Copyright (c) 2014 VIATOM. All rights reserved.
//

#import "BTUtils.h"
#import "VTNoticeName.h"

@interface BTUtils()

@end

@implementation BTUtils

+(BTUtils *)GetInstance
{
    static BTUtils *inst = nil;
    if(!inst){
        inst = [[BTUtils alloc] init];
    }
    return inst;
}

-(id)init
{
    self = [super init];
    if(self){

    }
    return self;
}


#pragma mark - Connection scan related custom method
/**
 *  @brief Turn on Bluetooth Create an instance of CBCentralManager
 **/
-(void)openBT
{
    _centralManager  = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

/**
 *  @brief Start scanning
 **/
-(void)beginScan
{
    //Scan all connectable devices
    [self.centralManager scanForPeripheralsWithServices:nil /*@[UARTPeripheral.devServiceUUID]*/ options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
}

/**
 *  @brief Stop scanning
 **/
-(void)stopScan
{
    [self.centralManager stopScan];//Stop scanning operation
}

#pragma mark - Click on the list of peripherals to execute the method of connecting peripherals
//Click an item in the Bluetooth list of the peripheral to execute the method of connecting to the peripheral
-(void)connectToPeripheral:(CBPeripheral *)peripheral
{
    if (peripheral) {

        _currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
        [BTCommunication sharedInstance].peripheral = peripheral;
        
//        NSLog(@"%@", _centralManager.delegate);
        NSLog(@"%@", _centralManager.delegate);
        
        //The central device executes the method of connecting Bluetooth
        [self.centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    }
}

- (void)disConnectToPeripheral:(CBPeripheral *)peripheral
{
    if (!peripheral) {
        [self.centralManager cancelPeripheralConnection:self.currentPeripheral.peripheral];
    }else
        [self.centralManager cancelPeripheralConnection:peripheral];

}

//Agent method for realizing central equipment
#pragma mark - CBCentralManagerDelegate
//Methods in the agreement     Check the Bluetooth status of the center device. Enter this method regardless of whether Bluetooth is turned on or not. Automatically call this method.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NtfName_BTPowerOn object:self userInfo:nil];
        
    }else{
    }
    
}

/**
 * Discovery of peripheral devices
 * 
 * @param central Central equipment
 * @param peripheral peripheral equipment
 * @param advertisementData Characteristic data
 * @param RSSI Signal quality (signal strength)
 */
//The optional method in the discovery device protocol is automatically called when the central device finds the peripheral device, and it can be adjusted multiple times.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if(peripheral.name)
    {
        NSMutableDictionary *mutDic = [NSMutableDictionary new];
        [mutDic setValue:peripheral forKey:Key_FindAPeripheral_Content];//kCBAdvDataLocalName
       [mutDic setValue:advertisementData[@"kCBAdvDataLocalName"] forKey:@"BLEName"];
        NSLog(@"aw*******  %@",advertisementData[@"kCBAdvDataLocalName"]);
        //kCBAdvDataIsConnectable   kCBAdvDataLocalName
        if ([peripheral.name hasPrefix:@"AirBP"] || [peripheral.name hasPrefix:@"SmartBP"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NtfName_FindAPeripheral object:self userInfo:mutDic];
        }
//        [mutDic copy];
    }
}

//Call back when you click to connect to a Bluetooth. The optional method in the protocol. This method is automatically called when the central device is connected to the peripheral.
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didConnect];
    }
    
}
//Connection failure callback The optional method in the protocol This method is automatically called when the connection between the central device and the peripheral fails
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NtfName_ConnectPeriphralFail object:self userInfo:nil];

}

//Callback when disconnected Optional method in the protocol
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if ([self.currentPeripheral.peripheral isEqual:peripheral]) {
        [self.currentPeripheral didDisconnect];
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NtfName_DisconnectPeriphral object:self userInfo:nil];
            [self connectToPeripheral:peripheral];
        }
    }
}

#pragma mark - UARTPeripheral delegate
//Successful connection callback
-(void)didConnectSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NtfName_ConnectPeriphralSuccess object:self userInfo:nil];
}



@end
