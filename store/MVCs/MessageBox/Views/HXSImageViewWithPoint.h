//
//  HXSImageViewWithPoint.h
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSImageViewWithPoint : UIView

/** 要显示的图片 */
@property (nonatomic, strong) UIImageView *imageView;
/** 点的颜色 */
@property (nonatomic, strong) UIColor *pointColor;
/** 显示图片的圆角 */
@property (nonatomic, assign) CGFloat imageViewCornerRadius;
/** 是否显示点点 默认不显示 */
@property (nonatomic, assign) BOOL showPint;

@end
