//
//  HXSOrderCountdownCell.h
//  store
//
//  Created by 格格 on 16/9/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSOrderCountdownCellDelegate <NSObject>

- (void)orderCountdownCellCountdownOver;

@end


@interface HXSOrderCountdownCell : UITableViewCell

@property (nonatomic, weak) id<HXSOrderCountdownCellDelegate> delegate;

+ (instancetype)orderCountdownCell;

- (void)initialInvalidTimeStr:(NSString *)invalidTimeStr
               currentTimeStr:(NSString *)currentTimeStr;

@end
