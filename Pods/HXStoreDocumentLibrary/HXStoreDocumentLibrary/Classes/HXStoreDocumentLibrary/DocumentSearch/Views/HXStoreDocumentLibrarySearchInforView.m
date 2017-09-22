//
//  HXStoreDocumentLibrarySearchInforView.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/7.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibrarySearchInforView.h"

//others
#import "HXSPrintHeaderImport.h"

@interface HXStoreDocumentLibrarySearchInforView()

@property (nonatomic, strong) NSString *titileStr;
@property (nonatomic, strong) UIColor  *titleColor;
@property (nonatomic, strong) UILabel  *titleLabel;

@end

@implementation HXStoreDocumentLibrarySearchInforView

+ (instancetype)initDocumentLibrarySearchInforViewWithTitle:(NSString *)title
                                          andBackGroudColor:(UIColor *)backGroundColor
                                               andTextColor:(UIColor *)titleColor
{
    HXStoreDocumentLibrarySearchInforView *headerView = [[HXStoreDocumentLibrarySearchInforView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.titileStr = title;
    [headerView setBackgroundColor:backGroundColor];
    headerView.titleColor = titleColor;
    [headerView setupSubView];
    return headerView;
}

#pragma mark - life cycle

-(void)drawRect:(CGRect)rect
{
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setupSubView
{
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - getter setter

- (UILabel *)titleLabel
{
    if(nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setText:_titileStr == nil ? @"" : _titileStr];
        [_titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:_titleColor == nil ? [UIColor blackColor] : _titleColor];
    }
    
    return _titleLabel;
}


@end
