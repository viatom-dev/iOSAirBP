//
//  ViewController.m
//  AirBP-Demo
//
//  Created by anwu on 2021/3/24.
//

#import "VTViewController.h"
#import "BTUtils.h"
#import "VTNoticeName.h"
#import "VTDeviceInfo.h"
#import "VTFileParser.h"

@interface VTViewController ()<UITableViewDelegate,UITableViewDataSource,BTCommunicationDelegate>

/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *table;

/** peripheral array */
@property (nonatomic,retain) NSMutableArray *arrFindPeripheral;

/** get device info identifier */
@property (nonatomic, assign) BOOL isGetDevInfo;

/** Whether to get the battery status */
@property (nonatomic, assign) BOOL hasGetBatteryStatus;

@end

@implementation VTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self start];
    [self addNotificationObserver];
}

/**
 *  @brief start
 **/
- (void)start
{
    [self startScan];
}

/**
 *  @brief Start scanning
 **/
-(void)startScan
{
    [[BTUtils GetInstance] openBT];
}

/**
 *  @brief Notification subscription
 **/
-(void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBLPowerOnNtf:) name:NtfName_BTPowerOn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFindPeripheralNtf:) name:NtfName_FindAPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onConnectCheckmeSuccessNtf) name:NtfName_ConnectPeriphralSuccess object:nil];
    
    [BTCommunication sharedInstance].delegate = self;
}

#pragma mark UITableVieDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrFindPeripheral.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NoteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.textColor = [UIColor grayColor];
    CBPeripheral *peripheral = self.arrFindPeripheral[indexPath.row];
    cell.textLabel.text = peripheral.name;
    [cell.contentView setBackgroundColor:Di_Color_Back];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabel.text = @"connecting...";
    CBPeripheral *peripheral = self.arrFindPeripheral[indexPath.row];
    [[BTUtils GetInstance] connectToPeripheral:peripheral];
}

#pragma mark Notification
-(void)onConnectCheckmeSuccessNtf
{
    DLog(@"onConnectCheckmeSuccessNtf");
//    [[BTCommunication sharedInstance] BeginGetInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BTCommunication sharedInstance] BeginGetInfo];
    });
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!weakSelf.isGetDevInfo) {
            [[BTCommunication sharedInstance] BeginGetInfo];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (!weakSelf.isGetDevInfo) {
                    [[BTCommunication sharedInstance] BeginGetInfo];
                }
            });
        }
    });
}

-(void)onFindPeripheralNtf:(NSNotification *)ntf
{
    NSDictionary *usrInfo  = [ntf userInfo];
    
    CBPeripheral *periphral = [usrInfo objectForKey:Key_FindAPeripheral_Content];
    NSString *BLEname =  usrInfo[@"BLEName"];
    if(BLEname && ![BLEname isKindOfClass:[NSNull class]]&& ![BLEname isEqualToString:@""] && ![periphral.name isEqualToString:BLEname])
    {
        [periphral setValue:BLEname forKey:@"name"];
    }
    if ([periphral.name hasPrefix:@"AirBP"] || [periphral.name hasPrefix:@"SmartBP"]){
        [self addPeripheralForChoice:periphral];
    };
}

- (void)onBLPowerOnNtf:(NSNotification *)ntf
{
    _arrFindPeripheral = [NSMutableArray array];
    [[BTUtils GetInstance] beginScan];
}

-(void)addPeripheralForChoice:(CBPeripheral *)periphral
{
    if (periphral && ![_arrFindPeripheral containsObject:periphral]) {
        [_arrFindPeripheral addObject:periphral];
        
        [self.table reloadData];
    }
}

#pragma mark BTCommunicationDelegate
- (void)getInfoSuccessWithData:(NSData *)data {
    _isGetDevInfo = YES;
//    VTDeviceInfo *info = [VTFileParser parseDeviceInfo_WithFileData:data];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self performSegueWithIdentifier:@"conectSuccess" sender:nil];
}


@end
