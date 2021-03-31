//
//  UIBezierPath+Smoothing.h
//  BP
//
//  Created by yangweichao on 2018/6/29.
//  Copyright © 2018 Viatom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Smoothing)

- (UIBezierPath *)smoothedPathWithGranularity:(int)granularity;
@end
