//
//  HXSShopListSectionHeaderView.m
//  store
//
//  Created by  黎明 on 16/7/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopListSectionHeaderView.h"

@interface HXSShopListSectionHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation HXSShopListSectionHeaderView

+ (HXSShopListSectionHeaderView *)shopListSectionHeaderView
{
    HXSShopListSectionHeaderView *shopListSectionHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HXSShopListSectionHeaderView" owner:nil options:nil].firstObject;
    
    return shopListSectionHeaderView;
}

+ (HXSShopListSectionHeaderView *)shopListSectionHeaderViewWithImageName:(NSString *)imageName
{
    HXSShopListSectionHeaderView *shopListSectionHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HXSShopListSectionHeaderView" owner:nil options:nil].firstObject;
    
    [shopListSectionHeaderView.imageView setImage:[UIImage imageNamed:imageName]];
    
    return shopListSectionHeaderView;
 
}
@end
