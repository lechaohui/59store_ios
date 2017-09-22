//
//  HXStoreDocumentLibrarySearchHeaderView.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/6.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibrarySearchHeaderView.h"

//others
#import "HXSPrintHeaderImport.h"

@interface HXStoreDocumentLibrarySearchHeaderView()

@property (nonatomic, strong) NSString *titileStr;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HXStoreDocumentLibrarySearchHeaderView

+ (instancetype)initDocumentLibrarySearchHeaderViewWithTitle:(NSString *)title
{
    HXStoreDocumentLibrarySearchHeaderView *headerView = [[HXStoreDocumentLibrarySearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.titileStr = title;
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
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupSubView
{
    [self addSubview:self.lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(16);
    }];
    
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineLabel.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - getter setter

- (UILabel *)titleLabel
{
    if(nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setText:_titileStr];
        [_titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor colorWithRGBHex:0x666666]];
    }
    
    return _titleLabel;
}

- (UILabel *)lineLabel
{
    if(nil == _lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        [_lineLabel setBackgroundColor:[UIColor colorWithRGBHex:0x333333]];
    }
    
    return _lineLabel;
}

@end
