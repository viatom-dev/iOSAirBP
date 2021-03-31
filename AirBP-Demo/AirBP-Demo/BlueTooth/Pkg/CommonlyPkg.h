//
//  CommonlyPkg.h
//  BP
//
//  Created by Viatom on 2017/3/22.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonlyPkg : NSObject
@property(nonatomic,retain) NSData* infoData;
@property(nonatomic,assign) BOOL isAck;
- (instancetype)initWithBuf:(NSData*)buf;
@end
