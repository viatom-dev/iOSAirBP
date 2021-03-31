//
//  UARTPeripheral.h
//  nRF UART
//
//  Created by Ole Morten on 1/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTCommunication.h"

@protocol UARTPeripheralDelegate
@optional
/** did Read hardwar evision string */
-(void) didReadHardwareRevisionString:(NSString *) string;

/** did connect success */
-(void)didConnectSuccess;
@end


@interface UARTPeripheral : NSObject <CBPeripheralDelegate>
@property (nonatomic,retain) CBPeripheral *peripheral;//Central device
@property (nonatomic,retain) CBCharacteristic *txCharacteristic;//write
@property (nonatomic,assign) id<UARTPeripheralDelegate> delegate;//delegate


- (UARTPeripheral *) initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<UARTPeripheralDelegate>) delegate;

/** write String */
- (void) writeString:(NSString *) string;

/** write Raw Data */
- (void) writeRawData:(NSData *) data;

/** did Connect */
- (void) didConnect;

/** did Disconnect */
- (void) didDisconnect;
@end
