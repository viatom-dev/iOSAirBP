//
//  RealTimePressureInfo.h
//  BP
//
//  Created by Viatom on 2017/3/24.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTRealTimePressureInfo : NSObject
/*!
 @property
 @brief The real-time pressure of static pressure channel.（mmHg）*100
 */
@property (nonatomic,assign) signed short pressure_static;

/*!
 @property
 @brief The real-time pressure of pulse channel.（mmHg）*100
 */
@property (nonatomic,assign) signed short pressure_pulse;
@end
