//
//  ViewController.h
//  AirBP-Demo
//
//  Created by anwu on 2021/3/24.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BatteryStatus) {
    BatteryStatusNone,// Not charging
    BatteryStatusCharging, // charging
    BatteryStatusAll, // full
};

typedef NS_ENUM(NSInteger, WorkSatus) {
    STATUS_DisConnect,// Bluetooth is not connected
    STATUS_Connect,  // Bluetooth connection
    STATUS_INFLATING, // Start cheering up
    STATUS_INFLATE_OK, // End cheering
    STATUS_DEFLAING, // Deflating
    STATUS_RESULT_OK,   // Get the result normal
    STATUS_RESULT_ERROE, // failure
};

@interface VTConnectDeviceSuccessVC : UIViewController
/*!
 @property
 @brief battery status
 */
@property (nonatomic, assign) BatteryStatus batteryStatus;

/*!
 @property
 @brief pressure value
 */
@property(nonatomic,assign) int  pressureValue;


@end

