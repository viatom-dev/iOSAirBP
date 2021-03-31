//
//  StartMeasurePkg.m
//  BP
//
//  Created by Viatom on 2017/3/23.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import "StartMeasurePkg.h"

@implementation StartMeasurePkg

//   10  
- (instancetype)initWithSendRate:(unsigned char)rate
{
    self = [super init];
    if (self) {
        U8 buf[10];
        memset(buf, 0, 10);
        buf[0] = 0xA5;
        buf[1] = 0x00;
        buf[2] = 0x00;
        buf[3] = 0x04;
        buf[4] = 0x01;
        buf[5] = 0x00;
        buf[6] = 0x00;
        buf[7] = 0x00;
        buf[8] = rate;//Data transmission frequency(Hz)
        buf[9] = [PublicUtils CalCRC8:buf bufSize:9];
        _buf = [NSData dataWithBytes:buf length:10];
    }
    return self;
}

@end
