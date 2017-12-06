//
//  ZJCBluetoothManager.h
//  ZJCBluetoothManager_Example
//
//  Created by 小川 on 2017/12/4.
//  Copyright © 2017年 xiaochuan171090331@outlook.com. All rights reserved.
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
 *  @param failure 失败回调信息,包含ZJCScanerror枚举类型的信息,匹配了系统支持的返回类型.
 */
- (void)startScanPeripheralTimeout:(NSTimeInterval)timeout success:(ZJCScanPeripheralSuccess)success failure:(ZJCScanPeripheralError)failure;

/**
 *  扫描外设
 *
 *  @discussion 回调结果.扫描包含对应services的外设.
 *
 *  @param servies 需要支持的services.
 *  @param timeout 超时时长.默认为0,表示一直处于扫描状态.
 *  @param success 成功回调信息,包含是否超时Flog,和一个扫描到的外设的数组.
 *  @param failure 失败回调信息,包含ZJCScanerror枚举类型的信息,匹配了系统支持的返回类型.
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
 *  @discussion 只连接不进行其他操作,连接成功后悔停止扫描蓝牙外设.Block方式回调连接的结果信息.
 *
 *  @param peripheral 需要连接的外设
 *  @param completion 成功连接回调信息,连接上的外设,错误信息
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral completion:(ZJCConnectCompletion)completion;

/**
 *  连接外设
 *
 *  @discussion 连接完成后,根据提供的service和characteristic,继续进行发现对应service和characteristic的操作,完成回调会回调多次,分别是连接的完成的时候,发现service完成的时候,发现characteristic完成的时候,发现description完成的时候
 *
 *  @param peripheral 需要连接的外设.
 *  @param completion 连接完成的回调,
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral discoverServices:(NSArray<CBUUID *>*)services discoverCharacteristics:(NSArray<CBUUID *>*)characteristics description:(NSString *)description completion:(ZJCFullOptionStage)completion;

#pragma mark 发送数据

#pragma mark 接受数据


@end






