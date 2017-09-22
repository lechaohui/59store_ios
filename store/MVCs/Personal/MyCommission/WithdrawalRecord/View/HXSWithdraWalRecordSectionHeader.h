//
//  HXSWithdraWalRecordSectionHeader.h
//  store
//
//  Created by 格格 on 16/10/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSWithdraWalRecordSectionHeader : UIView

@property(nonatomic, weak) IBOutlet UILabel *amountLabel;

+ (instancetype)sectionHeader;

@end
