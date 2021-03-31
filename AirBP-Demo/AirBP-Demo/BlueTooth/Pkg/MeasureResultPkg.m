//
//  MeasureResultPkg.m
//  BP
//
//  Created by Viatom on 2020/12/10.
//  Copyright © 2020 Viatom. All rights reserved.
//

#import "MeasureResultPkg.h"

@implementation MeasureResultPkg

- (instancetype)init
{
    self = [super init];
    if (self) {
        U8 buf[9];
        memset(buf, 0, 9);
        buf[0] = 0xA5;
        buf[1] = 0x00;
        buf[2] = 0x00;
        buf[3] = 0x07;
        buf[4] = 0x00;
        buf[5] = 0x00;
        buf[6] = 0x00;
        buf[7] = 0x00;
        buf[8] = [PublicUtils CalCRC8:buf bufSize:8];
        _buf = [NSData dataWithBytes:buf length:9];
    }
    return self;
}

@end
