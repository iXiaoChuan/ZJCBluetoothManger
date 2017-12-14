//
//  BluePrinterTableViewController.m
//  BluetoothTestDemo
//
//  Created by 小川 on 2017/11/3.
//  Copyright © 2017年 sposter.net. All rights reserved.
//

#import "BluePrinterTableViewController.h"
#import "ZJCBluetoothManager.h"
#import "MyCustomTableViewCell.h"

@interface BluePrinterTableViewController () <CBPeripheralDelegate>

/** 蓝牙设备个数 */
@property (strong, nonatomic)   NSMutableArray * deviceArray;
/** 外设 */
@property (strong, nonatomic) CBPeripheral * peripheralBT;
/** 服务 */
@property (strong, nonatomic) CBService * serviceBT;
/** 特征 */
@property (strong, nonatomic) CBCharacteristic * characteristicBT;

/** STR */
@property (copy  , nonatomic) NSString * STR;
/** placeHolder Image */
@property (strong, nonatomic) UIImageView * placeHolderImage;

@end

@implementation BluePrinterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceArray = [NSMutableArray array];
    
    self.title = @"蓝牙打印机列表";
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"扫描" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClicked)];
    [self.navigationItem setLeftBarButtonItem:leftBarItem];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"打印" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    UIImage * image = [UIImage imageNamed:@"qrcode"];
    self.placeHolderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-50-100, 50, 50)];
    self.placeHolderImage.image = image;
    [self.tableView insertSubview:self.placeHolderImage atIndex:0];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - button selector
- (void)leftBarButtonClicked{
    /** 扫描周围的蓝牙外设 */
    [[ZJCBluetoothManager sharedInstance] startScanPeripheralTimeout:10 success:^(BOOL isTimeOut, NSArray<CBPeripheral *> *perpherals) {
        if (self.deviceArray) {
            [self.deviceArray removeAllObjects];
            self.deviceArray = [NSMutableArray arrayWithArray:perpherals];
        }
        [self.tableView reloadData];
    } failure:^(ZJCScanError error) {
        
    }];
}

- (void)rightBarButtonClicked{
    /** 打印逻辑处理 */
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellNew"];
    if (cell == nil) {
        cell = [[MyCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellNew"];
    }
    CBPeripheral *peripherral = [self.deviceArray objectAtIndex:indexPath.row];
    cell.myTitleLabel.text = [NSString stringWithFormat:@"名称:%@",peripherral.name];
    if (peripherral.state == CBPeripheralStateConnected) {
        cell.statusLabel.text = @"已连接";
    }else{
        cell.statusLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Private


@end
