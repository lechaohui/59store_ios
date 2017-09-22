//
//  HXSDocumentLibraryDiscoverHeaderView.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/10.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSDocumentLibraryDiscoverHeaderView.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"

typedef NS_ENUM(NSInteger, HXSDocumentLibraryDiscoverHeaderViewLoadStatus) {
    kHXSDocumentLibraryDiscoverHeaderViewLoadStatusSucc = 0,
    kHXSDocumentLibraryDiscoverHeaderViewLoadStatusLoading = 1,
    kHXSDocumentLibraryDiscoverHeaderViewLoadStatusFail= 2
};

@interface HXSDocumentLibraryDiscoverHeaderView()

@property (nonatomic, strong) NSNumber  *typeNum;
@property (nonatomic, strong) NSNumber  *offSet;
@property (nonatomic, strong) NSNumber  *limitNum;
@property (nonatomic, strong) NSString  *titleStr;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIButton  *exchangeButton;
@property (nonatomic, strong) UIButton  *exchangeImageButton;
@property (nonatomic, assign) HXSDocumentLibraryDiscoverHeaderViewLoadStatus currentLoadStatus;
@property (nonatomic, assign) BOOL      isLoading;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel   *documentViewModel;
@property (nonatomic, assign) BOOL      isInColdingDown;//x秒冷却
@property (nonatomic, strong) NSString  *timerStr;

@end

@implementation HXSDocumentLibraryDiscoverHeaderView

+ (instancetype)initWithType:(NSNumber *)type
                   andOffset:(NSNumber *)offSet
                    andLimit:(NSNumber *)limitNum
                    andTitle:(NSString *)title
{
    HXSDocumentLibraryDiscoverHeaderView *headerView = [[HXSDocumentLibraryDiscoverHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.typeNum  = type;
    headerView.offSet   = offSet;
    headerView.limitNum = limitNum;
    headerView.titleStr = title;
    headerView.currentLoadStatus = kHXSDocumentLibraryDiscoverHeaderViewLoadStatusSucc;
    
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
        self.backgroundColor = [UIColor colorWithRGBHex:0xf5f6f7];
    }
    return self;
}

- (void)setupSubView
{
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.exchangeImageButton];
    [_exchangeImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.exchangeButton];
    [_exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_exchangeImageButton.mas_left).offset(-10);
        make.centerY.equalTo(self);
    }];
}


#pragma mark - Button Action

- (void)refreshDocAction
{
    [self fetchExchangeFindingNetworking];
}

- (void)refreshButtonStatus
{
    switch (_currentLoadStatus) {
        case kHXSDocumentLibraryDiscoverHeaderViewLoadStatusSucc: {
            [_exchangeButton setTitle:@"换一批" forState:UIControlStateNormal];
            [_exchangeButton setTitleColor:[UIColor colorWithRGBHex:0x333333]
                                  forState:UIControlStateNormal];
            break;
        }
        case kHXSDocumentLibraryDiscoverHeaderViewLoadStatusLoading: {
            [_exchangeButton setTitle:@"加载中..." forState:UIControlStateNormal];
            [_exchangeButton setTitleColor:[UIColor colorWithRGBHex:0x999999]
                                  forState:UIControlStateNormal];
            break;
        }
        case kHXSDocumentLibraryDiscoverHeaderViewLoadStatusFail: {
            [_exchangeButton setTitle:@"加载失败" forState:UIControlStateNormal];
            [_exchangeButton setTitleColor:[UIColor colorWithRGBHex:0xf54642]
                                  forState:UIControlStateNormal];
            break;
        }
    }
}

#pragma mark - networking

- (void)fetchExchangeFindingNetworking
{
    if(_isLoading) {
        return;
    }
    
    if(_isInColdingDown) {
        return;
    }
    _isInColdingDown = YES;
    NSTimer *timer = [NSTimer timerWithTimeInterval:5
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:nil
                                            repeats:NO];
    
    NSRunLoop *runloop=[NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    
    
    _isLoading = YES;
    [self refreshButtonStatus];
    WS(weakSelf);
    _currentLoadStatus = kHXSDocumentLibraryDiscoverHeaderViewLoadStatusLoading;
    [self refreshButtonStatus];
    [self.documentViewModel fetchFindingExchangeDocumentListWithType:_typeNum
                                                           andOffser:_offSet
                                                           andLimits:_limitNum
                                                            Complete:^(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList)
    {
        weakSelf.isLoading = NO;
        if(kHXSNoError == code) {
            weakSelf.offSet = @([_offSet integerValue] + modelList.count);
            weakSelf.currentLoadStatus = kHXSDocumentLibraryDiscoverHeaderViewLoadStatusSucc;
            if (weakSelf.delegate
                && [weakSelf.delegate respondsToSelector:@selector(reloadFindingWithSection:andDocList:)]) {
                
                NSInteger section;                
                switch ([weakSelf.typeNum integerValue]) {
                    case HXSDocumentLibraryDiscoverHeaderTypeSuppose:
                        
                        section = 0;
                        
                        break;
                        
                    case HXSDocumentLibraryDiscoverHeaderTypeNearby:
                        
                        section = 2;
                        
                        break;
                        
                    case HXSDocumentLibraryDiscoverHeaderTypeRecommend:
                        
                        section = 1;
                        
                        break;
                        
                }
                
                [weakSelf.delegate reloadFindingWithSection:section
                                                 andDocList:modelList];
            }
        } else {
            weakSelf.currentLoadStatus = kHXSDocumentLibraryDiscoverHeaderViewLoadStatusFail;
        }
        [weakSelf refreshButtonStatus];
        
    }];
}


- (void)timerFireMethod:(NSTimer *)timer
{
    [timer invalidate];
    _isInColdingDown = NO;
}


#pragma mark - getter setter

- (UILabel *)titleLabel
{
    if(nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setTextColor:[UIColor colorWithRGBHex:0x757575]];
        [_titleLabel setText:_titleStr];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    
    return _titleLabel;
}

- (UIButton *)exchangeButton
{
    if(nil == _exchangeButton) {
        _exchangeButton = [[UIButton alloc]init];
        [_exchangeButton setBackgroundColor:[UIColor clearColor]];
        [_exchangeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_exchangeButton setTitle:@"换一批" forState:UIControlStateNormal];
        [_exchangeButton setTitleColor:[UIColor colorWithRGBHex:0x333333]
                              forState:UIControlStateNormal];
        _exchangeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_exchangeButton addTarget:self
                            action:@selector(refreshDocAction)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exchangeButton;
}

- (UIButton *)exchangeImageButton
{
    if(nil == _exchangeImageButton) {
        _exchangeImageButton = [[UIButton alloc]init];
        [_exchangeImageButton setBackgroundColor:[UIColor clearColor]];
        
        HXStoreDocumentLibraryViewModel *documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
        [_exchangeImageButton setImage:[documentViewModel imageFromNewName:@"ic_refresh_gray"]
                         forState:UIControlStateNormal];
        [_exchangeImageButton addTarget:self
                            action:@selector(refreshDocAction)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exchangeImageButton;
}

- (HXStoreDocumentLibraryViewModel *)documentViewModel
{
    if(nil == _documentViewModel) {
        _documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _documentViewModel;
}

- (NSString *)timerStr
{
    if(nil == _timerStr) {
        _timerStr = @"cd";
        NSTimer *timer = [NSTimer timerWithTimeInterval:5
                                                 target:self
                                               selector:@selector(timerFireMethod:)
                                               userInfo:nil
                                                repeats:NO];
        
        NSRunLoop *runloop=[NSRunLoop currentRunLoop];
        [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
        
    }
    
    return _timerStr;
}

@end
