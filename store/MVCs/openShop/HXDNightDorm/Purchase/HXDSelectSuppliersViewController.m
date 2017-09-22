//
//  HXDSelectSuppliersViewController.m
//  store
//
//  Created by caixinye on 2017/9/8.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXDSelectSuppliersViewController.h"

@interface HXDSelectSuppliersViewController ()

@property (nonatomic, assign) HXDShopType shopType;


@end

@implementation HXDSelectSuppliersViewController

- (instancetype)initWithShopType:(HXDShopType)shopType {
    self = [super init];
    if (self) {
        _shopType = shopType;
    }
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"我要采购";
    [self initTitleView];
    
    
}

- (void)initTitleView{

    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    //背景
    UIView *titleBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    titleBackView.backgroundColor=[UIColor colorWithHexString:@"fde25c"];
    [self.view addSubview:titleBackView];
    
    UILabel *titleLb=[Maker makeLb:CGRectMake(0, 20, SCREEN_WIDTH, 44)
                             title:@"我要采购"
                         alignment:NSTextAlignmentCenter
                              font:[UIFont systemFontOfSize:18]
                         textColor:[UIColor colorWithHexString:@"333333"]];
    [titleBackView addSubview:titleLb];
    
    //backbut
    UIButton *bacBut = [Maker makeBtn:CGRectMake(15, 25, 25, 34) title:nil img:@"btn_back_normal" font:nil target:self action:@selector(back)];
    [titleBackView addSubview:bacBut];
    
    //rightBut
    UIButton *rightBut = [Maker makeBtn:CGRectMake(SCREEN_WIDTH-65, 30, 60, 25) title:@"采购记录" img:nil font:[UIFont systemFontOfSize:14] target:self action:@selector(history:)];
    [titleBackView addSubview:rightBut];


}

#pragma mark - target
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)history:(UIButton *)sender{
    
    
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
