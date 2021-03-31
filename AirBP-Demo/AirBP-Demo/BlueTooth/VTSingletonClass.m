//
//  VTSingletonClass.m
//  BP
//
//  Created by fengye on 2019/11/19.
//  Copyright © 2019 Viatom. All rights reserved.
//

#import "VTSingletonClass.h"

static VTSingletonClass *_singletonClass;
static dispatch_once_t oneToken;

@implementation VTSingletonClass

+(VTSingletonClass *)sharedSingletonClass
{
    
    dispatch_once(&oneToken, ^{
        
        _singletonClass = [[VTSingletonClass alloc] init];
        
    });
    
    return _singletonClass;
}


- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void)setToNil {
    oneToken = 0l;
    _singletonClass = nil;
}

@end
