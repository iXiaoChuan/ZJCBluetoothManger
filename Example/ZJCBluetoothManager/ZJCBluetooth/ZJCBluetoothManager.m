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
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];  /**< 参数1:状态回调的代理  参数2:执行的线程,默认主线程  参数3:需要执行的操作 */
    [_scandPeripherals removeAllObjects];
    _currentConnectedPeripheral = nil;
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

#pragma mark - Bluetooth Related
- (void)startScanPeripheralTimeout:(NSTimeInterval)timeout{
    self.defaultTimeout = timeout;
    if (_centerManager.state == CBManagerStatePoweredOn) {
        [_centerManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];  /**< service:需要支持的服务,默认nil扫描全部.   options:重点介绍CBCentralManagerScanOptionAllowDuplicatesKey 这个键的值是一个NSNumber对象。如果是，过滤是禁用的，每次中心接收到来自外围的广告包时，都会生成一个发现事件。禁用此滤波会对电池寿命产生不利影响，且仅在必要时使用。如果没有，相同外围的多个发现合并成一个单独的发现事件。如果没有指定密钥，则默认值为NO */
        return;
    }
    
    [self resetManager];
}

- (void)startScanPeripheralTimeout:(NSTimeInterval)timeout success:(ZJCScanPeripheralSuccess)success failure:(ZJCScanPeripheralError)failure{
    self.defaultTimeout = timeout;
    _scanPeripheralSuccess = success;
    _scanPeripheralError = failure;
    
    if (_centerManager.state == CBManagerStatePoweredOn) {
        [_centerManager scanForPeripheralsWithServices:nil options:nil];
        return;
    }
    
    [self resetManager];
}

- (void)startScanPerpheralTimeout:(NSTimeInterval)timeout includeServies:(NSArray<CBUUID *> *)servies success:(ZJCScanPeripheralSuccess)success failure:(ZJCScanPeripheralError)failure{
    
}

- (void)stopScanComplete:(ZJCScanPeripheralSuccess)complete{
    
}

- (void)connectPeripheral:(CBPeripheral *)peripheral{
    
}

- (void)connectPeripheralWithName:(NSString *)name{
    
}

- (void)connectPeripheral:(CBPeripheral *)peripheral completion:(ZJCConnectCompletion)completion{
    
}

- (void)connectPeripheral:(CBPeripheral *)peripheral discoverServices:(NSArray<CBUUID *> *)services discoverCharacteristics:(NSArray<CBUUID *> *)characteristics discoverDescriptor:(NSArray<CBUUID *> *)descriptors completion:(ZJCFullOptionStage)completion{
    
}

- (void)autoConnectLastPeripheralTimeout:(NSTimeInterval)timeout completion:(ZJCConnectCompletion)completion{
    
}

- (void)sendData:(NSData *)data completion:(ZJCWirteDataComplete)result{
    
}

#pragma mark - CBCentralManagerDelegate----------------------------------------------------------------------------------------------------------------
// 管理中心更新状态.  // 当状态低于On的时候,就会停止扫描,并且断开所有连接.   当状态低于Off的时候,所有扫描到的设备信息,都需要重新扫描和获取.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"=====ZJCBTM===== 中心管理器更新了状态.%ld",central.state);
    switch (central.state) {
        case CBManagerStateUnknown:       // 状态未知
        {
            
        }
            break;
        case CBManagerStateResetting:     // 蓝牙重启
        {
            
        }
            break;
        case CBManagerStateUnsupported:   // 蓝牙不支持
        {
            
        }
            break;
        case CBManagerStateUnauthorized:  // 蓝牙未认证(配对)
        {
            // FIXME:当前没有找到需要配对的设备,这里先暂时不实现
        }
            break;
        case CBManagerStatePoweredOff:    // 蓝牙关闭
        {
            
        }
            break;
        case CBManagerStatePoweredOn:     // 蓝牙打开可用
        {
            [central scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        default:
            break;
    }
}
//// 管理中心将要修改状态.   当系统将恢复中央管理器时调用。对于那些选择支持核心蓝牙的状态保存和恢复功能的应用程序，这是当你的应用程序重新启动到后台完成一些与蓝牙相关的任务时调用的第一个方法。使用此方法来同步应用程序的状态与蓝牙系统的状态。
//- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
//    NSLog(@"=====ZJCBTM===== 中心管理器从后台进入前台.");
//}
#pragma mark 发现外设  >>>>>  成功、失败
// 管理中心发现外设.    当中央管理器在扫描时发现外围设备时调用。广告数据可以通过广告数据检索键中列出的键来访问。如果要在其上执行任何命令，则必须保留外设的本地副本。在使用情况下，你的应用程序可以自动连接到某个范围内的外围设备，你可以使用RSSI数据来确定一个被发现的外围设备的接近程度。  Advertisement Data Retrieval Keys : 名称、制造商、服务、发射功率、可连接性
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"=====ZJCBTM===== 发现外设成功.");
    if (peripheral.name.length <= 0) {
        return;
    }
    [_scandPeripherals addObject:peripheral];
    
    if (_scanPeripheralSuccess) {
        _scanPeripheralSuccess(NO,_scandPeripherals);
    }
    
//    if (_scandPeripherals.count == 0) {
//        [_scandPeripherals addObject:peripheral];
//    } else {
//        BOOL haveExit = NO;
//
//    }
}
#pragma mark 连接外设  >>>>>  成功、失败
// 链接外设成功.
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
}
// 链接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
}
#pragma mark 断开外设
// 断开外设链接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
}

#pragma mark CBPeripheralDelegate----------------------------------------------------------------------------------------------------------------
// 外设更新name.
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral{
    NSLog(@"=====ZJCBTM===== 设备名称更新了.  %@",peripheral.name);
}
// 读取RSSI(信号强度).  当前连接到中心管理器的外设,如果更新了RSSI,就在这里读取.需要提前调用读取方法.  //- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    NSLog(@"=====ZJCBTM===== 设备RSSI更新了. %@",RSSI);
}
// 这里暂时还没处理.  面向连接的蓝牙.
//- (void)peripheral:(CBPeripheral *)peripheral didOpenL2CAPChannel:(nullable CBL2CAPChannel *)channel error:(nullable NSError *)error{
//
//}
#pragma mark 服务  >>>>>  发现服务、发现特定服务、写入服务
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
#pragma mark 特征  >>>>>  发现特征、读取特征、写入特征、特征通知状态更新
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
#pragma mark 描述  >>>>>  发现描述、读取描述、写入描述
// 发现描述.   当调用系统发现描述的方法的时候,发现到了描述,就会调用该方法.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
}
// 读取描述.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    
}
// 描述写入
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    
}

#pragma mark  CBPeripheralManagerDelegate----------------------------------------------------------------------------------------------------------------
// 这里是作为"外设中心"的代理方法,暂不实现.
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
//- (void)peripheralManager:(CBPeripheralManager *)peripheral didOpenL2CAPChannel:(nullable CBL2CAPChannel *)channel error:(nullable NSError *)error{
//
//}

#pragma mark - layzLoad

@end
