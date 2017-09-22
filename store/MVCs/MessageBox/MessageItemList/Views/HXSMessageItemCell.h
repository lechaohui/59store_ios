//
//  HXSMessageItemCell.h
//  store
//
//  Created by 格格 on 16/8/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSMessageItem.h"

@class HXSMessageItemCell;

@protocol HXSMessageItemCellDelegate <NSObject>

- (void)messageItemCell:(HXSMessageItemCell *)messageItemCell
            copyMessage:(HXSMessageItem *)messageItem;

- (void)messageItemCell:(HXSMessageItemCell *)messageItemCell
          deleteMessage:(HXSMessageItem *)messageItem;

@end


@interface HXSMessageItemCell : UITableViewCell

@property (nonatomic, strong) HXSMessageItem *messageItem;
@property (nonatomic, weak) id <HXSMessageItemCellDelegate> delegate;

@end


