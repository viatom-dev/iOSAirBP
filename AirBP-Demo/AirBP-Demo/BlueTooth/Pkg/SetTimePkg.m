//
//  SetTimePkg.m
//  BP
//
//  Created by Viatom on 2017/3/22.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import "SetTimePkg.h"

@implementation SetTimePkg
- (instancetype)initWithDateComponents:(NSDateComponents*)dtcDate
{
    self = [super init];
    if (self) {
       
        
        U8 buf[15];
        memset(buf, 0, 15);
        buf[0] = 0xA5;
        buf[1] = 0x00;
        buf[2] = 0x00;
        buf[3] = 0xEC;
        *((U32*)&buf[4]) = 7;
        *((U32*)&buf[8]) = (int)dtcDate.year;
        *((U8*)&buf[10]) = (int)dtcDate.month;
        *((U8*)&buf[11]) = (int)dtcDate.day;
        *((U8*)&buf[12]) = (int)dtcDate.hour;
        *((U8*)&buf[13]) = (int)dtcDate.minute;
        *((U8*)&buf[14]) = (int)dtcDate.second;
        
       

        
        _buf = [NSData dataWithBytes:buf length:15];
        
    }
    return self;
    
}

@end
