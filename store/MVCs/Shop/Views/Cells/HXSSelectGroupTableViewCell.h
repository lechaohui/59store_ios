//
//  HXSSelectGroupTableViewCell.h
//  store
//
//  Created by caixinye on 2017/9/1.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 
 约团首选
 
 
 */
@class HXSStoreAppEntryEntity;

@protocol HXSSelectGroupTableViewCellDelegate <NSObject>

@required

- (void)SelectGroupTableViewCellImageTaped:(NSString *)linkStr;


@end
@interface HXSSelectGroupTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HXSSelectGroupTableViewCellDelegate> delegate;

- (void)setupItemImages:(NSArray<HXSStoreAppEntryEntity *> *)slideItemsArr;

+ (CGFloat)getCellHeightWithObject:(HXSStoreAppEntryEntity *)storeAppEntryEntity;

@end
