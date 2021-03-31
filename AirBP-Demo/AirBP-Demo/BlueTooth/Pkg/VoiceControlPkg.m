//
//  VoiceControlPkg.m
//  BP
//
//  Created by Viatom on 2020/11/27.
//  Copyright © 2020 Viatom. All rights reserved.
//

#import "VoiceControlPkg.h"

@implementation VoiceControlPkg

- (instancetype)initWithControlType:(unsigned short)controlType {
    self = [super init];
    if (self) {
        U8 buf[10];
        memset(buf, 0, 10);
        buf[0] = 0xA5;
        buf[1] = 0x00;
        buf[2] = 0x00;
        buf[3] = 0x09;
        buf[4] = 0x01;
        buf[5] = 0x00;
        buf[6] = 0x00;
        buf[7] = 0x00;
        buf[8] = controlType;
        buf[9] = [PublicUtils CalCRC8:buf bufSize:9];
        _buf = [NSData dataWithBytes:buf length:10];
    }
    return self;
}

@end
