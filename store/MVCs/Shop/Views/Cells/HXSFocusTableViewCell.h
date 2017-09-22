//
//  HXSFocusTableViewCell.h
//  store
//
//  Created by 格格 on 16/10/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSStoreAppEntryEntity;

@protocol HXSFocusTableViewCellDelegate <NSObject>

- (void)foucsItemClicked:(HXSStoreAppEntryEntity *)foucsItem;

@end

@interface HXSFocusTableViewCell : UITableViewCell

/* 左边关注商品 */
@property (nonatomic, strong) HXSStoreAppEntryEntity *fouceEntity1;
/* 右边关注商品 */
@property (nonatomic, strong) HXSStoreAppEntryEntity *fouceEntity2;
@property (nonatomic, weak) id<HXSFocusTableViewCellDelegate> delegate;

@end
