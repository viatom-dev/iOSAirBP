//
//  FileListAckPfg.h
//  BP
//
//  Created by Viatom on 2017/3/21.
//  Copyright © 2017 Viatom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileListAckPfg : NSObject
@property(nonatomic,retain) NSData* infoData;

- (instancetype)initWithBuf:(NSData*)buf;
@end
