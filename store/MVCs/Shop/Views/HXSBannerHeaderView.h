//
//  HXSBannerHeaderView.h
//  store
//
//  Created by ArthurWang on 16/1/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model
#import "HXSClickEvent.h"



@interface HXSBannerHeaderView : UIView

@property (nonatomic, weak) id<HXSClickEventDelegate> eventDelegate;



@property (nonatomic, strong) NSString *locationStr;

- (void)setSlideItemsArray:(NSArray *)slideItemsArray;
//- (void)setlacationTitle:(NSArray *)titles;

@end
