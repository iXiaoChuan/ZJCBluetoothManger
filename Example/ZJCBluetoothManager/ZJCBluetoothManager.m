//
//  ZJCBluetoothManager.m
//  ZJCBluetoothManager_Example
//
//  Created by 小川 on 2017/12/4.
//  Copyright © 2017年 xiaochuan171090331@outlook.com. All rights reserved.
//

#import "ZJCBluetoothManager.h"

@interface ZJCBluetoothManager () <CBPeripheralDelegate,CBCentralManagerDelegate,CBPeripheralManagerDelegate>

/** 扫描成功的回调 */
@property (copy  , nonatomic) ZJCScanPeripheralSuccess scanPeripheralSuccess;
/** 扫描失败的回调 */
@property (copy  , nonatomic) ZJCScanPeripheralError scanPeripheralError;
/** 链接完成的回调 */
@property (copy  , nonatomic) ZJCConnectCompletion connectCompletion;

/** 中心管理器 */
@property (strong, nonatomic) CBCentralManager * centralManager;
/** 当前链接的外设 */
@property (strong, nonatomic) CBPeripheral * currentConnectedPeripheral;
/** 可写的特征 */
@property (strong, nonatomic) NSMutableArray * writerlyCharacteristic;
/** 写入次数 */
@property (assign, nonatomic) NSInteger writeCount;
/** 返回次数 */
@property (assign, nonatomic) NSInteger responseCount;

/** 默认扫描时间 */
@property (assign, nonatomic) NSTimeInterval defaultTimeout;
/** 自动链接标志 */
@property (assign, nonatomic) BOOL autoConnect;

@end

static ZJCBluetoothManager * instance = nil;

@implementation ZJCBluetoothManager
#pragma mark shared instance
+ (instancetype)sharedInstance{
    return [[self alloc] init];
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
        // init instance
        instance.scandPeripherals = [NSMutableArray array];
        instance.writerlyCharacteristic = [NSMutableArray array];
        instance.defaultTimeout = 20;
        [instance resetManager];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (id)copyWithZone:(struct _NSZone *)zone{
    return instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return instance;
}

#pragma mark - Common method
+ (NSString *)UUIDForLastConnetedPeripheral{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *UUIDString = [userDefaults objectForKey:kUUIDForLastConnetedPeripheralKey];
    return UUIDString;
}

- (void)setDefaultTimeout:(NSTimeInterval)defaultTimeout{
    _defaultTimeout = defaultTimeout;
    if (_defaultTimeout>0) {
        [self performSelector:@selector(timeoutFunction) withObject:nil afterDelay:defaultTimeout];
    }
}

- (void)timeoutFunction{
    [_centralManager stopScan];
}

#pragma mark - CBPeripheralDelegate



#pragma mark  CBCentralManagerDelegate



#pragma mark  CBPeripheralManagerDelegate


#pragma mark - layzLoad
- (void)resetManager{
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{}];  /**< 参数1:状态回调的代理  参数2:执行的线程,默认主线程  参数3:需要执行的操作 */
}

@end
