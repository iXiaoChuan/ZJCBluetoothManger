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

/**
 *  协议
 *
 */
@class ZJCBluetoothManager;
@protocol ZJCBluetoothManagerDelegate <NSObject>
@optional;

@end


@interface ZJCBluetoothManager : NSObject

/** 扫描到的蓝牙外设集 */
@property (strong, nonatomic) NSMutableArray * scandPeripherals;
/** 默认蓝牙中心管理类 */
@property (strong, nonatomic) CBCentralManager * centerManager;
/** 当前链接的蓝牙外设 */
@property (strong, nonatomic, readonly) CBPeripheral * currentConnectedPeripheral;

#pragma mark Common Method
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
 *  扫描外设 不回调结果
 *
 *  @param timeout 超时时长 默认为0,表示一直处于扫描状态
 */
- (void)scanPeripheralTimeout:(NSTimeInterval)timeout;

/**
 *  扫描外设 回调结果
 *
 *  @param timeout 超时时长 默认为0,表示一直处于扫描状态
 *  @param success 成功回调信息,
 *  @param failure
 */
- (void)scanPeripheralTimeout:(NSTimeInterval)timeout success:(ZJCScanPeripheralSuccess)success failure:(ZJCScanPeripheralError)failure;

/**
 *  扫描外设 根据提供的serives的UUID集合 回调结果
 *
 *  @param timeout 超时时长 默认为0,表示一直处于扫描状态
 *  @param success 成功回调信息,
 *  @param failure
 */
- (void)startScanPerpheralTimeout:(NSTimeInterval)timeout includeServies:(NSArray<CBUUID *> *)servies  success:(ZJCScanPeripheralSuccess)success failure:(ZJCScanPeripheralError)failure;

@end
