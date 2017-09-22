//
//  HXDPersonButView.h
//  store
//
//  Created by caixinye on 2017/9/11.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSPersonalMenuButton.h"


typedef NS_ENUM(NSUInteger, HXDPersonButtonType) {
    HXDPersonHeaderButtonVisit = 0,//今日访客
    HXDPersonHeaderButtonNum,      //今日订单数
    HXDPersonHeaderButtonSale,//今日销售额
    
};
@protocol HXDPersonButViewDelegate <NSObject>


/**
 *  
 *
 *  @param type Btn 类型
 */
- (void)clickPersonButtonType:(HXDPersonButtonType)type;


@end

@interface HXDPersonButView : UIView

@property(nonatomic,strong) HXSPersonalMenuButton*visitBut;
@property(nonatomic,strong) HXSPersonalMenuButton*numBut;
@property(nonatomic,strong) HXSPersonalMenuButton*accumBut;
@property (nonatomic, weak) id<HXDPersonButViewDelegate> delegate;


@end
