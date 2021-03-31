//
//  BatteryInfo.h
//  BP
//
//  Created by Viatom on 2017/3/22.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VTBatteryInfo : NSObject

/*!
 @property
 @brief Battery status e.g. 1: charging 2: full
 */
@property (nonatomic,assign) U8 state;
/*!
 @property
 @brief Battery status e.g. Battery charge percentage
 */
@property (nonatomic,assign) U8 percent;

/*!
 @property
 @brief Battery voltage(mV)    e.g.    3950 : 3.95V
 */
@property (nonatomic,assign) U16 voltage;


@end
