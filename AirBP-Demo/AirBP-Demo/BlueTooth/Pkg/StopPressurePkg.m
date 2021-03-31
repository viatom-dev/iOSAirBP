//
//  StopPressurePkg.m
//  BP
//
//  Created by Viatom on 2017/3/23.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import "StopPressurePkg.h"

@implementation StopPressurePkg

- (instancetype)initWith_StopPressure:(int)pressure
{
    self = [super init];
    if (self) {
        
        
        U8 buf[10];
        memset(buf, 0, 10);
        buf[0] = 0xA5;
        buf[1] = 0x00;
        buf[2] = 0x00;
        buf[3] = 0x03;
        *((U32*)&buf[4]) = 2;
        *((U16*)&buf[8]) = pressure;
        _buf = [NSData dataWithBytes:buf length:10];
        
    }
    return self;

}
@end
