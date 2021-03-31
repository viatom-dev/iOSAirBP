//
//  CalibrationSlopePkg.m
//  BP
//
//  Created by Viatom on 2017/3/23.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import "CalibrationSlopePkg.h"

@implementation CalibrationSlopePkg
- (instancetype)initWithCalib_pressure:(int)pressure
{
    self = [super init];
    if (self) {
        
        
        U8 buf[11];
        memset(buf, 0, 11);
        buf[0] = 0xA5;
        buf[1] = 0x00;
        buf[2] = 0x00;
        buf[3] = 0x02;
        *((U32*)&buf[4]) = 2;
        *((U16*)&buf[8]) = pressure;
        buf[10] = [PublicUtils CalCRC8:buf bufSize:10];
        _buf = [NSData dataWithBytes:buf length:11];
        
    }
    return self;


}

@end
