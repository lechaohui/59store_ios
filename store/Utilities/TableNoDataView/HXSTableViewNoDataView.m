//
//  HXSTableViewNoDataView.m
//  store
//
//  Created by 格格 on 16/10/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTableViewNoDataView.h"

@implementation HXSTableViewNoDataView

+ (instancetype)tableViewNoDataView
{
    HXSTableViewNoDataView *view = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    
    view.titleLabel.text = @"暂无数据";
    
    return view;
}

@end
