//
//  HXSTabBarView.h
//  store
//
//  Created by ArthurWang on 2016/10/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSTabBarView;

@protocol HXSTabBarViewDelegate <NSObject>

- (BOOL)tabBar:(HXSTabBarView *)tabBar selectedFrom:(NSInteger)from to:(NSInteger)to;

-(void)tabBarViewCenterItemClick:(UIButton *)button;

@end

@interface HXSTabBarView : UIView

@property (nonatomic, weak) id<HXSTabBarViewDelegate> delegate;

@property (nonatomic, strong) UIImage * centerImage;
@property (nonatomic, strong) UIButton * centerButton;


- (void)addButtonWithImage:(UIImage *)image selectdImage:(UIImage *)selectedImage gif:(NSData *)gifData;

- (void)clearUpImageAndGif;

- (void)selectedFrom:(NSInteger)from to:(NSInteger)to;

@end
