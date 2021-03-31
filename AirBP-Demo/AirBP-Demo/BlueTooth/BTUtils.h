//
//  BTUtils.h
//  Checkme Mobile
//
//  Created by Joe on 14/9/20.
//  Copyright (c) 2014 VIATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UARTPeripheral.h"
#import "BTCommunication.h"

//Comply with the agency agreement for central management and peripheral services...
@interface BTUtils : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate, UARTPeripheralDelegate>

@property (nonatomic,retain) UARTPeripheral *currentPeripheral;
@property (nonatomic,retain) CBCentralManager *centralManager;
@property (nonatomic,strong) FileToRead *curReadFile;
//Drive related
+(BTUtils *)GetInstance;
-(void)openBT;
-(void)beginScan;
-(void)connectToPeripheral:(CBPeripheral *)peripheral;
-(void)stopScan;
- (void)disConnectToPeripheral:(CBPeripheral *)peripheral;

@end
