//
//  BloodPressureResultInfo.h
//  BP
//
//  Created by Viatom on 2017/3/24.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTBloodPressureResultInfo : NSObject

/**
 time
 */
@property (nonatomic,retain) NSDateComponents *dtcDate;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, assign) double timeStamp;

/*!
 @property
 @brief Status code
 */
@property (nonatomic,assign) U8 state_code;

/*!
 @property
 @brief Systolic blood pressure
 */
@property (nonatomic,assign) short systolic_pressure;

/*!
 @property
 @brief Diastolic blood pressure
 */
@property (nonatomic,assign) short diastolic_pressure;

/*!
 @property
 @brief Mean blood pressure
 */
@property (nonatomic,assign) short mean_pressure;

/*!
 @property
 @brief Pulse rate
 */
@property (nonatomic,assign) U16 pulse_rate;


@end
