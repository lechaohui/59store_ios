//
//  HXSDiscoverTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/9/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSStoreAppEntryEntity.h"

@protocol HXSDiscoverTableViewCellDelegate <NSObject>

@required
- (void)didSelectedLink:(NSString *)linkStr;

@end

@interface HXSDiscoverTableViewCell : UITableViewCell

+ (CGFloat)heightOfCellWithEntity:(HXSStoreAppEntryEntity *)entryEntity;

- (void)setupCellWithLeftBanner:(HXSStoreAppEntryEntity *)leftBannerEntity
                    rightBanner:(HXSStoreAppEntryEntity *)rightBannerEntity
                       delegate:(id<HXSDiscoverTableViewCellDelegate>)delegate;


@end
