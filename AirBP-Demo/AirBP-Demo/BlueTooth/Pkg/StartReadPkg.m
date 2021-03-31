//
//  StartReadPkg.m
//  Checkme Mobile
//
//  Created by Joe on 14/9/20.
//  Copyright (c) 2014 VIATOM. All rights reserved.
//

#import "StartReadPkg.h"
#import "PublicUtils.h"
#import "TypesDef.h"

@implementation StartReadPkg

- (instancetype)initWithFileName:(NSString*)fileName
{
    self = [super init];
    if (self) {
        if(fileName.length>BT_READ_FILE_NAME_MAX_LENGTH) {
            DLog(@"The read command file name is too long");
        }
        int bufLength = (int)(COMMON_PKG_LENGTH + fileName.length + 1);//+1 is equivalent to \0
        U8 buf[bufLength];   //string
        memset(buf,0x00,bufLength);    //Initialization of buf      Set the value of the first bufLength bytes of the instance buf that has opened up memory space to 0x00 (即0)
        buf[0] = 0xA5;   // 1010  1010
        buf[1] = 0x00;
        buf[2] = 0x00;
        buf[3] = 0xF2;
        buf[4] = bufLength - COMMON_PKG_LENGTH;
        buf[5] = bufLength - COMMON_PKG_LENGTH;//Data length   9-8=1
        buf[6] = (bufLength - COMMON_PKG_LENGTH) >> 8;     //1 shift 8 bits to the right = 0
        for (int i=0; i<fileName.length; i++) {
            buf[i+7] = [fileName characterAtIndex:i];
        }
        
        _buf = [NSData dataWithBytes:buf length:bufLength];
    }
    
    return self;
}



@end
