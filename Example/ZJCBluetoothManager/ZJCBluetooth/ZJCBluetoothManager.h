//
//  ZJCBluetoothManager.h
//  ZJCBluetoothManager_Example
//
//  Created by 小川 on 2017/12/4.
//  Copyright © 2017年 xiaochuan171090331@outlook.com. All rights reserved.
//
//  ****************************************************
//                      说    明
//  宏定义和BLOCK定义可以写在了此类文件中,但是示例工程为了便于管理
//  ,所以将这些定义放到单独的头文件ZJCBluetoothDefine.h中.
//
//  默认情况下以下概念相同:
//  peripheral     == 外设     service        == 服务
//  characteristic == 特征     descriptor     == 描述
//  ****************************************************
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZJCBluetoothDefine.h"
@class ZJCBluetoothManager;

/**
 *  蓝牙链接管理类协议
 */
@protocol ZJCBluetoothManagerDelegate <NSObject>
@optional;

@end


@interface ZJCBluetoothManager : NSObject

/** 蓝牙中心管理类 */
@property (strong, nonatomic) CBCentralManager * centerManager;
/** 扫描到的蓝牙外设 */
@property (strong, nonatomic) NSMutableArray * scandPeripherals;
/** 当前链接的蓝牙外设 */
@property (strong, nonatomic, readonly) CBPeripheral * currentConnectedPeripheral;

#pragma mark - Common Method
/**
 *  蓝牙链接管理类(单例)
 */
+ (instancetype)sharedInstance;

/**
 *  上次链接的外设的UUID
 */
+ (NSString *)UUIDForLastConnetedPeripheral;

#pragma mark 扫描
/**
 *  扫描外设
 *
 *  @param timeout 超时时长,默认为0,表示一直处于扫描状态.
 */
- (void)startScanPeripheralTimeout:(NSTimeInterval)timeout;

/**
 *  扫描外设
 *
 *  @discussion 回调结果.
 *
 *  @param timeout 超时时长,默认为0,表示一直处于扫描状态.
 *  @param success 成功回调信息,包含是否超时Flog,和一个扫描到的外设的数组.
 *  @param failure 失败回调信息,包含ZJCScanerror枚举类型的信息,匹配了系统支持的蓝牙扫描错误返回类型.
 */
- (void)startScanPeripheralTimeout:(NSTimeInterval)timeout success:(ZJCScanPeripheralSuccess)success failure:(ZJCScanPeripheralError)failure;

/**
 *  扫描外设
 *
 *  @discussion 回调结果.只扫描包含对应services的外设.
 *
 *  @param servies 外设应该支持的services.
 *  @param timeout 超时时长.默认为0,表示一直处于扫描状态.
 *  @param success 成功回调信息,包含是否超时Flog,和一个扫描到的外设的数组.
 *  @param failure 失败回调信息,包含ZJCScanerror枚举类型的信息,匹配了系统支持的蓝牙扫描错误返回类型.
 */
- (void)startScanPerpheralTimeout:(NSTimeInterval)timeout includeServies:(NSArray<CBUUID *> *)servies  success:(ZJCScanPeripheralSuccess)success failure:(ZJCScanPeripheralError)failure;

/**
 *  停止扫描
 */
- (void)stopScanComplete:(ZJCScanPeripheralSuccess)complete;

#pragma mark 链接
/**
 *  链接外设
 *
 *  @discussion 只连接不进行其他操作,连接成功后会停止扫描蓝牙外设.
 *
 *  @param peripheral 需要连接的外设
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral;

/**
 *  链接外设
 *
 *  @discussion 只连接不进行其他操作,连接成功后会停止扫描蓝牙外设.
 *
 *  @param peripheral 需要连接的外设
 *  @param name 需要连接的外设的名称
 */
- (void)connectPeripheralWithName:(NSString *)name;

/**
 *  链接外设
 *
 *  @discussion 只连接不进行其他操作,连接成功后会停止扫描蓝牙外设.Block方式回调连接的结果信息.
 *
 *  @param peripheral 需要连接的外设
 *  @param completion 成功连接后的回调信息,连接上的外设,错误信息
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral completion:(ZJCConnectCompletion)completion;

/**
 *  连接外设
 *
 *  @discussion 连接成功后会停止扫描蓝牙外设.根据提供的service、characteristic和descriptor,继续进行相应的discover操作.此方法的完成回调
 *              会回调多次,分别是connect完成的时候,发现service完成的时候,发现characteristic完成的时候,发现descriptor完成的时候,如果需
 *              要在不同的阶段处理相应的业务逻辑,可以调用此方法.
 *
 *  @param peripheral      需要连接的外设.
 *  @param services        外设需要支持的services.默认为nil,搜索全部.
 *  @param characteristics 对应service需要支持的characteristics.默认为nil,搜索全部.
 *  @param descriptor      对应characteristic需要支持的descriptor.默认为nil,搜索全部.
 *  @param completion      连接完成的回调.
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral discoverServices:(NSArray<CBUUID *>*)services discoverCharacteristics:(NSArray<CBUUID *>*)characteristics discoverDescriptor:(NSArray<CBUUID *>*)descriptors completion:(ZJCFullOptionStage)completion;

/**
 *  自动链接上次外设
 *
 *  @discussion 自动链接上次链接过的外设,链接之前会检测蓝牙状态,如果不可用,会返回错误.
 *
 *  @param timeout 超时时间
 *  @param completion 链接完成回调Block
 */
- (void)autoConnectLastPeripheralTimeout:(NSTimeInterval)timeout completion:(ZJCConnectCompletion)completion;

#pragma mark 发送数据
/**
 *  发送数据
 *
 *  @discussion 发送给蓝牙设备数据,数据应该是NSData类型的,如果是相应特殊协议下的模板数据,注意编码类型的转换需要调用方法之前完成,此方法只
 *              提供发送data的操作.
 *
 *  @param data 需要传输的数据
 *  @param result 回调结果
 */
- (void)sendData:(NSData *)data completion:(ZJCWirteDataComplete)result;

#pragma mark 接受数据


@end






