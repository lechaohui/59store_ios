//
//  HXDAddMyBankTableViewCell.h
//  59dorm
//
//  Created by J006 on 16/3/3.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    kHXDMyBankEditTypeBankType         = 0,//所属银行
    kHXDMyBankEditTypeBankAddress      = 1,//开户地
    kHXDMyBankEditTypeBankShop         = 2,//开户网点
    kHXDMyBankEditTypeBankNums         = 3,//卡号
    kHXDMyBankEditTypeUserName         = 4,//持卡人姓名
} HXDMyBankAddType;

#define HXDAddMyBankTableViewCellIdentify @"HXDAddMyBankTableViewCell"

#import "HXDAddBankInforParamEntity.h"

@interface HXDAddMyBankTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

- (void)initTheCellWithTitle:(NSString *)title
                 andWithType:(HXDMyBankAddType)type
               andWithEntity:(HXDAddBankInforParamEntity *)entity;

@end
