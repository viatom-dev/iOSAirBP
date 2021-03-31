//
//  EndMeasurePkg.m
//  BP
//
//  Created by Viatom on 2017/3/24.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import "EndMeasurePkg.h"

@implementation EndMeasurePkg

- (instancetype)init
{
    self = [super init];
    if (self) {
        U8 buf[9];
        memset(buf, 0, 9);
        buf[0] = 0xA5;
        buf[1] = 0x00;
        buf[2] = 0x00;
        buf[3] = 0x05;
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
