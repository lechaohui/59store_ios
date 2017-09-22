//
//  HXSKeyAndTextViewCell.m
//  store
//
//  Created by 格格 on 16/9/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintKeyAndTextViewCell.h"

#import "NSString+PrintYFEmoji.h"
#import "HXMacrosUtils.h"

@interface HXSPrintKeyAndTextViewCell ()<UITextViewDelegate>

@end

@implementation HXSPrintKeyAndTextViewCell

+ (instancetype)keyAndTextViewCell
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStorePrint" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    return [bundle loadNibNamed:NSStringFromClass([self class])
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
    NSString *inputString = self.valueTextField.text;
    inputString = [inputString stringByRemoveAllEmoji];
    
    // 需求中输入限制最长为40个字符
    if (self.valueTextField.text.length > 40) {
        self.valueTextField.text = [self.valueTextField.text substringToIndex:40];
    }
    
    self.valueTextField.text = inputString;
    
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
