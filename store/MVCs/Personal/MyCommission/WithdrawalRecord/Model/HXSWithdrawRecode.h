//
//  HXSWithdrawRecode.h
//  store
//
//  Created by 格格 on 16/10/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**提现记录类型*/
typedef NS_ENUM(NSInteger, HXSWithdrawRecodeStatus)
{
    HXSWithdrawRecodeStatusWithdrawaling   = 0, // 提现中
    HXSWithdrawRecodeStatusFinish          = 1, // 提现完成
    HXSWithdrawRecodeStatusFailed          = 2  // 提现失败
};

@interface HXSWithdrawRecode : HXBaseJSONModel

@property (nonatomic, strong) NSString *moneyStr;
@property (nonatomic, strong) NSString *statusStr;
@property (nonatomic, strong) NSString *updateTimeStr;

@end
