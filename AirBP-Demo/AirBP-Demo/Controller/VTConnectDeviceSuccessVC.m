//
//  ViewController.m
//  AirBP-Demo
//
//  Created by anwu on 2021/3/24.
//

#import "VTConnectDeviceSuccessVC.h"
#import "BTUtils.h"
#import "VTNoticeName.h"
#import "VTDeviceInfo.h"
#import "VTFileParser.h"
#import "VTCommon.h"
#import "VTDrawView.h"

@interface VTConnectDeviceSuccessVC ()<UITableViewDelegate,BTCommunicationDelegate>

/*!
 @property
 @brief find peripheral array
 */
@property (nonatomic,retain) NSMutableArray *arrFindPeripheral;
/*!
 @property
 @brief mmhg value Label
 */
@property (weak, nonatomic) IBOutlet UILabel *mmhgLabel;
/*!
 @property
 @brief battery percent Label
 */
@property (weak, nonatomic) IBOutlet UILabel *batteryPercentLabel;
/*!
 @property
 @brief sys And Dia Value Label
 */
@property (weak, nonatomic) IBOutlet UILabel *sysAndDiaValue;
/*!
 @property
 @brief bpm Value Label
 */
@property (weak, nonatomic) IBOutlet UILabel *bpmValue;
/*!
 @property
 @brief pp Value Label
 */
@property (weak, nonatomic) IBOutlet UILabel *ppValue;
/*!
 @property
 @brief map Value Label
 */
@property (weak, nonatomic) IBOutlet UILabel *mapValue;
/*!
 @property
 @brief pulse Wave View
 */
@property (weak, nonatomic) IBOutlet UIView *pulseWaveView;
/*!
 @property
 @brief beep Switch
 */
@property (weak, nonatomic) IBOutlet UISwitch *beepSwitch;
/*!
 @property
 @brief battery Status Label
 */
@property (weak, nonatomic) IBOutlet UILabel *batteryStatusLabel;
/*!
 @property
 @brief isGetDevInfo
 */
@property (nonatomic, assign) BOOL isGetDevInfo;
/*!
 @property
 @brief has Get Battery Status
 */
@property (nonatomic, assign) BOOL hasGetBatteryStatus;
/*!
 @property
 @brief pulse Value
 */
@property (nonatomic, assign) int pulseValue;
/*!
 @property
 @brief src
 */
@property (nonatomic, assign) BOOL src;
/*!
 @property
 @brief draw View
 */
@property (nonatomic,strong) VTDrawView *drawView;


@end

@implementation VTConnectDeviceSuccessVC
/**
 *  @brief init
 **/
- (VTDrawView *)drawView{
    
    if (!_drawView) {
        _drawView = [[VTDrawView alloc] initWithFrame:CGRectMake(10, 10, 300, 230)];
        [self.pulseWaveView addSubview:_drawView];
    }

    return _drawView;
}

/**
 *  @brief action
 **/
- (IBAction)beepSwitchAction:(UISwitch *)sender {
    //Only AirBP has beep
    if ([[BTCommunication sharedInstance].peripheral.name hasPrefix:@"AirBP"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (self.beepSwitch.on) {
            [[BTCommunication sharedInstance] controlVoiceWithType:kVoice_Open];
        }
        else {
            [[BTCommunication sharedInstance] controlVoiceWithType:kVoice_Close];
        }
    } else {
        return;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self initInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // get Configuartion
    [[BTCommunication sharedInstance] getConfiguartion];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/**
 *  @brief Get battery status
 **/
- (void)fetchBatteryStatus {
    __weak typeof(self) weakSelf = self;
    _hasGetBatteryStatus = NO;
    [[BTCommunication sharedInstance] getBatteryStatus];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!weakSelf.hasGetBatteryStatus) {
            [[BTCommunication sharedInstance] getBatteryStatus];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (!weakSelf.hasGetBatteryStatus) {
                    [[BTCommunication sharedInstance] getBatteryStatus];
                }
            });
        }
    });
}

#pragma mark notification method
- (void)voiceControlSetSuccess {
    [self notiSetBeepSuccess];
}

- (void)voiceControlSetFailed {
    [self notiSetBeepFailed];
}

- (void)notiSetBeepSuccess {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    DLog(@"The Beep switch is set successfully -- ");
}

- (void)notiSetBeepFailed {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    DLog(@"Beep switch setting failed -- ");
    self.beepSwitch.on = !self.beepSwitch.on;
}

#pragma mark - Obtain device information and initialize each View
- (void)initInfo{
    [BTCommunication sharedInstance].delegate = self;
    [[BTCommunication sharedInstance] BeginGetInfo];
}

#pragma mark -- BTCommunicationDelegate
/**
 *  @brief Get device information successfully
 **/
- (void)getInfoSuccessWithData:(NSData *)data
{
    [self fetchBatteryStatus];
}

/**
 *  @brief Get battery information
 **/
- (void)getBatteryStatusSuccessWithData:(NSData *)data
{
    _hasGetBatteryStatus = YES;
    VTBatteryInfo *info = [VTFileParser parseBatteryInfo_WithFileData:data];
    
    self.batteryStatus = info.state;
    switch (self.batteryStatus) {
        case BatteryStatusNone:
        {
            self.batteryStatusLabel.text = @"Not charging";
        }
            break;
        case BatteryStatusCharging:
        {
            self.batteryStatusLabel.text = @"charging";
        }
            break;
        case BatteryStatusAll:
        {
            self.batteryStatusLabel.text = @"full";
        }
            break;
    }
        
    NSString *perr = [NSString stringWithFormat:@"%hhu",info.percent];
    self.batteryPercentLabel.text = [perr stringByAppendingFormat:@"%%"];
    
    [self beginMeasure];
    
    if (_batteryStatus == BatteryStatusNone) {
        [self fetchMonitorMeasureStatusWithAfterSecond:2];
    }
}

/**
 *  @brief Get results
 **/
- (void)getMeasureResult_WithData:(NSData *)data
{
    VTBloodPressureResultInfo *info = [VTFileParser parseBloodPressureResultInfo_WithFileData:data];
    [self setValueWithBP:info];
}

/**
 *  @brief Start measurement result
 **/
- (void)startMeasureSuccessWithData:(NSData *)data
{
    VTRealTimePressureInfo *info = [VTFileParser parseStartMeasureInfo_WithFileData:data];
    NSLog(@"Static pressure channel real-time pressure: %hi -- Pulse channel real-time pressure: %hi",info.pressure_static,info.pressure_pulse);
    self.pressureValue = info.pressure_static;
    self.pulseValue = info.pressure_pulse;
        
    int value = (int)self.pressureValue / 100;
    DLog(@"value: %d", value);
    
    if (_src) {
        [self getRealTimeDataArr];  // Draw pulse wave
    }
    
    NSString *valueStr;
    if (value > 300) {
        valueStr = @">300";
    }
    else if (value < 0)
    {
        valueStr = @"0";
    }
    else
    {
        valueStr = [NSString stringWithFormat:@"%d",value];
    }
    
    if ([valueStr isEqualToString:@"0"]) {
        
    }
    
    self.mmhgLabel.text = valueStr;
}

/**
 *  @brief Stop pumping up and get the status (Host actively sends)
 **/
- (void)stopPlayResult_WithData:(NSData *)data
{
    unsigned char *bytes = (unsigned char *)data.bytes;
    U8 *p = bytes;
    
    DLog(@"Obtained status information --- No comparison %hhu", p[0]);
    
    if(p[0] == 0){
        DLog(@"Get status -- 0 Inflated");
    } else if (p[0] == 1){
        DLog(@"Get status -- 1 Stop pumping up");
    }else if (p[0] == 2){
        DLog(@"Get status -- 2 Stop pumping up");
        _src = YES;
    }else if(p[0] == 3){
        DLog(@"Get status -- 3 ");
    }else if(p[0] == 4){
        DLog(@"Get status -- 4 Cheer up again ");
    }else if(p[0] == 5){
    }
    else if(p[0] == 0x12) {   // AirBP Plus - 18
        DLog(@"Get status -- 18 Deflating");
    }
    else if(p[0] == 12) {
        DLog(@"Overpressure debugging：Status is 12 ");
    }
}

/**
 *  @brief get Configuartion Success With Data (No screen version does not use configuration information)
 **/
- (void)getConfiguartionSuccessWithData:(NSData *)data {
    VTPlusConfigurationInfo *info = [VTFileParser parsePlusConfiguartionInfo_WithFileData:data];
    DLog(@"获取到配置信息 -- info: %@, beep_switch: %hhu", info, info.beep_switch);
    if (info.beep_switch == 1) {
        _beepSwitch.on = NO;
    }
    else {
        _beepSwitch.on = YES;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - other method
/**
 *  @brief set Value With BP
 **/
- (void)setValueWithBP:(VTBloodPressureResultInfo *)bpInfo
{
    self.drawView.hidden = YES;
    
    NSString *tempString = [NSString string];
    NSString *bpmString  = [NSString string];
    NSString *ppString = [NSString string];
    NSString *mapString = [NSString string];

    if ((bpInfo.state_code == 14 || bpInfo.state_code == 15 || bpInfo.state_code == 3)
        && bpInfo.systolic_pressure >= 60
        && bpInfo.systolic_pressure <= 230
        && bpInfo.diastolic_pressure >= 40
        && bpInfo.diastolic_pressure <= 130)
    {
        tempString = [NSString stringWithFormat:@"%hu/%hu",bpInfo.systolic_pressure,bpInfo.diastolic_pressure];
        bpmString  = [NSString stringWithFormat:@"%hu",bpInfo.pulse_rate];
        ppString = [NSString stringWithFormat:@"%d",bpInfo.systolic_pressure - bpInfo.diastolic_pressure];
        mapString = [NSString stringWithFormat:@"%hu",bpInfo.mean_pressure];
    }else
    {
        tempString = @"--/--";
        bpmString  = @"--";
        ppString = @"--";
        mapString = @"--";
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempString];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor lightGrayColor]
                             range:[tempString rangeOfString:@"/"]];
    self.sysAndDiaValue.attributedText = attributedString;
    self.bpmValue.text = bpmString;
    self.ppValue.text = ppString;
    self.mapValue.text = mapString;
}

/**
 *  @brief Draw pulse wave
 **/
- (void)getRealTimeDataArr{
    
    [self.drawView.realTimeDataArr addObject:@(self.pulseValue)];
    [self.drawView prepareToRefreshPW];
}

/**
 *  @brief Current status of the host
 **/
- (void)fetchMonitorMeasureStatusWithAfterSecond:(float)second {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BTCommunication sharedInstance] getMeasureStatus];
    });
}

/**
 *  @brief command
 **/
- (void)beginMeasure
{
    [[BTCommunication sharedInstance] startMeasureWithRate:0x14];//20ms
}

//- (void)endMeasureSuccess
//{
//    DLog(@"endMeasureSuccess");
//}
@end
