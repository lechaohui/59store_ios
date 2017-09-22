//
//  HXStoreDocumentLibraryBaseViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/13.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryBaseViewController.h"

//vc
#import "HXSMyFilesPrintViewController.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"
#import "HXStoreDocumentSearchViewModel.h"
#import "HXStoreDocumentLibraryPersistencyManger.h"
#import "HXSPrintDownloadsObjectEntity.h"
#import "HXSDocumentPersistencyManger.h"

@interface HXStoreDocumentLibraryBaseViewController ()

@property (nonatomic, strong) HXStoreDocumentLibraryViewModel                      *documentViewModel;
@property (nonatomic, strong) HXStoreDocumentLibraryPersistencyManger              *persistencyManager;
@property (nonatomic, strong) UIButton                                             *badgeButton;
@property (nonatomic, strong) UILabel                                              *badgeLabel;
@property (nonatomic, assign) CGFloat                                              badgeWidth;
@property (nonatomic, strong) HXSDocumentPersistencyManger                         *printPersistencyManager;

@end

@implementation HXStoreDocumentLibraryBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavaigationRightBarItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self checkRightBarButtonBadgeWithNoNeedAnimation:NO];
}


#pragma mark - init

- (void)initNavaigationRightBarItem
{
    [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem];
}


#pragma mark - refreshBadge

- (void)refreshBadgeActionWithNoNeedAnimation:(BOOL)noNeedAnimation;
{
    [self checkRightBarButtonBadgeWithNoNeedAnimation:noNeedAnimation];
}

#pragma mark - JumpAction

/**
 *  跳转到我的文件
 */
- (void)jumpToMyFilesAction
{
    HXSMyFilesPrintViewController *filePrintVC = [HXSMyFilesPrintViewController createFilesPrintVCWithEntity:nil];
    [self copyDocArrayToPrint];
    [self.navigationController pushViewController:filePrintVC animated:YES];
}


#pragma mark - badge setting

- (void)setBadgeStr:(NSInteger)badgeValue andNoNeedAnimation:(BOOL)noNeedAnimation
{
    if(badgeValue == 0) {
        [_badgeLabel setText:@""];
        _badgeWidth = 0;
    } else if(badgeValue < 99) {
        [_badgeLabel setText:[NSString stringWithFormat:@"%zd",badgeValue]];
        _badgeWidth = 14;
    } else {
        [_badgeLabel setText:@"99+"];
        _badgeWidth = 20;
    }
    
    if(noNeedAnimation) {
        
        [_badgeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_badgeButton.mas_right).offset(- (_badgeWidth / 2));
            make.bottom.equalTo(_badgeButton.mas_top).offset(_badgeWidth / 2);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        [self.badgeButton layoutIfNeeded];
        
        [_badgeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_badgeButton.mas_right).offset(- (_badgeWidth / 2));
            make.bottom.equalTo(_badgeButton.mas_top).offset(_badgeWidth / 2);
            make.width.mas_equalTo(_badgeWidth);
            make.height.mas_equalTo(_badgeWidth);
        }];
        
        [UIView animateWithDuration:0.4 animations:^{
            [self.badgeButton layoutIfNeeded];
        }];
    } else {
        [_badgeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_badgeButton.mas_right).offset(- (_badgeWidth / 2));
            make.bottom.equalTo(_badgeButton.mas_top).offset(_badgeWidth / 2);
            make.width.mas_equalTo(_badgeWidth);
            make.height.mas_equalTo(_badgeWidth);
        }];
    }
    
    _badgeLabel.layer.cornerRadius = _badgeWidth / 2;
    _badgeLabel.layer.masksToBounds = YES;
}


#pragma mark - copy array elements to Print

- (void)copyDocArrayToPrint
{
    [self setBadgeStr:0 andNoNeedAnimation:NO];
}


#pragma mark - check badge

- (void)checkRightBarButtonBadgeWithNoNeedAnimation:(BOOL)noNeedAnimation
{
    NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *array = [self.persistencyManager loadLibrarySavedDocumentWithFilePath:documentLibraryAddToPrintDocFilePath];
    if(!array
       || array.count == 0) {
        [self setBadgeStr:0 andNoNeedAnimation:noNeedAnimation];
    } else {
        [self setBadgeStr:array.count andNoNeedAnimation:noNeedAnimation];
    }
}

#pragma mark - getter

- (UIBarButtonItem *)rightBarButtonItem
{
    if(nil == _rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.badgeButton];
    }
    
    return _rightBarButtonItem;
}

- (HXStoreDocumentLibraryViewModel *)documentViewModel
{
    if(nil == _documentViewModel) {
        _documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _documentViewModel;
}

- (UILabel *)badgeLabel
{
    if(nil == _badgeLabel) {
        _badgeLabel = [[UILabel alloc]init];
        [_badgeLabel setText:@""];
        [_badgeLabel setBackgroundColor:[UIColor colorWithRGBHex:0xf54642]];
        [_badgeLabel setTextColor:[UIColor whiteColor]];
        [_badgeLabel setFont:[UIFont systemFontOfSize:10]];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeWidth = 0;//初始化高宽
        _badgeLabel.layer.cornerRadius = _badgeWidth / 2;
        _badgeLabel.layer.masksToBounds = YES;
    }
    
    return _badgeLabel;
}

- (UIButton *)badgeButton
{
    if(nil == _badgeButton) {
        _badgeButton = [[UIButton alloc]init];
        _badgeButton.frame = CGRectMake(0, 0, 24, 24);
        _badgeButton.backgroundColor = [UIColor clearColor];
        UIImage *rightItemImage = [self.documentViewModel imageFromNewName:@"ic_wenjian_white"];
        [_badgeButton setImage:rightItemImage forState:UIControlStateNormal];
        [_badgeButton addTarget:self
                         action:@selector(jumpToMyFilesAction)
               forControlEvents:UIControlEventTouchUpInside];
        [_badgeButton addSubview:self.badgeLabel];
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_badgeButton.mas_right).offset(- (_badgeWidth / 2));
            make.bottom.equalTo(_badgeButton.mas_top).offset(_badgeWidth / 2);
            make.width.mas_equalTo(_badgeWidth);
            make.height.mas_equalTo(_badgeWidth);
        }];
    }
    
    return _badgeButton;
}

- (HXStoreDocumentLibraryPersistencyManger *)persistencyManager
{
    if(nil == _persistencyManager) {
        _persistencyManager = [[HXStoreDocumentLibraryPersistencyManger alloc]init];
    }
    
    return _persistencyManager;
}

- (HXSDocumentPersistencyManger *)printPersistencyManager
{
    if(nil == _printPersistencyManager) {
        _printPersistencyManager = [[HXSDocumentPersistencyManger alloc]init];
    }
    
    return _printPersistencyManager;
}

@end
