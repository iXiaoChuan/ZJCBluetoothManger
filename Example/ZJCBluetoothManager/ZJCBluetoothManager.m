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

- (void)resetManager{
    /**
     *  蓝牙中心
     *
     *  @discussion 重置蓝牙中心
     *
     *  @param Delegate 状态回调
     *  @param queue    执行的线程,默认主线程
     *  @param options  需要执行的操作.  CBCentralManagerOptionShowPowerAlertKey: 一个默认No的Bool值,用来配置当蓝牙PowerOff的时候,是否需要给用户一个弹框.
     *                                CBCentralManagerOptionRestoreIdentifierKey: 用来标志该中心的UID,以供系统后来的调用中,定位该中心
     */
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey:@"ZJCBluetoothManagerCenterManager"}];  /**< 参数1:状态回调的代理  参数2:执行的线程,默认主线程  参数3:需要执行的操作 */
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

#pragma mark - CBPeripheralDelegate----------------------------------------------------------------------------------------------------------------
#pragma mark ==========发现服务、发现特定服务、写入服务=====================
// 发现服务.  需要调用系统的发现服务的方法,发现可用服务后,就会调用该方法,回调可用的服务信息或者错误信息.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"=====ZJCBTM===== 发现服务. %@",peripheral.services);
}
// 发现特定服务.  当调用系统发现特定服务的方法,发现可用服务后,就会调用该方法,回调发现的特定的可用的服务.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error{
    NSLog(@"=====ZJCBTM===== 发现特定服务服务. %@",service);
}
// 外设修改服务.  当前有Service remove,或者有新的Servie add,或者有Service change location,那这些服务便不可用了.  可以通过发现回调重新发现可用服务.
- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices{
    NSLog(@"=====ZJCBTM===== 设备服务修改了.  %@",invalidatedServices);
}
#pragma mark ==========发现特征、读取特征、写入特征、特征通知状态更新===========
// 发现特征值.   当调用系统发现特征值的方法的时候,发现了特征值,就会调用该方法.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    NSLog(@"=====ZJCBTM===== 发现特征值. %@",service);
}
// 特征值更新信息.   特征值读取回调.外设发送广播接受的时候,或者主动读取某特征值value成功的时候.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
}
// 特征值写入信息.   特征值写入回调.
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
}
// 再次可写入.  当调用系统的写入特征值得方法返回错误之后,外设又准备好写入的时候就会回调该方法
- (void)peripheralIsReadyToSendWriteWithoutResponse:(CBPeripheral *)peripheral{
    
}
// 特征值广播更新.   特征值的广播状态更新的时候.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
}
#pragma mark ==========发现描述、读取描述、写入描述=========================
// 发现描述.   当调用系统发现描述的方法的时候,发现到了描述,就会调用该方法.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
}
// 读取描述.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    
}
// 描述写入
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    
}

#pragma mark Others
// 外设更新name.
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral{
    NSLog(@"=====ZJCBTM===== 设备名称更新了.  %@",peripheral.name);
}
// 读取RSSI(信号强度).  当前连接到中心管理器的外设,如果更新了RSSI,就在这里读取.需要提前调用读取方法.  //- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    NSLog(@"=====ZJCBTM===== 设备RSSI更新了. %@",RSSI);
}
// 这里暂时还没处理.  面向连接的蓝牙.
- (void)peripheral:(CBPeripheral *)peripheral didOpenL2CAPChannel:(nullable CBL2CAPChannel *)channel error:(nullable NSError *)error{
    
}
#pragma mark  CBCentralManagerDelegate----------------------------------------------------------------------------------------------------------------
#pragma mark ==========发现外设成功======================================
// 管理中心发现外设.    当中央管理器在扫描时发现外围设备时调用。广告数据可以通过广告数据检索键中列出的键来访问。如果要在其上执行任何命令，则必须保留外设的本地副本。在使用情况下，你的应用程序可以自动连接到某个范围内的外围设备，你可以使用RSSI数据来确定一个被发现的外围设备的接近程度。  Advertisement Data Retrieval Keys : 名称、制造商、服务、发射功率、可连接性
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
}
#pragma mark ==========连接外设成功、连接外设失败============================
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
}
#pragma mark ==========断开连接外设=======================================
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
}
#pragma mark Others
// 管理中心更新状态.  // 当状态低于On的时候,就会停止扫描,并且断开所有连接.   当状态低于Off的时候,所有扫描到的设备信息,都需要重新扫描和获取.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}
// 管理中心将要修改状态.   当系统将恢复中央管理器时调用。对于那些选择支持核心蓝牙的状态保存和恢复功能的应用程序，这是当你的应用程序重新启动到后台完成一些与蓝牙相关的任务时调用的第一个方法。使用此方法来同步应用程序的状态与蓝牙系统的状态。  
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    
}

#pragma mark  CBPeripheralManagerDelegate----------------------------------------------------------------------------------------------------------------
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary<NSString *, id> *)dict{
    
}
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error{
    
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(nullable NSError *)error{
    
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
    
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests{
    
}
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral{
    
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral didPublishL2CAPChannel:(CBL2CAPPSM)PSM error:(nullable NSError *)error{
    
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral didUnpublishL2CAPChannel:(CBL2CAPPSM)PSM error:(nullable NSError *)error{
    
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral didOpenL2CAPChannel:(nullable CBL2CAPChannel *)channel error:(nullable NSError *)error{
    
}
#pragma mark - layzLoad


@end
