//
//  HXSOrderAppraiseResultVC.m
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  评价结果页

#import "HXSOrderAppraiseResultVC.h"

@interface HXSOrderAppraiseResultVC ()

@end

@implementation HXSOrderAppraiseResultVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"感谢评价";
}


@end
