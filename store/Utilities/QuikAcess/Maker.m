//
//  Maker.m
//  LongChouDai
//
//  Created by 夏桂峰 on 15/8/11.
//  Copyright (c) 2015年 隆筹贷. All rights reserved.
//

#import "Maker.h"

@implementation Maker

+(UILabel *)makeLb:(CGRect)frame title:(NSString *)title alignment:(NSTextAlignment)alignment font:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *lb=[[UILabel alloc]initWithFrame:frame];
    lb.text=title;
    lb.textAlignment=alignment;
    lb.font=font;
    if(color)
        lb.textColor=color;
    return lb;
}
+(UIButton *)makeBtn:(CGRect)frame title:(NSString *)title img:(NSString *)img font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[[UIButton alloc]initWithFrame:frame];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    btn.titleLabel.font=font;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+(UIImageView *)makeImgView:(CGRect)frame img:(NSString *)img
{
    UIImageView *imv=[[UIImageView alloc] initWithFrame:frame];
    imv.image=[UIImage imageNamed:img];
    return imv;
}
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
+(NSAttributedString *)makeAttributeStringWithPrefix:(NSString *)prefix attributes:(NSDictionary *)prefixAttributes sufix:(NSString *)sufix attributes:(NSDictionary *)sufixAttributes
{
    NSMutableAttributedString *mutale=[[NSMutableAttributedString alloc]init];
    if(prefix.length>0)
    {
        NSAttributedString *head=[[NSAttributedString alloc]initWithString:prefix attributes:prefixAttributes];
        [mutale appendAttributedString:head];
    }
    if(sufix.length>0)
    {
        NSAttributedString *tail=[[NSAttributedString alloc]initWithString:sufix attributes:sufixAttributes];
        [mutale appendAttributedString:tail];
    }
    return mutale;
}
+(UITextField *)makeTextField:(CGRect)frame placeHolder:(NSString *)placeHolder backGroundColor:(UIColor *)color keybordType:(UIKeyboardType)kebordType font:(UIFont *)font delegate:(id)delegate
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    textField.placeholder=placeHolder;
    textField.font=font;
    textField.backgroundColor=color;
    textField.keyboardType=kebordType;
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    //左视图
    textField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    textField.leftViewMode=UITextFieldViewModeAlways;
    //大写模式
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    //返回键为完成
    textField.returnKeyType=UIReturnKeyDone;
    //代理
    textField.delegate=delegate;
    
    return textField;
}

@end
