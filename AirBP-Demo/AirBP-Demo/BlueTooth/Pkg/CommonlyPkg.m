//
//  CommonlyPkg.m
//  BP
//
//  Created by Viatom on 2017/3/22.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import "CommonlyPkg.h"
#import "BTDefines.h"
#import "PublicUtils.h"
#import "TypesDef.h"

@implementation CommonlyPkg
- (instancetype)initWithBuf:(NSData*)buf
{
    self = [super init];
    if (self) {
        U8 *tempBuf = (U8*)buf.bytes;
        if(tempBuf[0]!=0xA5){
            DLog(@"GetInfoAck packet header error");
            return nil;
        }
//        else if(tempBuf[buf.length - 1] != [PublicUtils CalCRC8:tempBuf bufSize:buf.length-1])
//        {
//            //DLog(@"Check code error");
//            return nil;
//        }
        if (tempBuf[2] == 0x01) {
            DLog(@"Need to resend");
            self.isAck = YES;
        }else{
        
            self.isAck = NO;
        }
        
        U32 _fileSize = *((U32 *)&tempBuf[4]);
        if (_fileSize & (1 << 31)) {
            
            return nil;
        }
        
        _infoData = [buf subdataWithRange:NSMakeRange(8, buf.length - 8)];
    }
    return self;
}


@end
