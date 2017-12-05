//
//  ZJCBluetoothManager.m
//  ZJCBluetoothManager_Example
//
//  Created by 小川 on 2017/12/4.
//  Copyright © 2017年 xiaochuan171090331@outlook.com. All rights reserved.
//
//
//  ****************************************************
//                      说    明
//  宏定义和BLOCK定义可以写在了同一个类文件中,示例工程为了便于管理
//  ,所以单独将这些定义放到pch中
//  ****************************************************
//

#import "ZJCBluetoothManager.h"

@interface ZJCBluetoothManager ()

/** 当前链接的外设 */
@property (strong, nonatomic) CBPeripheral * currentConnectedPeripheral;

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

#pragma mark - meta method
+ (NSString *)UUIDForLastConnetedPeripheral{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *UUIDString = [userDefaults objectForKey:kUUIDForLastConnetedPeripheralKey];
    return UUIDString;
}


@end
