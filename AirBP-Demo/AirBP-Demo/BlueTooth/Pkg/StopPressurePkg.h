//
//  StopPressurePkg.h
//  BP
//
//  Created by Viatom on 2017/3/23.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopPressurePkg : NSObject
@property(nonatomic,strong) NSData* buf;
- (instancetype)initWith_StopPressure:(int)pressure;

@end
