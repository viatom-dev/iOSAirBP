//
//  AnswerPkg.m
//  BP
//
//  Created by Viatom on 2017/3/22.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import "AnswerPkg.h"

@implementation AnswerPkg
- (instancetype)init
{
    self = [super init];
    if (self) {
        U8 buf[8];
        memset(buf, 0, 8);
        buf[0] = 0xA5;
        buf[1] = 0x00;
        buf[2] = 0x02;
        buf[3] = 0x00;
        buf[4] = 0x00;
        buf[5] = 0x00;
        buf[6] = 0x00;
        buf[7] = 0x00;
        _buf = [NSData dataWithBytes:buf length:8];
    }
    return self;
}

@end
