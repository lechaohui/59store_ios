//
//  HXSaaaa.h
//  store
//
//  Created by  黎明 on 16/6/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSBoxOrderItemModel,HXSBoxCarManager;

@interface HXSnacksCarView : UIView
/** 结算按钮 */
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
/** 购物车按钮 */
@property (weak, nonatomic) IBOutlet UIButton *carButton;
/** 总数量 */
@property (weak, nonatomic) IBOutlet UILabel  *amountLabel;
/** 总价格 */
@property (weak, nonatomic) IBOutlet UILabel  *fullPriceLabel;

/** 购物车按钮点击回调 */
@property (copy, nonatomic) void (^carButtonClickBlock)();
/** 结算按钮点击回调 */
@property (copy, nonatomic) void (^checkButtonClickBlock)();
@property (strong, nonatomic) HXSBoxCarManager *boxCarManager;

@end
