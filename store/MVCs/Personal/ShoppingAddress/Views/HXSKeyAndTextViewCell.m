//
//  HXSKeyAndTextViewCell.m
//  store
//
//  Created by 格格 on 16/9/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSKeyAndTextViewCell.h"

#import "NSString+YFEmoji.h"

@interface HXSKeyAndTextViewCell ()<UITextViewDelegate>

@end

@implementation HXSKeyAndTextViewCell

+ (instancetype)keyAndTextViewCell
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class])
                                        owner:nil
                                      options:nil].firstObject;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.valueTextField];
    
    self.valueTextFieldWidth.constant = SCREEN_WIDTH - 140;
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.valueTextField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)textFieldTextChanged:(NSNotification *)obj
{
    NSString *toBeString = self.valueTextField.text;
    NSString *lang =  [self.valueTextField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self.valueTextField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self.valueTextField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            toBeString = [toBeString stringByRemoveAllEmoji];
            if (toBeString.length > 40) {
                self.valueTextField.text = [toBeString substringToIndex:40];
            } else {
                self.valueTextField.text = toBeString;
            }
            
        } else {  // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {  // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        toBeString = [toBeString stringByRemoveAllEmoji];

        if (toBeString.length > 40) {
            self.valueTextField.text = [toBeString substringToIndex:40];
        } else {
            self.valueTextField.text = toBeString;
        }
    }
    
    UIFont *textFont = [UIFont systemFontOfSize:14];
    CGSize textSize = CGSizeMake(CGFLOAT_MAX, 21);
    NSDictionary *textDic = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName,nil];
    
    CGSize autoSize = [self.valueTextField.text
                       boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                       attributes:textDic context:nil].size;
    
    // textField的最小宽度 xib中约束margin为140
    CGFloat minWidth = SCREEN_WIDTH - 140;
    CGFloat textFieldWidth = autoSize.width > minWidth ?autoSize.width : minWidth;
    
    self.valueTextFieldWidth.constant = textFieldWidth;
    self.scrollView.contentSize  = CGSizeMake(textFieldWidth, 44);
    
    self.scrollView.contentOffset = CGPointMake(textFieldWidth - minWidth, 0);
    
    if ( [self.delegate respondsToSelector:@selector(valueTextFieldChange:)]) {
        [self.delegate valueTextFieldChange:self.valueTextField];
    }

}


@end
