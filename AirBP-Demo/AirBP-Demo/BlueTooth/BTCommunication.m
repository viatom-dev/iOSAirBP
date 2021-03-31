//
//  BTCommunication.m
//  Checkme Mobile
//
//  Created by liqian on 15/4/21.
//  Copyright (c) 2015 VIATOM. All rights reserved.
//

#import "BTCommunication.h"

#import "InformationPkg.h"
#import "ReadContentPkg.h"
#import "ReadContentAckPkg.h"
#import "StartReadPkg.h"
#import "StartReadAckPkg.h"
#import "WriteContentPkg.h"
#import "EndReadPkg.h"
#import "EndWritePkg.h"
#import "StartWritePkg.h"
#import "FileListPkg.h"
#import "ResetPkg.h"
#import "BatteryStatusPkg.h"
#import "CommonlyPkg.h"
#import "AnswerPkg.h"
#import "RestorefactoryPkg.h"
#import "SetFactoryConfigPkg.h"
#import "SetTimePkg.h"
#import "DeviceTempPkg.h"
#import "ConfiguartionPkg.h"
#import "CalibrationZeroPkg.h"
#import "CalibrationSlopePkg.h"
#import "StopPressurePkg.h"
#import "StartMeasurePkg.h"
#import "EndMeasurePkg.h"
#import "VoiceControlPkg.h"
#import "MeasureStatusPkg.h"
#import "MeasureResultPkg.h"





@interface BTCommunication ()

/**
 *  Buf for retransmission
 */
@property(nonatomic,strong) NSData* preSendBuf;

/**
 *  the dataPool used to store data from the blueTooth
 */
@property (nonatomic,retain) NSMutableData *dataPool;

/**
 *  Current status, used to distinguish different processing after receiving the packet
 */
@property(nonatomic,assign) int curStatus;

/**
 *  Temporary read and write files
 */
@property (nonatomic,strong) FileToRead* temReadFile;


@end

@implementation BTCommunication

+ (BTCommunication *)sharedInstance
{
    static BTCommunication *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id) init {
    self = [super init];
    if (self) {
        _dataPool = [NSMutableData data];
    }
    return self;
}

#pragma mark - Ping host related
- (void) BeginPing
{
}

/**
 * Get file list
 */
- (void)BegingetFileList
{
    FileListPkg *pkg = [[FileListPkg alloc] init];
        if (!pkg) {
            return;
        }
        _curStatus = BT_STATUS_WAITING_GET_FILELIST_ACK;      // 20
        [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Reset does not return any value
 */
- (void)reset
{

    ResetPkg *pkg = [[ResetPkg alloc] init];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_RESET_ACK;      // 11
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 *Get battery status
 */
- (void)getBatteryStatus
{
    BatteryStatusPkg *pkg = [[BatteryStatusPkg alloc] init];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_Battery_Status_ACK;      // 12
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 *Send response command
 */
- (void)sendAnswer
{
    AnswerPkg *pkg = [[AnswerPkg alloc] init];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_Battery_Status_ACK;      // 12
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Restore factory settings
 */
- (void)restorefactorySetting
{
    RestorefactoryPkg *pkg = [[RestorefactoryPkg alloc] init];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_Restorefactory_Setting_ACK;      // 13
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 *
 */
//Burn factory information
- (void)setFactoryConfig_WithDic:(NSDictionary *)factoryConfig;
{
    SetFactoryConfigPkg *pkg = [[SetFactoryConfigPkg alloc] initWithDictory:factoryConfig];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_FactoryConfig_Setting_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Set time
 */
- (void)setTime_WithTime:(NSDate *)time
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned units  = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;

    NSDateComponents *dateC = [gregorian components:units fromDate:time];
    SetTimePkg *pkg = [[SetTimePkg alloc] initWithDateComponents:dateC];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_Time_Setting_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Get host temperature
 */
- (void)getDeviceTemp
{
    DeviceTempPkg *pkg = [[DeviceTempPkg alloc] init];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_GET_Temp_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Get set configuration parameters
 */
- (void)getConfiguartion
{
    ConfiguartionPkg *pkg = [[ConfiguartionPkg alloc] init];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_GET_Configuartion_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Zero calibration
 */
- (void)setCalibrationZero
{
    CalibrationZeroPkg *pkg = [[CalibrationZeroPkg alloc] init];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_SET_CalibrationZero_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * calibration
 */
- (void)setCalibrationSlope_WithPressure:(int)pressure
{
    CalibrationSlopePkg *pkg = [[CalibrationSlopePkg alloc] initWithCalib_pressure:pressure];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_SET_CalibrationSlope_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Set stop pumping pressure value
 */
- (void)setStopPressure_WithPressure:(int)pressure
{
    StopPressurePkg *pkg = [[StopPressurePkg alloc] initWith_StopPressure:pressure];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_SET_StopPressure_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Start measurement
 */
- (void)startMeasureWithRate:(unsigned char)rate
{
    StartMeasurePkg *pkg = [[StartMeasurePkg alloc] initWithSendRate:rate];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_START_Measure_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Stop measurement
 */
- (void)endMeasure
{
    EndMeasurePkg *pkg = [[EndMeasurePkg alloc] init];
    if (!pkg) {
        
        return;
    }
    _curStatus = BT_STATUS_WAITING_END_Measure_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Get current measurement status
 */
- (void)getMeasureStatus {
    MeasureStatusPkg *pkg = [[MeasureStatusPkg alloc] init];
    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_Current_Running_Status_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * Get measurement results
 */
- (void)getMeasureResult {
    MeasureResultPkg *pkg = [[MeasureResultPkg alloc] init];

    if (!pkg) {
        return;
    }
    _curStatus = BT_STATUS_WAITING_Measure_Result_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

/**
 * buzzer
 */
- (void)controlVoiceWithType:(VoiceControl_t)voiceType {
    VoiceControlPkg *pkg = [[VoiceControlPkg alloc] initWithControlType:voiceType];
    if (!pkg) {
        return;
    }
    
    _curStatus = BT_STATUS_WAITING_Buzzer_Witch_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

#pragma mark - Reading documents related
- (void)BeginReadFileWithFileName:(NSString *)fileName fileType:(U8)type
{
    StartReadPkg* pkg = [[StartReadPkg alloc]initWithFileName:fileName];
    if (!pkg) {
        [self readFailed];
        return;
    }
    
    _curReadFile = [[FileToRead alloc]init];
    _curReadFile.fileName = fileName;
    _curReadFile.fileType = type;
    
    _curStatus = BT_STATUS_WAITING_START_READ_ACK;
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];   //5000s
}

- (void)readSuccess
{
    [self performSelectorOnMainThread:@selector(read_success) withObject:nil waitUntilDone:NO];
}
- (void)read_success
{
    [self.curReadFile setEnLoadResult:kFileLoadResult_Success];
    
    self.curStatus = BT_STATUS_WAITING_NONE;
    
    self.temReadFile = nil;
    self.temReadFile = self.curReadFile;
    
    self.curReadFile = nil;
    
    [self clearDataPool];
    
    if([self.delegate respondsToSelector:@selector(readCompleteWithData:)]) {
        [self.delegate readCompleteWithData:self.temReadFile];
        
    }
}

- (void)readFailed
{
    [self performSelectorOnMainThread:@selector(read_failed) withObject:nil waitUntilDone:NO];
}

#pragma mark
- (void)read_failed
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //Read failure unified sending timeout error
    [self.curReadFile setEnLoadResult:kFileLoadResult_TimeOut];
    
    self.curStatus = BT_STATUS_WAITING_NONE;
    self.temReadFile = nil;
    self.temReadFile = self.curReadFile;
    self.curReadFile = nil;
    [self clearDataPool];
//    [self endRead];
    if([self.delegate respondsToSelector:@selector(readCompleteWithData:)]) {
        [self.delegate readCompleteWithData:self.temReadFile];
    }
}

/**
 * Read content
 */
- (void)readContent
{
    ReadContentPkg* pkg = [[ReadContentPkg alloc]initWithPkgNum:[_curReadFile curPkgNum]];
    if (pkg!=nil) {
        _curStatus = BT_STATUS_WAITING_READ_CONTENT_ACK;
        [self sendCmdWithData: [pkg buf] Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
    }
}

/**
 * End of reading
 */
- (void)endRead
{
    EndReadPkg *pkg = [[EndReadPkg alloc]init];
    if (pkg!=nil) {
        _curStatus = BT_STATUS_WAITING_END_READ_ACK;
        [self sendCmdWithData:[pkg buf] Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
    }
}

#pragma mark - Write file related
- (void)BeginWriteFile:(NSString *)fileName FileType:(U8)fileType andFileData:(NSData *)fileData
{
    _curReadFile = [[FileToRead alloc]initWithFileType:fileType];
    _curReadFile.fileName = fileName;
    _curReadFile.fileData = [fileData mutableCopy];
    if (_curReadFile.fileData==nil) {
        return;
    }
    _curReadFile.fileSize = _curReadFile.fileData.length;
    
    _curReadFile.lastPkgSize = _curReadFile.fileSize%WRITE_CONTENT_PKG_DATA_LENGTH;
    if (_curReadFile.lastPkgSize == 0) {//刚好整数包
        _curReadFile.totalPkgNum = _curReadFile.fileSize/WRITE_CONTENT_PKG_DATA_LENGTH;
        _curReadFile.lastPkgSize = WRITE_CONTENT_PKG_DATA_LENGTH + COMMON_PKG_LENGTH;
    }else{
        _curReadFile.totalPkgNum = _curReadFile.fileSize/WRITE_CONTENT_PKG_DATA_LENGTH + 1;
        _curReadFile.lastPkgSize += COMMON_PKG_LENGTH;
    }
    
    StartWritePkg* pkg;
    int delay;
    
    if (_curReadFile.fileType == FILE_Type_Lang_Patch) {   //Is a language pack
        pkg = [[StartWritePkg alloc]initWithFileName:fileName fileSize:_curReadFile.fileSize cmd:CMD_WORD_LANG_UPDATE_START];
        delay = TIMEOUT_CMD_PATCHS_RESPOND_MS;
    }else if (_curReadFile.fileType == FILE_Type_App_Patch) {
        //Is an app package
        pkg = [[StartWritePkg alloc]initWithFileName:fileName fileSize:_curReadFile.fileSize cmd:CMD_WORD_APP_UPDATE_START];
        delay = TIMEOUT_CMD_PATCHS_RESPOND_MS;
    }else{
        //Normal file
        pkg = [[StartWritePkg alloc]initWithFileName:fileName fileSize:_curReadFile.fileSize cmd:CMD_WORD_START_WRITE];
        delay = TIMEOUT_CMD_GENERAL_RESPOND_MS;
    }
    
    if (!pkg) {
        [self writeFailed];
        return;
    }
    _curStatus = BT_STATUS_WAITING_START_WRITE_ACK;
    
#pragma mark - Perform low-level read and write functions
    [self sendCmdWithData:[pkg buf] Delay:delay];
}

/**
 * Write content, checkme will call back after receiving the response packet. This method is equivalent to the receiving method in NSURLConnectionDelegate. It is executed dynamically
 */
-(void)writeContent
{
    NSData* tempData;
    if (_curReadFile.curPkgNum<_curReadFile.totalPkgNum-1) {//Not the last package
        NSRange range = {_curReadFile.curPkgNum*WRITE_CONTENT_PKG_DATA_LENGTH,WRITE_CONTENT_PKG_DATA_LENGTH};
        tempData = [_curReadFile.fileData subdataWithRange:(range)];
    }else if(_curReadFile.curPkgNum==_curReadFile.totalPkgNum-1){//Last pack
        NSRange range = {_curReadFile.curPkgNum*WRITE_CONTENT_PKG_DATA_LENGTH,_curReadFile.lastPkgSize - COMMON_PKG_LENGTH};
        tempData = [_curReadFile.fileData subdataWithRange:(range)];
    }else{//All finished
        [self endWrite];
        return;
    }
    
    WriteContentPkg* pkg;
    int delay;//Timeout period
    if (_curReadFile.fileType == FILE_Type_Lang_Patch) {
        //Is a language pack
        pkg = [[WriteContentPkg alloc]initWithBuf:tempData pkgNum:_curReadFile.curPkgNum cmd:CMD_WORD_LANG_UPDATE_DATA];
        delay = TIMEOUT_CMD_PATCHS_RESPOND_MS;
    }else if (_curReadFile.fileType == FILE_Type_App_Patch) {
        //Is an app package
        pkg = [[WriteContentPkg alloc]initWithBuf:tempData pkgNum:_curReadFile.curPkgNum cmd:CMD_WORD_APP_UPDATE_DATA];
        delay = TIMEOUT_CMD_PATCHS_RESPOND_MS;
    }else{
        //Normal file
        pkg = [[WriteContentPkg alloc]initWithBuf:tempData pkgNum:_curReadFile.curPkgNum cmd:CMD_WORD_WRITE_CONTENT];
        delay = TIMEOUT_CMD_GENERAL_RESPOND_MS;
    }
    
    if (!pkg) {
        [self writeFailed];//Write failure handling
        return;
    }
    
#pragma mark - Send notification for downloading interface update write progress bar data
    [self.delegate postCurrentWriteProgress:_curReadFile];
    
    _curReadFile.curPkgNum ++;
    _curStatus = BT_STATUS_WAITING_WRITE_CONTENT_ACK;
    _preSendBuf = [pkg buf];//For retransmission
    [self sendCmdWithData:[pkg buf] Delay:delay];
}

/**
 * Send write end command
 */
-(void)endWrite
{
    EndWritePkg* pkg;
    
    if (_curReadFile.curPkgNum == _curReadFile.totalPkgNum) { //If it's all done
        if (_curReadFile.fileType == FILE_Type_Lang_Patch) { //If it is a language pack
            pkg = [[EndWritePkg alloc]initWithCmd:CMD_WORD_LANG_UPDATE_END];
        }else if (_curReadFile.fileType == FILE_Type_App_Patch) { //If it is an app package
            [self writeSuccess];
            pkg = [[EndWritePkg alloc]initWithCmd:CMD_WORD_APP_UPDATE_END];
        }else{ //If it is a normal file
            pkg = [[EndWritePkg alloc]initWithCmd:CMD_WORD_END_WRITE];
        }
    } else { //If not finished
        [self writeFailed];
//        _currentPeripheral = nil;
        self.peripheral = nil;
        
        return;
    }
    
    _curStatus = BT_STATUS_WAITING_END_WRITE_ACK;
    
    [self sendCmdWithData:[pkg buf] Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}

- (void)writeSuccess
{
    //Send success message
    self.curStatus = BT_STATUS_WAITING_NONE;
    [self clearDataPool];
    if([self.delegate respondsToSelector:@selector(writeSuccessWithData:)]) {
        [self.delegate writeSuccessWithData:self.curReadFile];
    }
}

- (void)writeFailed
{
    self.curReadFile = nil;
    self.curStatus = BT_STATUS_WAITING_NONE;
    [self clearDataPool];
    if([self.delegate respondsToSelector:@selector(writeFailedWithData:)]) {
         //Send failure message
        [self.delegate writeFailedWithData:self.curReadFile];
    }
}


#pragma mark - Get device information related
- (void) BeginGetInfo
{
    InformationPkg *pkg = [[InformationPkg alloc]init];
    _curStatus = BT_STATUS_WAITING_GET_INFO_ACK;     // 9
    [self sendCmdWithData:pkg.buf Delay:TIMEOUT_CMD_GENERAL_RESPOND_MS];
}


#pragma mark - Low-level read and write functions
//Communication between the central equipment and peripherals through NSData type data communication   cmd
-(void)sendCmdWithData:(NSData *)cmd Delay:(int)delay
{
    DLog(@"Perform low-level read and write functions");
    [self clearDataPool];
#ifndef BUF_LENGTH
#define BUF_LENGTH 20
#endif
    for (int i=0; i*BUF_LENGTH<cmd.length; i++) {
        NSRange range = {i*BUF_LENGTH,((i+1)*BUF_LENGTH)<cmd.length?BUF_LENGTH:cmd.length-i*BUF_LENGTH};
        NSData* subCMD = [cmd subdataWithRange:range];
        
        //Write data
        if (self.peripheral.state==CBPeripheralStateConnected) {
            //Write characteristic value
            [self.peripheral writeValue:subCMD forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(cmdTimeout) withObject:nil afterDelay:delay/1000.0];
}

-(void)cmdTimeout
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    //Judging the current state
    if (_curStatus == BT_STATUS_WAITING_START_WRITE_ACK || _curStatus == BT_STATUS_WAITING_WRITE_CONTENT_ACK || _curStatus == BT_STATUS_WAITING_END_WRITE_ACK) {
        
        self.curStatus = BT_STATUS_WAITING_NONE;
        [self writeFailed];
        
    }else if (_curStatus == BT_STATUS_WAITING_START_READ_ACK || _curStatus == BT_STATUS_WAITING_READ_CONTENT_ACK || _curStatus == BT_STATUS_WAITING_END_READ_ACK) {
        
        self.curStatus = BT_STATUS_WAITING_NONE;
        [self readFailed];
    }else if (_curStatus == BT_STATUS_WAITING_PING_ACK) {
        
        self.curStatus = BT_STATUS_WAITING_NONE;
        if([self.delegate respondsToSelector:@selector(pingFailed)]) {
            [self.delegate pingFailed];
        }
        
#warning sphygmomanometer
    }else if(_curStatus == BT_STATUS_WAITING_RESET_ACK || _curStatus == BT_STATUS_WAITING_Restorefactory_Setting_ACK){
        
        //No return value
        _curStatus = BT_STATUS_WAITING_NONE;
        return;
    
    }else if (_curStatus == BT_STATUS_WAITING_FactoryConfig_Setting_ACK){
    
        _curStatus = BT_STATUS_WAITING_NONE;
        if ([self.delegate respondsToSelector:@selector(setFactoryConfigFailed)]) {
            
            [self.delegate setFactoryConfigFailed];
        }
        return;
        
    }else if (_curStatus == BT_STATUS_WAITING_Time_Setting_ACK){
        
        _curStatus = BT_STATUS_WAITING_NONE;
        if ([self.delegate respondsToSelector:@selector(setTimeFailed)]) {
            
            [self.delegate setTimeFailed];
        }
        return;
        
    }else if (_curStatus == BT_STATUS_WAITING_GET_Temp_ACK){
        
        _curStatus = BT_STATUS_WAITING_NONE;
        if ([self.delegate respondsToSelector:@selector(getDeviceTempFailed)]) {
            
            [self.delegate getDeviceTempFailed];
        }
        return;
        
    }else if (_curStatus == BT_STATUS_WAITING_GET_Configuartion_ACK){
        
        DLog(@"Failed to obtain configuration information：0x00 -- time out");
        _curStatus = BT_STATUS_WAITING_NONE;
        if ([self.delegate respondsToSelector:@selector(getConfiguartionFailed)]) {
            
            [self.delegate getConfiguartionFailed];
        }
        return;
        
    }else if (_curStatus == BT_STATUS_WAITING_SET_CalibrationZero_ACK){
        
        _curStatus = BT_STATUS_WAITING_NONE;
        if ([self.delegate respondsToSelector:@selector(setCalibrationZeroFailed)]) {
            
            [self.delegate setCalibrationZeroFailed];
        }
        return;
        
    }else if (_curStatus == BT_STATUS_WAITING_SET_CalibrationSlope_ACK){
        
        _curStatus = BT_STATUS_WAITING_NONE;
        if ([self.delegate respondsToSelector:@selector(setCalibrationSlopeFailed)]) {
            
            [self.delegate setCalibrationSlopeFailed];
        }
        return;
        
    }else if (_curStatus == BT_STATUS_WAITING_SET_StopPressure_ACK){
        
        _curStatus = BT_STATUS_WAITING_NONE;
        if ([self.delegate respondsToSelector:@selector(setStopPressureFailed)]) {
            
            [self.delegate setStopPressureFailed];
        }
        return;
        
    }else if (_curStatus == BT_STATUS_WAITING_START_Measure_ACK){
        
        _curStatus = BT_STATUS_WAITING_NONE;
        if ([self.delegate respondsToSelector:@selector(startMeasureFailed)]) {
            
            [self.delegate startMeasureFailed];
        }
        return;
        
    }else if (_curStatus == BT_STATUS_WAITING_END_Measure_ACK){
        
        _curStatus = BT_STATUS_WAITING_NONE;
        if ([self.delegate respondsToSelector:@selector(endMeasureFailed)]) {
            
            [self.delegate endMeasureFailed];
        }
        return;
        
    }else {
        
        [self writeFailed];//warning
    }
}

/**
 * Data received
 */
-(void)didReceiveData:(NSData *)data
{
       if(data.length > 0)
    {
        [self addDataToPool:data];
    }
}

-(void)addDataToPool:(NSData *)data
{
    [_dataPool appendData:data];
    U8 *tempBuf = (U8*)_dataPool.bytes;
    if(tempBuf[0] != 0xA5){
    
        [self clearDataPool];
        return;
    }

    unsigned long dataLen = _dataPool.length;

    if(dataLen<[self lenthPck:_dataPool]){  //The data length of the Bluetooth data pool is less than the length of the response packet
        return;
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self processAckBuf:_dataPool];
        [self clearDataPool];
    }
    
}

- (U32)lenthPck:(NSData *)data
{
    U32 length;
    U8 *tempBuf = (U8*)data.bytes;
    if(tempBuf[2] == 0x02){
     //Answer mode
        length = 1;
    }else if (tempBuf[2] == 0x00){
      //No need to resend
        int lenth = tempBuf;
         U32 _fileSize = *((U32 *)&tempBuf[4]);
         if (_fileSize & (1 << 31)) {
         
         }
        _fileSize &= ~(1 << 31);
        length = (_fileSize / (512 - 8) + 1)*8 + _fileSize;

    }else if (tempBuf[2] == 0x001){
      //Need to resend
        length = 0;
    }

    return length;
}

-(void)clearDataPool
{
//DLog(@"clear data pool！");
    [_dataPool setLength:0];
}

-(U32)calWantBytes    //Get the length of the response packet
{
    switch (_curStatus) {
        case BT_STATUS_WAITING_START_READ_ACK:
            return COMMON_ACK_PKG_LENGTH;
            
        case BT_STATUS_WAITING_READ_CONTENT_ACK:
            if (_curReadFile.curPkgNum==_curReadFile.totalPkgNum-1) {
                return _curReadFile.lastPkgSize;
            }else{
                return READ_CONTENT_ACK_PKG_FRONT_LENGTH + READ_CONTENT_ACK_DATA_LENGTH;
            }
            
        case BT_STATUS_WAITING_END_READ_ACK:
            return COMMON_ACK_PKG_LENGTH;
        case BT_STATUS_WAITING_START_WRITE_ACK:
            return COMMON_ACK_PKG_LENGTH;
        case BT_STATUS_WAITING_WRITE_CONTENT_ACK:
            return COMMON_ACK_PKG_LENGTH;
        case BT_STATUS_WAITING_END_WRITE_ACK:
            return COMMON_ACK_PKG_LENGTH;
        case BT_STATUS_WAITING_GET_INFO_ACK:
            return GET_INFO_ACK_PKG_LENGTH;
        case BT_STATUS_WAITING_UPDATA_TIME_ACK:
            return UPData_TIME_ACK_PKG_LENGTH;
        default:
            return 0;
    }
}

#pragma mark - checkme Response packet
-(void)processAckBuf:(NSData*)buf
{
    unsigned char *bytes = (unsigned char *)buf.bytes;
    U8 *p = bytes;

    if(p[3] == BT_STATUS_WAITING_PING_ACK){

    }else if (p[3] == BT_STATUS_WAITING_START_READ_ACK){
        
        DLog(@"Read start response packet received");
        StartReadAckPkg *srap = [[StartReadAckPkg alloc] initWithBuf:buf];
        if (srap!=nil&&[srap cmdWord] == ACK_CMD_OK) {
            if ([srap fileSize]<=0) {
                DLog(@"File size error, stop reading");
                [self endRead];
            }else{
                [self setCurReadFileVals: [srap fileSize]];
                [self readContent];
            }
        }else{
            [self readFailed];
        }
        
    }else if (p[3] == BT_STATUS_WAITING_READ_CONTENT_ACK){
        
        DLog(@"Received read content response packet");
        ReadContentAckPkg *rcap = [[ReadContentAckPkg alloc]initWithBuf:buf];
        if (rcap!=nil) {
            //Append to the end of the current file
            [_curReadFile.fileData appendData:[rcap dataBuf]];
            _curReadFile.curPkgNum ++;
            
#pragma mark - Reading content progress bar update, such as downloading detailed data from checkme, will use the download progress
            //             [self.delegate postCurrentReadProgress:(double)_curReadFile.curPkgNum/(double)_curReadFile.totalPkgNum];
            
            if([self.delegate respondsToSelector:@selector(postCurrentReadProgress:)]) {
                
                [self.delegate postCurrentReadProgress:(double)_curReadFile.curPkgNum/(double)_curReadFile.totalPkgNum];
            }
            
            if (_curReadFile.curPkgNum == _curReadFile.totalPkgNum) {//I have read the last package
                [self endRead];
            }else{
                [self readContent];
            }
        }else{
            [self readFailed];
        }
        
    }else if(p[3] == BT_STATUS_WAITING_END_READ_ACK){
        
        DLog(@"Receive read end response packet");
        
    }else if(p[3] == BT_STATUS_WAITING_START_WRITE_ACK){
        
        DLog(@"Received write start response packet");
        
    }else if(p[3] == BT_STATUS_WAITING_WRITE_CONTENT_ACK){
        
        DLog(@"Received the write content response packet");
        
    }else if(p[3] == BT_STATUS_WAITING_END_WRITE_ACK){
        
        DLog(@"Receive write end response packet");
        
    }else if(p[3] == BT_STATUS_WAITING_GET_INFO_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            //DLog(@"Reading device information is complete");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(getInfoSuccessWithData:)]) {
                [self.delegate getInfoSuccessWithData:giap.infoData];
            }
        }else{
            //DLog(@"Error reading device information");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            
            if([self.delegate respondsToSelector:@selector(getInfoFailed)]) {
                
                [self.delegate getInfoFailed];
            }
        }
        
    }else if(p[3] == BT_STATUS_WAITING_Time_Setting_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Set time is complete");
            self.curStatus = BT_STATUS_WAITING_NONE;
            unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            U8 *p = bytes;
            if (p[0] == 0x00) {
                if([self.delegate respondsToSelector:@selector(setTimeSuccess)]) {
                    
                    [self.delegate setTimeSuccess];
                }
            }else{
                DLog(@"Wrong setting time");
                if([self.delegate respondsToSelector:@selector(setTimeFailed)]) {
                    
                    [self.delegate setTimeFailed];
                }
            }
        }else{
            DLog(@"Wrong setting time");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            
            if([self.delegate respondsToSelector:@selector(setTimeFailed)]) {
                
                [self.delegate setTimeFailed];
            }
        }
        DLog(@"The response package related to the completion of the set time has been completed!");
        
    }else if(p[3] == BT_STATUS_WAITING_GET_FILELIST_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Reading the file list is complete");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(getInfoSuccessWithData:)]) {
                
                [self.delegate getInfoSuccessWithData:giap.infoData];
            }
        }else{
            DLog(@"Error reading file list");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(getInfoFailed)]) {
                
                [self.delegate getInfoFailed];
            }
        }
        DLog(@"The response package related to reading the device information has been completed!");
        
     }else if(p[3] == BT_STATUS_WAITING_Battery_Status_ACK){
         
        CommonlyPkg *giap = [[CommonlyPkg alloc] initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Reading to get battery status completed");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(getBatteryStatusSuccessWithData:)]) {
                [self.delegate getBatteryStatusSuccessWithData:giap.infoData];
            }
        }else{
            DLog(@"Reading to get battery status error");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(getInfoFailed)]) {
                [self.delegate getBatteryStatusFailed];
            }
        }
        DLog(@"Retrieving the response package related to the battery status is complete!");
         
    }else if(p[3] == BT_STATUS_WAITING_FactoryConfig_Setting_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Completion of burning factory information");
            self.curStatus = BT_STATUS_WAITING_NONE;
            unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            U8 *p = bytes;
            if (p[0] == 0x00) {
                if([self.delegate respondsToSelector:@selector(setFactoryConfigSuccess)]) {
                    
                    [self.delegate setFactoryConfigSuccess];
                }
            }else{
                DLog(@"Programming factory information error");
                if([self.delegate respondsToSelector:@selector(setFactoryConfigFailed)]) {
                    [self.delegate setFactoryConfigFailed];
                }
            }
        }else{
            DLog(@"Programming factory information error");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(setFactoryConfigFailed)]) {
                [self.delegate setFactoryConfigFailed];
            }
        }
        DLog(@"The response package related to burning the factory information has been completed!");
        
    }else if(p[3] == BT_STATUS_WAITING_GET_Temp_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Acquiring the host temperature is complete");
            self.curStatus = BT_STATUS_WAITING_NONE;
            unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            U8 *p = bytes;
            if (p[0] == 0x00) {
                if([self.delegate respondsToSelector:@selector(getDeviceTempSuccessWithData:)]) {
                    
                    [self.delegate getDeviceTempSuccessWithData:giap.infoData];
                }
            }else{
                DLog(@"Get the host temperature error");
                if([self.delegate respondsToSelector:@selector(getDeviceTempFailed)]) {
                    
                    [self.delegate getDeviceTempFailed];
                }
                
            }
            
        }else{
            DLog(@"Get the host temperature error");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(getDeviceTempFailed)]) {
                [self.delegate setTimeFailed];
            }
        }
        DLog(@"Get the response package related to the host temperature is complete!");
        
    }else if(p[3] == BT_STATUS_WAITING_GET_Configuartion_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        DLog(@"Configuration information 0x00 giap：%@", giap);
        if (giap!=nil) {
            DLog(@"Get the configuration parameters complete");
            self.curStatus = BT_STATUS_WAITING_NONE;
            //                unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            if([self.delegate respondsToSelector:@selector(getConfiguartionSuccessWithData:)]) {
                [self.delegate getConfiguartionSuccessWithData:giap.infoData];
            }
        }else{
            DLog(@"Get setting configuration parameter error");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(getConfiguartionFailed)]) {
                [self.delegate getConfiguartionFailed];
            }
        }
        DLog(@"Get the response package related to the host temperature is complete!");
        
    }else if(p[3] == BT_STATUS_WAITING_SET_CalibrationZero_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            //DLog(@"Set zero calibration completed");
            self.curStatus = BT_STATUS_WAITING_NONE;
            //                unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            if([self.delegate respondsToSelector:@selector(setCalibrationZeroSuccessWithData:)]) {
                
                [self.delegate setCalibrationZeroSuccessWithData:giap.infoData];
            }
        }else{
            DLog(@"Set zero calibration error");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(setCalibrationZeroFailed)]) {
                [self.delegate setCalibrationZeroFailed];
            }
        }
        DLog(@"The response package related to zero calibration has been completed!");
        
    }else if(p[3] == BT_STATUS_WAITING_SET_CalibrationSlope_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Setup calibration is complete");
            self.curStatus = BT_STATUS_WAITING_NONE;
            //                unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            if([self.delegate respondsToSelector:@selector(setCalibrationSlopeSuccessWithData:)]) {
                [self.delegate setCalibrationSlopeSuccessWithData:giap.infoData];
            }
        }else{
            DLog(@"Setup calibration error");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(setCalibrationSlopeFailed)]) {
                [self.delegate setCalibrationSlopeFailed];
            }
        }
        DLog(@"The response package related to the calibration has been set!");
        
    }else if(p[3] == BT_STATUS_WAITING_SET_StopPressure_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Set stop pumping pressure value completed");
            self.curStatus = BT_STATUS_WAITING_NONE;
            //  unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            if([self.delegate respondsToSelector:@selector(setStopPressureSuccess)]) {
                [self.delegate setStopPressureSuccess];
            }
        }else{
            DLog(@"Wrong setting stop pumping pressure value");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(setStopPressureFailed)]) {
                [self.delegate setStopPressureFailed];
            }
        }
        DLog(@"The response package related to setting the stop pumping pressure value has been completed!");
        
    }else if(p[3] == BT_STATUS_WAITING_START_Measure_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Start measurement completed");
            self.curStatus = BT_STATUS_WAITING_NONE;
            //                unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            if([self.delegate respondsToSelector:@selector(startMeasureSuccessWithData:)]) {
                
                [self.delegate startMeasureSuccessWithData:giap.infoData];
            }
        }else{
            DLog(@"Start measurement error");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(startMeasureFailed)]) {
                [self.delegate startMeasureFailed];
            }
        }
        DLog(@"The response package related to start measurement is complete!");
        
    }else if(p[3] == BT_STATUS_WAITING_END_Measure_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Stop measurement completed 0x05");
            self.curStatus = BT_STATUS_WAITING_NONE;
            //                unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            if([self.delegate respondsToSelector:@selector(endMeasureSuccess)]) {
                [self.delegate endMeasureSuccess];
            }
        }else{
            DLog(@"Stop measurement error");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(endMeasureFailed)]) {
                [self.delegate endMeasureFailed];
            }
        }
        DLog(@"The response package related to stop measurement is complete!");
        
    }else if(p[3] == BT_STATUS_WAITING_Current_Running_Status_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Stop pumping up and finish");
            if (_curStatus == BT_STATUS_WAITING_END_Measure_ACK) {
                self.curStatus = BT_STATUS_WAITING_NONE;
                if([self.delegate respondsToSelector:@selector(endMeasureSuccess)]) {
                    [self.delegate endMeasureSuccess];
                }
            }
            else
            {
                DLog(@"Deflation -- 0x06, BT_STATUS_WAITING_NONE");
                self.curStatus = BT_STATUS_WAITING_NONE;
                if([self.delegate respondsToSelector:@selector(stopPlayResult_WithData:)]) {
                    [self.delegate stopPlayResult_WithData:giap.infoData];
                }
            }
        }
        DLog(@"Stop pumping up to complete the related response package is complete!");
        
    }else if(p[3] == BT_STATUS_WAITING_Measure_Result_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"The measurement result (the host takes the initiative to send when the measurement is over) completed -- 0x07 ");
            self.curStatus = BT_STATUS_WAITING_NONE;
            //                unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            if([self.delegate respondsToSelector:@selector(getMeasureResult_WithData:)]) {
                [self.delegate getMeasureResult_WithData:giap.infoData];
            }
        }
        DLog(@"The response packet related to the measurement result (sent by the host actively at the end of the measurement) has been completed!");
        
    }else if(p[3] == BT_STATUS_WAITING_Engineering_Start_Measurement_ACK){
        
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            DLog(@"Acquire real-time pressure value (non-measurement mode) completed");
            self.curStatus = BT_STATUS_WAITING_NONE;
            //                unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            if([self.delegate respondsToSelector:@selector(getRealTimePressure_WithData:)]) {
                [self.delegate getRealTimePressure_WithData:giap.infoData];
            }
        }
        DLog(@"Acquiring real-time pressure value (non-measurement mode) response package is complete!");
        
    } else if(p[3] == BT_STATUS_WAITING_Buzzer_Witch_ACK) {
        
        DLog(@"Buzzer switch");
        CommonlyPkg *giap = [[CommonlyPkg alloc]initWithBuf:buf];
        if (giap!=nil) {
            
            DLog(@"Buzzer switch switch completed");
            self.curStatus = BT_STATUS_WAITING_NONE;
            //                unsigned char *bytes = (unsigned char *)giap.infoData.bytes;
            if([self.delegate respondsToSelector:@selector(voiceControlSetSuccess)]) {
                
                [self.delegate voiceControlSetSuccess];
            }
        }else{
            DLog(@"Buzzer switch failed");
            self.curStatus = BT_STATUS_WAITING_NONE;      // 0
            if([self.delegate respondsToSelector:@selector(voiceControlSetFailed)]) {
                [self.delegate voiceControlSetFailed];
            }
        }
        
    }
}

-(void)setCurReadFileVals:(U32)fileSize
{
    DLog(@"Get the relevant properties of _curReadFile");
    if (!_curReadFile) {
        [self readFailed];
        return;
    }
    if(fileSize<=0){
        return;
    }
    _curReadFile.fileData = [NSMutableData data];
    _curReadFile.curPkgNum = 0;
    _curReadFile.fileSize = fileSize;
    _curReadFile.lastPkgSize = fileSize%READ_CONTENT_ACK_DATA_LENGTH;
    if (_curReadFile.lastPkgSize == 0) {//Just integer package
        _curReadFile.totalPkgNum = fileSize/READ_CONTENT_ACK_DATA_LENGTH;
        _curReadFile.lastPkgSize = READ_CONTENT_ACK_DATA_LENGTH + READ_CONTENT_ACK_PKG_FRONT_LENGTH;
    }else{
        _curReadFile.totalPkgNum = fileSize/READ_CONTENT_ACK_DATA_LENGTH + 1;
        _curReadFile.lastPkgSize += READ_CONTENT_ACK_PKG_FRONT_LENGTH;
    }
}

-(BOOL)bLoadingFileNow
{
    return  self.curReadFile != nil;
}

-(FileType_t)curLoadFileType
{
    if(![self bLoadingFileNow])
    {
        return  FILE_Type_None;
    } else
        return _curReadFile.fileType;
}
@end


@implementation FileToRead

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/**
 * Incoming different file types, which can be ordinary files or upgrade packages
 */
- (instancetype)initWithFileType:(U8)fileType
{
    self = [super init];
    if (self) {
        _fileType = fileType;
    }
    return self;
}

+(NSString *)descOfFileType:(FileType_t)kind
{
    NSString *desc = @"";
    switch (kind) {
        case FILE_Type_None:
            desc = @"None";
            break;
        case FILE_Type_UserList:
            desc = @"User list file";
            break;
        case FILE_Type_EcgList:
            desc = @"ECG file list";
            break;
        case FILE_Type_EcgDetailData:
            desc = @"ECG data files";
            break;
        default:
            break;
    }
    return desc;
}

-(NSString *)loadStateDesc
{
    //    NSString *fileDesc = [FileToRead descOfFileType:_fileType];
    NSString *result = @"";
    switch (_enLoadResult) {
        case kFileLoadResult_Fail:
            result = @"Data load failed";
            break;
        case kFileLoadResult_Success:
            result = @"Data load success";
            break;
        case kFileLoadResult_TimeOut:
            result = @"Data load timeout";
            break;
        case kFileLoadResult_NotExist:
            result = @"Data is not exist";
            break;
        default:
            break;
    }
    
    NSString *desc = [NSString stringWithFormat:@"%@",result];
    return desc;
}
@end
