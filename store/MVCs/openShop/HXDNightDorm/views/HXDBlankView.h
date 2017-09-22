//
//  HXDBlankView.h
//  59dorm
//
//  Created by BeyondChao on 16/5/13.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^(TapActionBlock))(void);

@interface HXDBlankView : UIView

@property (nonatomic, copy) TapActionBlock tapActionBlock;

/**
 *  空白视图
 *
 *  @param image 图片名称
 *  @param title 描述信息
 */
- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title;

/**
 *  设置提示文案字体和颜色
 *
 *  @param fontSize   字体大小
 *  @param titleColor 字体颜色
 */
- (void)setTitleFontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor;

/**
 *  空白视图
 *
 *  @param imageName 图片名称
 *  @param title     属性描述信息(可以点击跳至个人中心)
 */
- (instancetype)initWithImageName :(NSString *)imageName attributeTitle:(NSString *)title responseWords:(NSString *)responseWords;

/**
 *  更新空白显示的图片
 */
- (void)updateImageWithName:(NSString *)newImageName ;

/**
 *  更新提示文案
 */
- (void)updateMessage:(NSString *)newMessage;

/**
 *  更新空白图片top约束
 */
- (void)updateImageTopConstraintConstant:(CGFloat)constant;

@end
