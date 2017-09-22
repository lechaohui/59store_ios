//
//  HXSDormCountSelectView+HXSDormCountSelectView_Dorm5_1.m
//  store
//
//  Created by  黎明 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDormCountSelectView+HXSDormCountSelectView_Dorm5_1.h"

@implementation HXSDormCountSelectView (HXSDormCountSelectView_Dorm5_1)

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftButton setImage:[UIImage imageNamed:@"ic_Subtract"]
                               forState:UIControlStateNormal];
    
    [self.rightButton setImage:[UIImage imageNamed:@"ic_Add_normal"]
                               forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"ic_add_Not click"]
                               forState:UIControlStateDisabled];
}

@end
