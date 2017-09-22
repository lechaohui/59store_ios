//
//  HXDCommodityManageViewController.m
//  store
//
//  Created by caixinye on 2017/9/8.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXDCommodityManageViewController.h"

@interface HXDCommodityManageViewController ()

@end

@implementation HXDCommodityManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitleView];
}

- (void)initTitleView{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    //背景
    UIView *titleBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    titleBackView.backgroundColor=[UIColor colorWithHexString:@"fde25c"];
    [self.view addSubview:titleBackView];
    
    UILabel *titleLb=[Maker makeLb:CGRectMake(0, 20, SCREEN_WIDTH, 44)
                             title:@"商品管理"
                         alignment:NSTextAlignmentCenter
                              font:[UIFont systemFontOfSize:18]
                         textColor:[UIColor colorWithHexString:@"333333"]];
    [titleBackView addSubview:titleLb];
    
    //backbut
    UIButton *bacBut = [Maker makeBtn:CGRectMake(15, 25, 25, 34) title:nil img:@"btn_back_normal" font:nil target:self action:@selector(back)];
    [titleBackView addSubview:bacBut];
    
   
    
    
}
#pragma mark - target
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
