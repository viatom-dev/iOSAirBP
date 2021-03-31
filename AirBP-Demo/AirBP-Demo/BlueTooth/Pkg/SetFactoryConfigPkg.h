//
//  SetFactoryConfigPkg.h
//  BP
//
//  Created by Viatom on 2017/3/22.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetFactoryConfigPkg : NSObject
@property(nonatomic,assign) int burn_flag;
@property(nonatomic,copy) NSString *sn;
@property (nonatomic,assign) U8 hw_version;
@property(nonatomic,strong) NSData* buf;

- (instancetype)initWithDictory:(NSDictionary*)dic;
@end
