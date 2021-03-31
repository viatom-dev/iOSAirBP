//
//  BTCommunication.h
//  Checkme Mobile
//
//  Created by liqian on 15/4/21.
//  Copyright (c) 2015 VIATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTDefines.h"
#import "TypesDef.h"
#import "BleHeaderfile.h"

#define  TIMEOUT_CMD_GENERAL_RESPOND_MS 5000.0 //Normal file timeout
#define  TIMEOUT_CMD_PATCHS_RESPOND_MS 80000.0 //Upgrade package timed out
typedef U8 FileType_t;

/**
 FileLoadResult
 */
typedef  enum
{
    kFileLoadResult_Success,//success
    kFileLoadResult_TimeOut,//timeout
    kFileLoadResult_Fail,//fail
    kFileLoadResult_NotExist//notexist
}FileLoadResult_t;

/**
 Voice Control
 */
typedef enum : unsigned short
{
    kVoice_Open = 0,
    kVoice_Close = 1
}VoiceControl_t;

@class FileToRead;

@protocol BTCommunicationDelegate <NSObject>
///ping hosts successfully
@optional
- (void)pingSuccess;//ping On success

///ping hosts failed
@optional
- (void)pingFailed;  //ping When it fails


/**
 *  Send the current progress of reading
 *
 *  @param progress  progress value
 */
@optional
- (void)postCurrentReadProgress:(double)progress;

/**
 *  Read file complete
 */
@optional
- (void)readCompleteWithData:(FileToRead *)fileData;

/**
 *  Send the current progress of writing
 *
 *  @param progress the data been written currently
 */
@optional
- (void)postCurrentWriteProgress:(FileToRead *)fileData;

/**
 *  Write file successfully
 *
 *  @param fileData the data been written complete
 */
@optional
-(void)writeSuccessWithData:(FileToRead *)fileData;

/**
 *  Write file failed
 *
 *  @param fileData the data been written complete
 */
@optional
-(void)writeFailedWithData:(FileToRead *)fileData;
/**
 *  Get device information successfully
 */
@optional
-(void)getInfoSuccessWithData:(NSData *)data;

/// Get device information failed
@optional
-(void)getInfoFailed;

/**
 * Get battery status
 */
@optional
-(void)getBatteryStatusSuccessWithData:(NSData *)data;

@optional
-(void)getBatteryStatusFailed;

/**
 * Burn factory information
 */
@optional
-(void)setFactoryConfigSuccess;

@optional
-(void)setFactoryConfigFailed;

/**
 * Set time
 */
@optional
-(void)setTimeSuccess;

@optional
-(void)setTimeFailed;

/**
 * Get host temperature
 */
@optional
-(void)getDeviceTempSuccessWithData:(NSData *)data;

@optional
-(void)getDeviceTempFailed;

/**
 * Get set configuration parameters
 */
@optional
-(void)getConfiguartionSuccessWithData:(NSData *)data;

@optional
-(void)getConfiguartionFailed;

/**
 * Zero calibration
 */
@optional
-(void)setCalibrationZeroSuccessWithData:(NSData *)data;

@optional
-(void)setCalibrationZeroFailed;

/**
 * calibration
 */
@optional
-(void)setCalibrationSlopeSuccessWithData:(NSData *)data;

@optional
-(void)setCalibrationSlopeFailed;

/**
 * Set stop pumping pressure value
 */
@optional
-(void)setStopPressureSuccess;

@optional
-(void)setStopPressureFailed;

/**
 * Start measurement
 */
@optional
-(void)startMeasureSuccessWithData:(NSData *)data;

@optional
-(void)startMeasureFailed;

/**
 * Stop measurement
 */
@optional
-(void)endMeasureSuccess;

@optional
-(void)endMeasureFailed;

/**
 * Get the current measurement state
 */
@optional
- (void)getMeasureStatusSuccess:(NSData *)data;

@optional
- (void)getMeasureStatusFailed;

/**
 * Get measurement results
 */
@optional
- (void)getMeasureResultSuccess:(NSData *)data;

@optional
- (void)getMeasureResultFailed;

/**
 * Stop pumping up (prompt message, the host actively sends)
 */
- (void)stopPlayResult_WithData:(NSData *)data;

/**
 * Measurement result (the host takes the initiative to send when the measurement is over)
 */
- (void)getMeasureResult_WithData:(NSData *)data;

/**
 * Get real-time pressure value (non-measurement mode)
 */
- (void)getRealTimePressure_WithData:(NSData *)data;

/**
 * Buzzer switch
 */
@optional
- (void)voiceControlSetSuccess;

@optional
- (void)voiceControlSetFailed;

@end

@interface BTCommunication : NSObject <CBPeripheralDelegate>

/*!
 @property
 @brief Peripheral device
 */
@property (nonatomic,retain) CBPeripheral *peripheral;

/*!
 @property
 @brief manager
 */
@property (nonatomic, retain) CBPeripheralManager *manager;

/*!
 @property
 @brief Characteristic value
 */
@property (nonatomic,retain) CBCharacteristic *characteristic;

/*!
 @property
 @brief delegate
 */
@property (nonatomic, assign) id<BTCommunicationDelegate> delegate;

/*!
 @property
 @brief lenth
 */
@property (nonatomic,assign) int lenth;

/**
 *  Singleton
 *
 *  @return Returns the current instance
 */
+ (BTCommunication *) sharedInstance;


/**
 *  When you configure the Bluetooth，when the Bluetooth receiving the data in the callback method "peripheral: didUpdateValueForCharacteristic: error:" in CBPeripheralDelegate, this method must be called
 *
 *  @param data the data been received
 */
-(void)didReceiveData:(NSData *)data;

///  current file been read or written
@property (nonatomic,strong) FileToRead* curReadFile;

///  Start ping hosts
- (void)BeginPing;  //Start ping

/**
 * Get file list
 */
- (void)BegingetFileList;

/**
 * Reset does not return any value
 */
- (void)reset;

/**
 * Get battery status
 */
- (void)getBatteryStatus;

/**
 * Answer mode
 */
- (void)sendAnswer;

/**
 * Restore factory settings
 */
- (void)restorefactorySetting;

/**
 * Burn factory information
 */
- (void)setFactoryConfig_WithDic:(NSDictionary *)factoryConfig;

/**
 * Set time
 */
- (void)setTime_WithTime:(NSDate *)time;

/**
 * Get host temperature
 */
- (void)getDeviceTemp;

/**
 * Get set configuration parameters
 */
- (void)getConfiguartion;

/**
 * Zero calibration
 */
- (void)setCalibrationZero;

/**
 * calibration
 */
- (void)setCalibrationSlope_WithPressure:(int)pressure;

/**
 * Set stop pumping pressure value
 */
- (void)setStopPressure_WithPressure:(int)pressure;

/**
 * Start measurement
 */
- (void)startMeasureWithRate:(unsigned char)rate;

/**
 * Stop measurement
 */
- (void)endMeasure;

/**
 * Get current measurement status
 */
- (void)getMeasureStatus;

/**
 * Get measurement results
 */
- (void)getMeasureResult;

/**
 * Buzzer switch
 */
- (void)controlVoiceWithType:(VoiceControl_t)voiceType;

#pragma mark - Reading documents related
/**
 *  Read files from a handheld device via Bluetooth
 *
 *  @param fileName File name to be read
 *  @param type     File types to be read
 */
- (void)BeginReadFileWithFileName:(NSString*)fileName fileType:(U8)type;

#pragma mark - Write file related
/**
 *  Writes data to handheld devices via Bluetooth
 *
 *  @param fileName File name to be written
 *  @param fileType File types to be written
 */
- (void)BeginWriteFile:(NSString*)fileName FileType:(U8)fileType andFileData:(NSData *)fileData;

///  Get device information
- (void)BeginGetInfo;


///  others， you can use it when write file failed and will trigger proxy mode
-(void)writeFailed;

/**
 *  if it is loading file or not
 *
 *  @return return YES when some data is being loaded, otherwise return NO
 */
-(BOOL)bLoadingFileNow;

/**
 *  return current load fileType
 *
 *  @return return current load fileType
 */
-(FileType_t)curLoadFileType;
@end


/**
 *  this is a class to describe the completeed current loading or writing file
 */
@interface FileToRead : NSObject

///  file name
@property (nonatomic,assign) NSString *fileName;

///  file type
@property (nonatomic,assign) U8 fileType;

/// file size
@property (nonatomic,assign) U32 fileSize;

///  number of packages
@property (nonatomic,assign) U32 totalPkgNum;

///  current reading or writing number of packages
@property (nonatomic,assign) U32 curPkgNum;

///  the size of the last package
@property (nonatomic,assign) U32 lastPkgSize;

///  the contents of file being read or writen
@property (nonatomic,retain) NSMutableData *fileData;

///   the result analysis of reading or writing
@property (nonatomic,assign) FileLoadResult_t enLoadResult;

/**
 *  init method
 *
 *  @param fileType fileType
 *
 *  @return Returns the current instance
 */
- (instancetype)initWithFileType:(U8)fileType;

///  others not important
+(NSString *)descOfFileType:(FileType_t)kind;
-(NSString *)loadStateDesc;
@end
