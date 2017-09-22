//
//  HXSOpenShopHeaderCenterView.h
//  store
//
//  Created by caixinye on 2017/8/27.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSOpenShopHeaderCenterView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *loginNameLb;
@property (weak, nonatomic) IBOutlet UILabel *applyLb;
@property (weak, nonatomic) IBOutlet UIButton *personInfoButton;



+ (id)headerView;

- (void)refreshInfo;

@end
