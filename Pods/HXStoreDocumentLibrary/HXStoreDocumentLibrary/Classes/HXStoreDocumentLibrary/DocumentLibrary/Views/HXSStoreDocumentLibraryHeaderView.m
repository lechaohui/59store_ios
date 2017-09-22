//
//  HXSStoreDocumentLibraryHeaderView.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/9.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSStoreDocumentLibraryHeaderView.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//others
#import "HXStoreDocumentLibraryImport.h"

@interface HXSStoreDocumentLibraryHeaderView()

@property (nonatomic, strong) NSString      *titleStr;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIImageView   *iconImagView;

@end

@implementation HXSStoreDocumentLibraryHeaderView

+ (instancetype)initDocumentLibraryHeaderViewWithTitle:(NSString *)titleStr
{
    HXSStoreDocumentLibraryHeaderView *categoryView = [[HXSStoreDocumentLibraryHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    categoryView.titleStr = titleStr;
    
    [categoryView setupSubView];
    
    return categoryView;
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
    [self addSubview:self.iconImagView];
    [_iconImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImagView.mas_right).offset(10);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];
}


#pragma mark - getter setter

- (UILabel *)titleLabel
{
    if(nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setText:_titleStr];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    
    return _titleLabel;
}

- (UIImageView *)iconImagView
{
    if(nil == _iconImagView) {
        _iconImagView = [[UIImageView alloc]init];
        HXStoreDocumentLibraryViewModel *model = [[HXStoreDocumentLibraryViewModel alloc]init];
        [_iconImagView setImage:[model imageFromNewName:@"ic_toolbar_wenku_normal"]];
    }
    
    return _iconImagView;
}

@end
