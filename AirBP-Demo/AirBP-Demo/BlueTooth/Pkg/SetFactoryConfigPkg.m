//
//  SetFactoryConfigPkg.m
//  BP
//
//  Created by Viatom on 2017/3/22.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import "SetFactoryConfigPkg.h"

@implementation SetFactoryConfigPkg
- (instancetype)initWithDictory:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.burn_flag = [dic[@"burn_flag"] intValue];
        self.sn = dic[@"sn"];
        self.hw_version = [dic[@"hw_version"] characterAtIndex:0];
        
        U8 buf[21];
        memset(buf, 0, 21);
        buf[0] = 0xA5;
        buf[1] = 0x00;
        buf[2] = 0x00;
        buf[3] = 0xEA;
        *((U32*)&buf[4]) = 13;
        if (self.burn_flag == 1) {
            //sn
            buf[8] = 0x01;
            for(int i = 0;i < 11;i++){
                
            buf[i+9] = [self.sn characterAtIndex:i];
           
            }
            buf[20] = 0x00;

            
        }else if (self.burn_flag == 2){
            //硬件版本
            buf[8] = 0x02;
            for(int i = 0;i < 11;i++){
                
                buf[i+9] = 0x00;
            }

            buf[8] = self.hw_version;
                
        }else{
            //sn 跟硬件版本
            buf[8] = 0x03;
            for(int i = 0;i < 10;i++){
                if(i < self.sn.length){
                   buf[i+9] = [self.sn characterAtIndex:i];
                }else{
                   buf[i] = 0x00;
                }
            }
            
            
            buf[20] = self.hw_version;
                
        }

        _buf = [NSData dataWithBytes:buf length:21];
        
    }
    return self;

}

@end
