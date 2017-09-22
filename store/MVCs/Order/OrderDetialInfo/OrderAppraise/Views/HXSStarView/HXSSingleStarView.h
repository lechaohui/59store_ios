//
//  customStartView.h
//  ZHNstratView
//
//  Created by zhn on 16/4/26.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSSingleStarView : UIView

@property (nonatomic,strong) UIColor * fillColor;
@property (nonatomic,strong) UIColor * strokeColor;

@property (nonatomic,getter = isFillStar) BOOL fillStar;
@end
