//
//  ZJCBluetoothDefine.h
//  ZJCBluetoothManager
//
//  Created by 小川 on 2017/12/5.
//  Copyright © 2017年 xiaochuan171090331@outlook.com. All rights reserved.
//

#ifndef ZJCBluetoothDefine_h
#define ZJCBluetoothDefine_h

/** 通用的支持服务UUID */
#define PrintService_UUID @"49535343-FE7D-4AE5-8FA9-9FAFD205E455"
/** 通用的支持写入的特征值 */
#define WRITE_CHAR_UUID @"49535343-8841-43F4-A8D4-ECBE34729BB3"
/** 通用的支持通知的特征值 */
#define NOTIFI_CHAR_UUID @"49535343-1E4D-4BD9-BA61-23C647249616"

/** 本地缓存上次链接外设的UUDI Key */
#define kUUIDForLastConnetedPeripheralKey @"kUUIDForLastConnetedPeripheralKey"
/** 发送数据的分段长度 */ 
#define kLimitLength    146   // 部分打印机一次发送数据过长就会乱码，需要分段发送。这个长度值不同的打印机可能不一样，你需要调试设置一个合适的值（最好是偶数）

/** 蓝牙打印机状态 */
typedef NS_ENUM(NSUInteger, ZJCPrinterStatus) {
    ZJCPrinterStatusNoPaper = 0x01,        // 缺纸
    ZJCPrinterStatusOverHeat = 0x02,       // 打印过过热
    ZJCPrinterStatusBatteryLow = 0x04,     // 电量低
    ZJCPrinterStatusPrinting = 0x08,       // 打印中
    ZJCPrinterStatusCoverOpen = 0x10,      // 纸仓盖未关闭
    ZJCPrinterStatusDone,                  // 打印完毕
    ZJCPrinterStatusNoError,               // 无错误,其他信息
};

/** 蓝牙外设扫描状态 */
typedef NS_ENUM(NSUInteger, ZJCScanError) {
    ZJCScanErrorUnknown = 0,
    ZJCScanErrorResetting,
    ZJCScanErrorUnsupported,      // 设备不支持
    ZJCScanErrorUnauthorized,     // 设备未认证
    ZJCScanErrorOff,              // 蓝牙可用,但是未打开
    ZJCScanErrorTimeOut,          // 扫描超时
};

typedef NS_ENUM(NSUInteger, ZJCFullOptionStage) {
    ZJCFullOptionStageConnecting,             // 链接阶段
    ZJCFullOptionStageSearchServices,         // 搜索服务阶段
    ZJCFullOptionStageSearchCharacteristics,  // 搜索特征阶段
    ZJCFullOptionStageSearchDescriptions,     // 搜索描述阶段
};

/**
 *  扫描成功 Block
 *
 *  @param isTimeOut 超时时间
 *  @param perpherals 扫描到的外设集合
 */
typedef void(^ZJCScanPeripheralSuccess)(BOOL isTimeOut, NSArray<CBPeripheral *>*perpherals);

/**
 *  扫描失败 Block
 *
 *  @param error 错误类型
 */
typedef void(^ZJCScanPeripheralError)(ZJCScanError error);

/**
 *  链接完成 Block
 *
 *  @param perpheral 链接成功的外设
 *  @param error 错误
 */
typedef void(^ZJCConnectCompletion)(CBPeripheral * perpheral, NSError * error);

/**
 *  链接失败 Block
 *
 *  @param perpheral 链接失败的外设
 *  @param error 错误
 */
typedef void(^ZJCConnectFailure)(CBPeripheral * perpheral, NSError * error);

/**
 *  断开链接 完成 Block
 *
 *  @param perpheral 要断开的外设
 *  @param error 错误
 */
typedef void(^ZJCDicconnectCompletion)(CBPeripheral * perpheral, NSError * error);

/**
 *  断开链接 失败 Block
 *
 *  @param perpheral 要断开的外设
 *  @param error 错误
 */
typedef void(^ZJCDicconnectFailure)(CBPeripheral * perpheral, NSError * error);

/**
 *  写入数据 完成 Block
 *
 *  @param connectPerpheral 当前链接外设
 *  @param completion 是否完成
 *  @param error 错误
 */
typedef void(^ZJCWirteDataComplete)(CBPeripheral *connectPerpheral, BOOL completion, NSString *error);

/**
 *  写入数据 失败 Block
 *
 *  @param connectPerpheral 当前链接外设
 *  @param completion 是否完成
 *  @param error 错误
 */
typedef void(^ZJCWirteDataFailure)(CBPeripheral *connectPerpheral, BOOL completion, NSString *error);

#endif /* ZJCBluetoothDefine_h */
