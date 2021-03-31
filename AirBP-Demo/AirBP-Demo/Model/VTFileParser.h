//
//  FileParser.h
//  BTHealth
//
//  Created by demo on 13-11-4.
//  Copyright (c) 2013 LongVision's Mac02. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TypesDef.h"
#import "VTDeviceInfo.h"
#import "VTBatteryInfo.h"
#import "VTDeviceTemp.h"
#import "VTConfiguartionInfo.h"
#import "VTCalibrationZeroInfo.h"
#import "VTCalibrationSlopeInfo.h"
#import "VTRealTimePressureInfo.h"
#import "VTBloodPressureResultInfo.h"
#import "VTPlusConfigurationInfo.h"

@interface VTFileParser : NSObject

/**
 *  @brief Analyze device information
 **/
+ (VTDeviceInfo *)parseDeviceInfo_WithFileData:(NSData *)data;

/**
 *  @brief Analyze device battery status information
 **/
+ (VTBatteryInfo *)parseBatteryInfo_WithFileData:(NSData *)data;

/**
 *  @brief Analyze device temperature information
 **/
+ (VTDeviceTemp *)parseDeviceTemp_WithFileData:(NSData *)data;

/**
 *  @brief Analyze device settings configuration information
 **/
+ (VTConfiguartionInfo *)parseConfiguartionInfo_WithFileData:(NSData *)data;

/**
 *  @brief Parse the plus version device configuration information
 **/
+ (VTPlusConfigurationInfo *)parsePlusConfiguartionInfo_WithFileData:(NSData *)data;

/**
 *  @brief Analyze the returned result of zero calibration
 **/
+ (VTCalibrationZeroInfo *)parseCalibrationZeroInfo_WithFileData:(NSData *)data;

/**
 *  @brief Analyze the returned results of the calibration
 **/
+ (VTCalibrationSlopeInfo *)parseCalibrationSlopeInfo_WithFileData:(NSData *)data;

/**
 *  @brief Analyze the returned result of the start measurement
 **/
+ (VTRealTimePressureInfo *)parseStartMeasureInfo_WithFileData:(NSData *)data;

/**
 *  @brief Analyze measurement results
 **/
+ (VTBloodPressureResultInfo *)parseBloodPressureResultInfo_WithFileData:(NSData *)data;

/**
 *  @brief Analyze the real-time pulse value after stopping pumping up
 **/
+ (VTBloodPressureResultInfo *)pressurePulseResultInfo_WithFileData:(NSData *)data;

/**
 *  parse the home mode user list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'User'
 */
+(NSArray *)parseUserList_WithFileData:(NSData *)data;

/**
 *  parse the BPCheck list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'BPCheckItem'
 */
+(NSArray *)parseBPCheck_WithFileData:(NSData *)data;


/**
 *  parse the DailyCheck list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'DailyCheckItem'
 */
+(NSArray *)parseDlcList_WithFileData:(NSData *)data;


/**
 *  parse the ECG list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'ECGInfoItem'
 */
+(NSArray *)parseEcgList_WithFileData:(NSData *)data;




/**
 *  parse the Spo2 list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'SPO2InfoItem'
 */
+(NSArray *)parseSPO2List_WithFileData:(NSData *)data;


/**
 *  parse the Temp list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'TempInfoItem'
 */
+(NSArray *)parseTempList_WithFileData:(NSData *)data;


/**
 *  parse the SLM list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'SLMItem'
 */
//+(NSArray *)parseSLMList_WithFileData:(NSData *)data;


/**
 *  parse the RelaxMe list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'RelaxMeItem'
 */
+(NSArray *)parseRelaxMeList_WithFileData:(NSData *)data;


/**
 *  parse the Ped list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'PedInfoItem'
 */
+(NSArray *)parsePedList_WithFileData:(NSData *)data;




/**
 *  parse the Hospital mode xUser list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'Xuser'
 */
+ (NSArray *) paserXusrList_WithFileData:(NSData *)data;


/**
 *  parse the SpotCheck list through the data reading from blueTooth
 *
 *  @param data the data reading from blueTooth
 *
 *  @return return array contains items which is subclass of 'SpotCheckItem'
 */
+(NSArray *)paserSpotCheckList_WithFileData:(NSData *)data;


@end
