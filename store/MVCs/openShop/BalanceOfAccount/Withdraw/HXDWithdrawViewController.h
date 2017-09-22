//
//  HXDWithdrawViewController.h
//  59dorm
//
//  Created by wupei on 16/7/7.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDBaseViewController.h"
@class HXDAddBankInforParamEntity;

@interface HXDWithdrawViewController : HXDBaseViewController


- (instancetype)initWithEntity:(HXDAddBankInforParamEntity *)bankInfoEntity mankeepAssets:(NSNumber *)mankeepAssets WithIsMike:(BOOL)isMike;

@end
