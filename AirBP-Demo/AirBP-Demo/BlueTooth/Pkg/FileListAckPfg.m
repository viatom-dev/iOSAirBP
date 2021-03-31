//
//  FileListAckPfg.m
//  BP
//
//  Created by Viatom on 2017/3/21.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import "FileListAckPfg.h"

@implementation FileListAckPfg
- (instancetype)initWithBuf:(NSData*)buf
{
    self = [super init];
    if (self) {
        U8 *tempBuf = (U8*)buf.bytes;
        if(tempBuf[0]!=0xA5){
            //DLog(@"GetInfoAck包头错误");
            return nil;
        }
        if (tempBuf[2] == 0x02) {
            //DLog(@"为应答模式");
            return nil;
            
        }
        
        if (tempBuf[2] == 0x001) {
            //DLog(@"需要重发");
            return nil;
            
        }
        
        _infoData = [buf subdataWithRange:NSMakeRange(8, buf.length - 8)];
        
       
        
        
    }
    return self;
}

@end
