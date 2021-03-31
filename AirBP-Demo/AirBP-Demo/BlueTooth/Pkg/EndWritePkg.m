//
//  EndWritePkg.m
//  Checkme Mobile
//
//  Created by Joe on 14/9/22.
//  Copyright (c) 2014 VIATOM. All rights reserved.
//

#import "EndWritePkg.h"
#import "BTDefines.h"
#import "PublicUtils.h"
#import "TypesDef.h"

@implementation EndWritePkg

- (instancetype)initWithCmd:(int)cmd
{
    self = [super init];
    if (self) {
        U8 buf[COMMON_PKG_LENGTH];
        memset(buf, 0, COMMON_PKG_LENGTH);
        buf[0] = 0xAA;
        buf[1] = cmd;
        buf[2] = ~cmd;
        buf[3] = 0;//Package number, default 0
        buf[4] = 0;
        buf[5] = 0;//The packet size is 0
        buf[6] = 0;
        buf[COMMON_PKG_LENGTH-1] = [PublicUtils CalCRC8:buf bufSize:COMMON_PKG_LENGTH-1];
        _buf = [NSData dataWithBytes:buf length:COMMON_PKG_LENGTH];
    }
    return self;
}

@end
