//
//  CalibrationSlopeInfo.h
//  BP
//
//  Created by Viatom on 2017/3/23.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTCalibrationSlopeInfo : NSObject

/*!
 @property
 @brief (Calibration slope value)*100​e.g.​13630<=slope<=17040 136.3LSB/mmHg-170.4LSB/mmHg
 */
@property (nonatomic,assign) U16 calib_slope;

@end
