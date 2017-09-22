//
//  HXSCollectTableViewCell.h
//  store
//
//  Created by caixinye on 2017/9/15.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSShopEntity;

@interface HXSCollectTableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton *enterButton;


//点击进入店铺详情的回调
@property(nonatomic,copy) void (^enterBtnDidClickdBlock)(UIButton *sender);


- (void)setupCellWithEntity:(HXSShopEntity *)entity;



@end
