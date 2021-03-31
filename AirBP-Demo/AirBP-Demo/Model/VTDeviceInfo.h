//
//  DeviceInfo.h
//  BP
//
//  Created by Viatom on 2017/3/20.
//  Copyright © 2017 Viatom. All rights reserved.
//


@interface VTDeviceInfo : NSObject
/*!
 @property
 @brief hardware version e.g. ‘A’ : A verson
 */
@property (nonatomic, copy)     NSString            *hw_verson;

/*!
 @property
 @brief firmware version e.g. 0x010100 : V1.1.0
 */
@property (nonatomic, copy)     NSString            *fw_version;

/*!
 @property
 @brief Boot version e.g. 0x010100 : V1.1.0
 */
@property (nonatomic, copy)     NSString            *bl_version;

/*!
 @property
 @brief sn number e.g. “2017022211” : 2017022211
 */
@property (nonatomic, copy)     NSString            *sn;

/*!
 @property
 @brief device type e.g. 0x8611: sphygmomanometer
 */
@property (nonatomic, assign)   U16                 device_type;

/*!
 @property
 @brief Protocol version e.g.0x0100:V1.0
 */
@property (nonatomic, copy)     NSString            *protocol_version;

/*!
 @property
 @brief time
 */
@property (nonatomic, assign) U8 cur_time;

/*!
 @property
 @brief time
 */
@property (nonatomic, retain)   NSDateComponents    *dtcDate;

/*!
 @property
 @brief  transfer_size
 */
@property (nonatomic, assign)   U16                 transfer_size;

/*!
 @property
 @brief Maximum length of communication
 */
@property (nonatomic, assign)   U16                 comm_max_len;

/*!
 @property
 @brief Maximum length of the protocol
 */
@property (nonatomic, assign)   U16                 pro_max_len;

/*!
 @property
 @brief branchCode
 */
@property (nonatomic, copy)   NSString              *branchCode;

/*!
 @property
 @brief reserved
 */
@property (nonatomic, assign)   U8              reserved;

/*!
 @property
 @brief Data segment maximum length of communication protocol, which exclude fixed bytes.
 */
@property (nonatomic, assign)   U8              protocol_data_max_len;


- (instancetype)initWithData:(NSData *)data;

@end
