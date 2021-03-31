//
//  CalibrationSlopePkg.h
//  BP
//
//  Created by Viatom on 2017/3/23.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalibrationSlopePkg : NSObject

@property(nonatomic,strong) NSData* buf;

- (instancetype)initWithCalib_pressure:(int)pressure;

@end
