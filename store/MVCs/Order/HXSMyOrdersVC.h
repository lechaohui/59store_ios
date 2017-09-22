//
//  HXSMyOrdersVC.h
//  store
//
//  Created by 格格 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXSMyOrdersVC : HXSBaseViewController

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic,assign) NSInteger page;

//标记是否有返回键
@property(nonatomic,assign)BOOL hasBackBut;


@end
