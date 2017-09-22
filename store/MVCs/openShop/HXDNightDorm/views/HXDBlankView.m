//
//  HXDBlankView.m
//  59dorm
//
//  Created by BeyondChao on 16/5/13.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//  用于展示空白视图

#import "HXDBlankView.h"

@interface HXDBlankView ()

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *responseWords;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *attriTitleTextView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) MASConstraint *imageTopConstraint;

@end

@implementation HXDBlankView

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title {
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _imageName = imageName;
        _title = title;
        [self initialSubview];
    }
    return self;
}

- (instancetype)initWithImageName:(NSString *)imageName attributeTitle:(NSString *)title responseWords:(NSString *)responseWords{

    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        _imageName = imageName;
        _title = title;
        _responseWords = responseWords;
        [self initialSubviewWithAttributeTitle];
    }
    return self;
}

- (void)initialSubview {
    
    // 小图标
    [self addSubview:self.logoImageView];
    // 显示普通文本
    [self addSubview:self.titleLabel];
    // 布局
    WS(ws);
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        ws.imageTopConstraint = make.top.equalTo(ws).offset(SCREEN_HEIGHT * 130 / 667.0);
        make.centerX.equalTo(ws);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.logoImageView.mas_bottom).offset(16);
        make.centerX.equalTo(ws);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.90);
    }];
}

- (void)initialSubviewWithAttributeTitle {
    
    // 小图标
    [self addSubview:self.logoImageView];
    // 显示属性文本
    [self addSubview:self.attriTitleTextView];
    [self.attriTitleTextView sizeToFit];

    // 布局
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SCREEN_HEIGHT * 130 / 667.0);
        make.centerX.equalTo(self);
    }];
    [self.attriTitleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(16);
        make.centerX.equalTo(self);
    }];
}

- (void)setTitleFontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor {
    _titleLabel.font = [UIFont systemFontOfSize:fontSize];
    _titleLabel.textColor = titleColor;
}

- (void)updateImageTopConstraintConstant:(CGFloat)constant {
    self.imageTopConstraint.offset = constant;
}

#pragma mark - 懒加载

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:_imageName];
    }
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = self.title;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithRGBHex:0xD8D4CE];
    }
    return _titleLabel;
}

- (UITextView *)attriTitleTextView {
    if (_attriTitleTextView == nil) {
        _attriTitleTextView = [[UITextView alloc] init];
        _attriTitleTextView.scrollEnabled = NO;
        _attriTitleTextView.selectable = NO;
        _attriTitleTextView.editable = NO;
        _attriTitleTextView.backgroundColor = self.backgroundColor;
        NSRange tragetRange = [self.title rangeOfString:self.responseWords];
        NSMutableAttributedString *attriStrM = [[NSMutableAttributedString alloc] initWithString:self.title];
        NSDictionary *allAttriDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                      [UIColor colorWithRGBHex:0x5A7C9D], NSForegroundColorAttributeName,  nil];
        [attriStrM addAttributes:allAttriDict range:NSMakeRange(0, self.title.length)];
        
        
        
        NSDictionary *tragetAttriDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:16.0],                      NSFontAttributeName,
                                   MainLightBlue,                                       NSForegroundColorAttributeName,
                                   [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSUnderlineStyleAttributeName,  nil];
        [attriStrM addAttributes:tragetAttriDict range:tragetRange];

        _attriTitleTextView.attributedText = attriStrM;
        
        // add tapGesture
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
        gestureRecognizer.numberOfTouchesRequired = 1;
        gestureRecognizer.numberOfTapsRequired = 1;
        [_attriTitleTextView addGestureRecognizer:gestureRecognizer];

        _attriTitleTextView.textAlignment = NSTextAlignmentCenter;
    }
    return _attriTitleTextView;
}

#pragma mark - Tap Gesture 

- (void)textViewTapped:(UITapGestureRecognizer *)sender {
    
    // 获取点击区域中的文字
    NSString *word = [self getWordAtPosition:[sender locationInView:self.attriTitleTextView] textView:self.attriTitleTextView];
    
    if([_responseWords rangeOfString:word].location != NSNotFound){
        if (self.tapActionBlock) {
            self.tapActionBlock();
        }
    }
}

- (NSString*)getWordAtPosition:(CGPoint)position textView:(UITextView *)textView {
    //remove scrollOffset
    CGPoint correctedPoint = CGPointMake(position.x, textView.contentOffset.y + position.y);
    UITextPosition *tapPosition = [textView closestPositionToPoint:correctedPoint];
    UITextRange *wordRange = [textView.tokenizer rangeEnclosingPosition:tapPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    return [textView textInRange:wordRange];
}

#pragma public

- (void)updateMessage:(NSString *)newMessage {
    self.titleLabel.text = newMessage;
}

- (void)updateImageWithName:(NSString *)newImageName {
    self.logoImageView.image = [UIImage imageNamed:newImageName];
}

@end
