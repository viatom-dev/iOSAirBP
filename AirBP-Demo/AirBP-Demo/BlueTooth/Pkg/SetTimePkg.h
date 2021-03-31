//
//  SetTimePkg.h
//  BP
//
//  Created by Viatom on 2017/3/22.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetTimePkg : NSObject
@property(nonatomic,strong) NSData* buf;

- (instancetype)initWithDateComponents:(NSDateComponents*)dtcDate;

@end
