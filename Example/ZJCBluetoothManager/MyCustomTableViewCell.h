//
//  MyCustomTableViewCell.h
//  BluetoothTestDemo
//
//  Created by 小川 on 2017/11/22.
//  Copyright © 2017年 sposter.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
