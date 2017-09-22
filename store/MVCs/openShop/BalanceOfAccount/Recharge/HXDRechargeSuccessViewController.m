
//
//  HXDRechargeSuccessViewController.m
//  59dorm
//
//  Created by wupei on 16/7/14.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDRechargeSuccessViewController.h"
#import "HXDBalanceOfAccountViewController.h"
@interface HXDRechargeSuccessViewController ()
@property (nonatomic, strong) UIImageView *bigImageView; //大图
@property (nonatomic, strong) UIView *upLineView;          //分割线
@property (nonatomic, strong) UIView *downLineView;        //分割线

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation HXDRechargeSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initialView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)initNav {
    self.title = @"充值成功";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xf4f5f6];
    UIBarButtonItem* saveBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(finished)];
    [saveBtnItem setTitlePositionAdjustment:UIOffsetMake(-5.0, 0) forBarMetrics:UIBarMetricsDefault];
    [saveBtnItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x07A9FA]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = saveBtnItem;
}

- (instancetype)initWithMoneyStr:(NSString *)moneyStr {
    if (self = [super init]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"￥ %.2f",[moneyStr floatValue]];
    }
    return self;
}
- (void)initialView {
    //1、大图
    self.bigImageView.image = [UIImage imageNamed:@"chongzhichengg_image"];
    [self.view addSubview:self.bigImageView];
    //2、lineView
    [self.view addSubview:self.upLineView];
    //2、label
    self.firstLabel.text = @"充值金额";
    self.firstLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.firstLabel];

    self.moneyLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.moneyLabel];
    [self.view addSubview:self.downLineView];

    
    __weak typeof(self) weakSelf = self;
    
    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.width.height.mas_equalTo(200);
        make.bottom.equalTo(weakSelf.upLineView.mas_top).offset(-15);
    }];
    
    [self.upLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.height.mas_equalTo(1);
        make.left.equalTo(weakSelf.view).offset(15);
        make.right.equalTo(weakSelf.view).offset(-15);
    }];
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.upLineView.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.view.mas_left).offset(35);
    }];
    
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.upLineView.mas_bottom).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-35);
    }];
    
    [self.downLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
        make.left.equalTo(weakSelf.view).offset(15);
        make.right.equalTo(weakSelf.view).offset(-15);
    }];
}

- (void)finished {
    UINavigationController *navigationVC = self.navigationController;
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    //    遍历导航控制器中的控制器
    for (UIViewController *vc in navigationVC.viewControllers) {
        [viewControllers addObject:vc];
        // 我需要跳转到这个控制器HXDBalanceOfAccountViewController
        if ([vc isKindOfClass:[HXDBalanceOfAccountViewController class]]) {
            break;
        }
        
    }
    //    把控制器重新添加到导航控制器
    
    [self.navigationController setViewControllers:viewControllers animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (UIImageView *)bigImageView
{
    if (nil == _bigImageView) {
        _bigImageView = [[UIImageView alloc] init];
    }
    
    return _bigImageView;
}

- (UILabel *)firstLabel
{
    if (nil == _firstLabel) {
        _firstLabel = [[UILabel alloc] init];
    }
    
    return _firstLabel;
}

- (UILabel *)moneyLabel
{
    if (nil == _moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
    }
    
    return _moneyLabel;
}

- (UIView *)upLineView
{
    if (nil == _upLineView) {
        _upLineView = [[UIView alloc] init];
        _upLineView.backgroundColor = [UIColor colorWithRGBHex:0xCACACA];
    }
    
    return _upLineView;
}

- (UIView *)downLineView
{
    if (nil == _downLineView) {
        _downLineView = [[UIView alloc] init];
        _downLineView.backgroundColor = [UIColor colorWithRGBHex:0xCACACA];

    }
    
    return _downLineView;
}
@end
