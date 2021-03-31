//
//  VTSingletonClass.h
//  BP
//
//  Created by fengye on 2019/11/19.
//  Copyright © 2019 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTSingletonClass : NSObject

/**Record the id selected during this login**/
@property (nonatomic, copy) NSString *currentID;
/** Determine whether it is offline data recording the id selected during this login*/
@property (nonatomic) BOOL isOffline;

/** Determine if it is upgrading */
@property (nonatomic, assign) BOOL isMonitorUpdating;

/** Determine whether it is AirBP or AirBP plus */
@property (nonatomic) BOOL isAirBPPlus;

//Share PDF in History interface for judgment
@property (nonatomic, assign) BOOL isSharePDF;

/** mesureVC BTCommunicate proxy, under AirBP plus */
@property (nonatomic, weak) id mesureVCDelegate;

/**Ensuring the execution of status instructions*/
@property (nonatomic, strong) NSTimer *measureStatusTimers;

+(VTSingletonClass *)sharedSingletonClass;

/**Roughly solve the problem of restarting app crashes*/
+ (void)setToNil;

@end

NS_ASSUME_NONNULL_END
