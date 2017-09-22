//
//  HXDMyshopTableViewCell.h
//  store
//
//  Created by caixinye on 2017/9/12.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPersonalMenuButton.h"
#import "HXSPersonalCellButton.h"

/**
 
 我的店铺cell
 
 */
typedef NS_ENUM(NSUInteger, HXDPersonCellButtonType) {
    HXDPersonCellButtonShopSetting = 0,//店铺设置
    HXDPersonCellOpenShopIdea,      //开店攻略
    HXDPersonCellShouyinTai,       //收银台
};

@protocol HXDMyshopTableViewCellDelegate <NSObject>

/**
 *
 *
 *  @param type Btn 类型
 */
- (void)clickPersonCellButtonType:(HXDPersonCellButtonType)type;

@end
@interface HXDMyshopTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HXDMyshopTableViewCellDelegate> delegate;

@property(nonatomic,strong) HXSPersonalCellButton*ShopSettingBut;
@property(nonatomic,strong) HXSPersonalCellButton*ShopIdeaBut;
@property(nonatomic,strong) HXSPersonalCellButton*ShouyinTaiBut;


@end
