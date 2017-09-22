//
//  HXDPersonHeaderView.h
//  store
//
//  Created by caixinye on 2017/9/11.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSPersonalMenuButton.h"

typedef NS_ENUM(NSUInteger, HXDPersonHeaderButtonType) {
    HXDPersonHeaderButtonAccumulate = 0,//累计销售额
    HXDPersonHeaderButtonTongji,      //统计截止
};

@protocol HXDPersonHeaderViewDelegate <NSObject>

/**
 *  
 *
 *  @param type Btn 类型
 */
- (void)clickPersonMenuButtonType:(HXDPersonHeaderButtonType)type;


@end
@interface HXDPersonHeaderView : UIView

@property (nonatomic, weak) UIViewController *parentViewController;



@property(nonatomic,strong) HXSPersonalMenuButton*accumBut;
@property(nonatomic,strong)UIButton *tongjiBut;
@property (nonatomic, weak) id<HXDPersonHeaderViewDelegate> delegate;







@end
