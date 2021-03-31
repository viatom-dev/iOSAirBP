//
//  VoiceControlPkg.h
//  BP
//
//  Created by Viatom on 2020/11/27.
//  Copyright © 2020 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceControlPkg : NSObject

@property(nonatomic,strong) NSData* buf;

- (instancetype)initWithControlType:(unsigned short)controlType;

@end

NS_ASSUME_NONNULL_END
