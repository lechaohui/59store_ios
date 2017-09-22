//
//  HXDSelectBankListTableViewCell.h
//  59dorm
//
//  Created by J006 on 16/3/3.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXDBankEntity.h"

#define HXDSelectBankListTableViewCellIndentify @"HXDSelectBankListTableViewCell"

@interface HXDSelectBankListTableViewCell : UITableViewCell

- (void)initSelectBankListTableViewCellWith:(HXDBankEntity *)entity;

@end
