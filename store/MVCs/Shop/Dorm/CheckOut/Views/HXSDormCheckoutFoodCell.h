//
//  HXSDormCheckoutFoodCell.h
//  store
//
//  Created by hudezhi on 15/9/21.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSDormItem.h"
#import "HXSPromotionInfoModel.h"

@interface HXSDormCheckoutFoodCell : UITableViewCell

@property (nonatomic, strong) HXSDormItem *item;

/**
 *  设置赠品
 *
 *  @param item
 */
- (void)setPromotionItems:(HXSPromotionItemModel *)item;

@end
