//
//  HXDAddMyBankViewController.h
//  59dorm
//  我的银行卡
//  Created by J006 on 16/3/2.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDBaseViewController.h"
#import "HXDAddBankInforParamEntity.h"

typedef void(^UpdateSucess)(void);

@interface HXDAddMyBankViewController : HXDBaseViewController

- (void)initAddMyBankViewControllerWithEntity:(HXDAddBankInforParamEntity *)entity;

@property (nonatomic, copy) UpdateSucess updateSucessBlock;


@end
