//
//  ConfiguartionInfo.h
//  BP
//
//  Created by Viatom on 2017/3/23.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTConfiguartionInfo : NSObject

/*!
 @property
 @brief The adc value of zero calibration last time.    e.g.    2800<=zero<=12000 128mV~550mV
 */
@property (nonatomic,assign) U16 prev_calib_zero;

/*!
 @property
 @brief The last time the adc value is zeroed.    e.g.    2800<=zero<=12000 128mV~550mV
 */
@property (nonatomic,assign) U16 last_calib_zero;

/*!
 @property
 @brief Zero adc value
 */
@property (nonatomic,assign) U16 calib_zero;

/*!
 @property
 @brief Calibration slope value  *100    e.g.    13630<=slope<=17040 136.3LSB/mmHg-170.4LSB/mmHg
 */
@property (nonatomic,assign) U16 calib_slope;

/*!
 @property
 @brief Pressure value for calibrating slope.
 */
@property (nonatomic,assign) U8 slope_pressure;

/*!
 @property
 @brief Stop pumping pressure value unit:mmHg
 */
@property (nonatomic,assign) U16 stop_pressure;

/*!
 @property
 @brief Sleep time last time
 */
@property (nonatomic,assign) time_t sleep_ticks;

/*!
 @property
 @brief The last time of calibrating time.
 */
@property (nonatomic,assign) time_t calib_ticks;

/*!
 @property
 @brief Last restart into low energy mode time.
 */
@property (nonatomic,assign) time_t reset_ticks;

/*!
 @property
 @brief The flag that whether enter low energy mode.

 */
@property (nonatomic,assign) U8 sleep_flag;

/*!
 @property
 @brief 0.Turn on the buzzer. 1.Turn off the buzzer.
 */
@property (nonatomic,assign) U8 beep_switch;

/*!
 @property
 @brief Reserved
 */
@property (nonatomic,assign) U8 reserved;


@end
