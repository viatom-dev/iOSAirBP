//
//  DeviceTemp.h
//  BP
//
//  Created by Viatom on 2017/3/23.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTDeviceTemp : NSObject

/*!
 @property
 @brief Temperature*100  e.g. 2410: 24.1 degrees Celsius
 */
@property (nonatomic,assign) U16 temp;

@end
