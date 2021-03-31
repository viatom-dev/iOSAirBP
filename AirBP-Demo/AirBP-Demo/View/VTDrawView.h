//
//  DrawView.h
//  BP
//
//  Created by yangweichao on 2018/6/8.
//  Copyright © 2018 Viatom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTDrawView : UIView

//Data pool of the current receiving point
@property (nonatomic,strong) NSMutableArray *realTimeDataArr;

//Refresh line drawing
- (void)prepareToRefreshPW;
- (void)startToRefreshPW;
@end
