//
//  HXSOfenUseTableViewCell.h
//  store
//
//  Created by caixinye on 2017/9/14.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPersonalCellButton.h"

/**
 
 常用功能cell
 
 
 */
typedef NS_ENUM(NSUInteger, HXDOfenUseButtonType) {
    HXDOfenUseButtonTypeShopCollect = 0,//店铺收藏
    HXDOfenUseButtonTypePlaceManage,      //地址管理
    HXDOfenUseButtonTypeKefu,   //客服中心
    HXDOfenUseButtonTypeFeedback, //意见反馈
    
};
@protocol HXSOfenUseTableViewCellCellDelegate <NSObject>

/**
 *
 *
 *  @param type Btn 类型
 */
- (void)clickHXDOfenUseButtonType:(HXDOfenUseButtonType)type;


@end
@interface HXSOfenUseTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HXSOfenUseTableViewCellCellDelegate> delegate;

@property(nonatomic,strong) HXSPersonalCellButton*shopCollecBut;//店铺收藏
@property(nonatomic,strong) HXSPersonalCellButton*PlaceManageBut;//地址管理
@property(nonatomic,strong) HXSPersonalCellButton*KefuBut;//客服中心
@property(nonatomic,strong) HXSPersonalCellButton*FeedbackBut;//意见反馈


@end
