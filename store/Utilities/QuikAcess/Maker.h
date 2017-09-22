//
//  Maker.h
//  LongChouDai
//
//  Created by 夏桂峰 on 15/8/11.
//  Copyright (c) 2015年 隆筹贷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Maker : NSObject

/**
 *  生成Label
 *
 *  @param frame     frame
 *  @param title     title
 *  @param alignment 对齐方式
 *  @param font      font
 *
 *  @return label
 */
+(UILabel *)makeLb:(CGRect)frame title:(NSString *)title alignment:(NSTextAlignment)alignment font:(UIFont *)font textColor:(UIColor *)color;
/**
 *  生成按钮
 *
 *  @param frame  frame
 *  @param title  title
 *  @param img    image
 *  @param font   font
 *  @param target target
 *  @param action action
 *
 *  @return UIButton
 */
+(UIButton *)makeBtn:(CGRect)frame title:(NSString *)title img:(NSString *)img font:(UIFont *)font target:(id)target action:(SEL)action;
/**
 *  生成图片视图
 *
 *  @param frame frame
 *  @param img   图片
 *
 *  @return imv
 */
+(UIImageView *)makeImgView:(CGRect)frame img:(NSString *)img;
/**
 *  合成属性文本
 *
 *  @param prefix           前面部分
 *  @param prefixAttributes 前面部分的属性
 *  @param sufix            后面部分
 *  @param sufixAttributes  后面部分的属性
 *
 *  @return 属性文本
 */
+(NSAttributedString *)makeAttributeStringWithPrefix:(NSString *)prefix attributes:(NSDictionary *)prefixAttributes sufix:(NSString *)sufix attributes:(NSDictionary *)sufixAttributes;
/**
 *  生成UITextField
 *
 *  @param frame       frame
 *  @param placeHolder placeHolder
 *  @param color       背景颜色
 *  @param kebordType  键盘类型
 *  @param font        字体
 *
 *  @return UITextField
 */
+(UITextField *)makeTextField:(CGRect)frame placeHolder:(NSString *)placeHolder backGroundColor:(UIColor *)color keybordType:(UIKeyboardType)kebordType font:(UIFont *)font delegate:(id)delegate;

@end
