//
//  HXSCheckOutNoticeView.m
//  store
//
//  Created by  黎明 on 16/8/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCheckOutNoticeView.h"

@implementation HXSCheckOutNoticeView

+ (instancetype)checkOutNoticeView
{
    HXSCheckOutNoticeView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSCheckOutNoticeView class])
                                                             owner:nil options:nil].firstObject;
    return view;
}

@end
