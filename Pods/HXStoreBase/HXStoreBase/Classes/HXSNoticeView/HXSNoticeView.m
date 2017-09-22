//
//  HXSNoticeView.m
//  store
//
//  Created by ArthurWang on 16/1/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSNoticeView.h"
#import "HXMacrosUtils.h"
#import "HXSShopEntity.h"
#import "UIView+Extension.h"
#import "HXSLineView.h"

@interface HXSNoticeView ()

@property (nonatomic, copy) void (^onTouchInView)(void);

@end

@implementation HXSNoticeView


#pragma mark - Override Methods

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


#pragma mark - Public Methods

- (instancetype)initWithShopEntity:(HXSShopEntity *)shopEntity targetMethod:(void (^)(void))sender
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    if (self) {
        [self createWithShopEntity:shopEntity targetMethod:sender];
    }
    return self;
}

- (instancetype)createWithShopEntity:(HXSShopEntity *)shopEntity targetMethod:(void (^)(void))sender
{
    self.shopEntity = shopEntity;
    self.onTouchInView = sender;
    
    [self createNoticeView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onClickInView:)];
    [self addGestureRecognizer:tap];
    
    return self;
}


#pragma mark - Create Methods

- (void)createNoticeView
{
    self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.000 alpha:1.000];

    
    
    // 活动标记
    CGFloat padding = 5.0f;
    CGFloat widthOfImage = 16.0f;
    CGFloat yOfImage = (self.height - widthOfImage) / 2.0f;
    CGFloat lastX = 15.0f;
    
    // 公告符号
    UIImageView *noticeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(lastX, yOfImage, widthOfImage, widthOfImage)];
    noticeImageView.image = [UIImage imageNamed:@"ic_notice"];
    
    [self addSubview:noticeImageView];
    
    lastX += widthOfImage + padding;
    
    // 公告信息
    _noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(lastX, 0, self.width - lastX - 10, self.height)]; // 10 距离右边
    [_noticeLabel setFont:[UIFont systemFontOfSize:14]];
    [_noticeLabel setTextColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.000]];
    _noticeLabel.text = self.shopEntity.noticeStr;
    
    [self addSubview:_noticeLabel];
    
    // 添加上下两条线
    HXSLineView *topLine = [[HXSLineView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [topLine setBackgroundColor:[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1]];
    [self addSubview:topLine];
    
    HXSLineView *bottomLine = [[HXSLineView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 0.5)];
    [bottomLine setBackgroundColor:[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1]];
    [self addSubview:bottomLine];
}


#pragma mark - Target Methods

- (void)onClickInView:(id)sender
{
    if (self.onTouchInView) {
        self.onTouchInView();
    }
}

@end
