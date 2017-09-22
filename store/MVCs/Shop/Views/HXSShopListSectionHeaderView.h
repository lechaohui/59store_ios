//
//  HXSShopListSectionHeaderView.h
//  store
//
//  Created by  黎明 on 16/7/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
/************************************************************
 *  店铺列表和确认点单的sectionHeader 默认Title为“附近店铺”
 ***********************************************************/
#import <UIKit/UIKit.h>

@interface HXSShopListSectionHeaderView : UIView

+ (HXSShopListSectionHeaderView *)shopListSectionHeaderView;
+ (HXSShopListSectionHeaderView *)shopListSectionHeaderViewWithImageName:(NSString *)imageName;
@end
