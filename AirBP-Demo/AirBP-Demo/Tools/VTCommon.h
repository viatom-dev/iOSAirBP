//
//  Common.h
//  SmartBP
//
//  Created by Chaos on 16/4/27.
//  Copyright © 2016 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypesDef.h"
#import <UIKit/UIKit.h>

typedef void(^resultBlock)(BOOL success);

typedef enum : NSUInteger {
    SharedResultsSuccess,
    SharedResultsFailed,
    SharedResultsCancel,
} SharedResults;

typedef void(^SharedResult)(SharedResults result);

@interface Common : NSObject

+ (NSString *)getDeviceName;



@end
