//
//  HXSCashSucceedViewController.m
//  store
//
//  Created by 格格 on 16/10/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCashSucceedViewController.h"

@interface HXSCashSucceedViewController ()

@property (nonatomic, weak) IBOutlet UILabel *cashAmountLabel;
@property (nonatomic, weak) IBOutlet UIButton *backToPersonCenterButton;
@property (nonatomic, strong) NSString *cashAmountStr;

@end

@implementation HXSCashSucceedViewController


#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initialBackToPersonCenterButton];
    
    self.cashAmountLabel.text = self.cashAmountStr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


+ (instancetype)controllerWithCashStr:(NSString *)cashStr
{
    HXSCashSucceedViewController *controller = [HXSCashSucceedViewController controllerFromXib];
    controller.cashAmountStr = [NSString stringWithFormat:@"￥%.2f",cashStr.floatValue];
    
    return controller;
}


#pragma mark - override

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"提现";
    [self.navigationItem.leftBarButtonItem setAction:@selector(back)];

}

- (void)initialBackToPersonCenterButton
{
    self.backToPersonCenterButton.layer.cornerRadius = 4;
    self.backToPersonCenterButton.layer.masksToBounds = YES;
}


#pragma mark - Target/Action

- (IBAction)backToPersonCenterButtonClicked:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}


@end
