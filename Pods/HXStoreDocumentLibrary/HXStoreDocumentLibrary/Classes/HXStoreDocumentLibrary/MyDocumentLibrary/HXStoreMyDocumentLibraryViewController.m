//
//  HXStoreMyDocumentLibraryViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/24.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreMyDocumentLibraryViewController.h"

//vc
#import "HXStoreDocumentLibraryReviewViewController.h"

//views
#import "HXStoreMyDocumentLibraryTableViewCell.h"
#import "HXSActionSheet.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"
#import "UITableView+RowsSectionsTools.h"

@interface HXStoreMyDocumentLibraryViewController ()

@property (weak, nonatomic) IBOutlet UITableView                    *mainTableView;
@property (weak, nonatomic) IBOutlet UIImageView                    *noDateImageView;
@property (weak, nonatomic) IBOutlet UILabel                        *noDateLabel;
@property (nonatomic, strong) HXStoreDocumentLibraryDocumentModel   *needToBeRemovedModel;
@property (nonatomic, strong) HXSCustomAlertView                    *deleteAlertView;
@property (nonatomic, strong) NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *dataSourceArray;
@property (nonatomic, assign) BOOL                                  isLoading;
@property (nonatomic, strong) HXSPrintListParamModel                *listParamModel;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel       *viewModel;

@end

@implementation HXStoreMyDocumentLibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initTableView];
    
    [self fetchMyDocumentLibraryNetworkingIsNew:YES
                              isHeaderRefresher:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - create

+ (instancetype)createMyDocumentLibraryVC
{
    HXStoreMyDocumentLibraryViewController *vc = [HXStoreMyDocumentLibraryViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    return vc;
}

#pragma mark - init

- (void)initNavigationBar
{
    [self.navigationItem setTitle:@"我的文库贡献"];
}

- (void)initTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXStoreMyDocumentLibraryTableViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXStoreMyDocumentLibraryTableViewCell class])];
    
    WS(weakSelf);
    [_mainTableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchMyDocumentLibraryNetworkingIsNew:YES
                                      isHeaderRefresher:YES];
    }];
    
    [_mainTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMyDocumentLibraryNetworkingIsNew:NO
                                      isHeaderRefresher:NO];
    }];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_dataSourceArray
       && _dataSourceArray.count >0) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreMyDocumentLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreMyDocumentLibraryTableViewCell class])
                                                                            forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreMyDocumentLibraryTableViewCell *tempCell = (HXStoreMyDocumentLibraryTableViewCell *)cell;
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:indexPath.row];
    [tempCell initMyDocumentLibraryCellWithDocModel:docModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:indexPath.row];
    HXStoreDocumentLibraryReviewViewController *reviewVC = [HXStoreDocumentLibraryReviewViewController createReviewVCWithDocId:docModel.docIdStr];
    if(docModel.verifyStatusNum.integerValue != HXSLibraryDocumentVerifyStatusPass) {
        reviewVC.isNoNeedToShowBottomViewAndRightBarButton = YES;
    }
    [self.navigationController pushViewController:reviewVC animated:YES];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消分享";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        if(editingStyle == UITableViewCellEditingStyleDelete)
        {
            HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:indexPath.row];
            WS(weakSelf);
            if(docModel.verifyStatusNum.integerValue != HXSLibraryDocumentVerifyStatusChecking) {
                self.deleteAlertView.rightBtnBlock = ^{
                    [weakSelf confirmDeleteShareDocNetworkingWithDocModel:docModel];
                };
                [self.deleteAlertView show];
            }
        }
    }

}

/*
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
}
 */

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:indexPath.row];
    UITableViewRowAction *button;
    WS(weakSelf);
    button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消分享" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
              {
                  if(docModel.verifyStatusNum.integerValue != HXSLibraryDocumentVerifyStatusChecking) {
                      weakSelf.deleteAlertView.rightBtnBlock = ^{
                            [weakSelf confirmDeleteShareDocNetworkingWithDocModel:docModel];
                      };
                      [weakSelf.deleteAlertView show];
                  }
              }];
    if(docModel.verifyStatusNum.integerValue == HXSLibraryDocumentVerifyStatusChecking) {
        button.backgroundColor = [UIColor colorWithRGBHex:0xCCCCCC];
    } else {
        button.backgroundColor = [UIColor colorWithRGBHex:0xfc7170];
    }
    return @[button];
}


#pragma mark - networking

- (void)fetchMyDocumentLibraryNetworkingIsNew:(BOOL)isNew
                            isHeaderRefresher:(BOOL)isHeaderRefresher
{
    if(_isLoading) {
        return;
    }
    _isLoading = YES;
    
    //设置最后的id参数
    if(_dataSourceArray
       && [_dataSourceArray count] > 0
       && !isNew) {
        self.listParamModel.offset = @(_dataSourceArray.count);
    } else {
        self.listParamModel.offset = @(0);
    }
    
    WS(weakSelf);
    if(isNew
       && !isHeaderRefresher) {
        [MBProgressHUD showInView:self.view];
    }
    
    [self.viewModel fetchPrintDormShopShareDocWithShopId:nil
                                       andParamListModel:self.listParamModel
                                                complete:^(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *array)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         weakSelf.isLoading = NO;
         if(kHXSNoError == code) {
             
             if(isNew) {
                 weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                 [weakSelf.dataSourceArray addObjectsFromArray:array];
             } else {
                 if(!weakSelf.dataSourceArray) {
                     weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                 }
                 [weakSelf.dataSourceArray addObjectsFromArray:array];
             }
             
             [weakSelf.mainTableView reloadData];
         }
         else {
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:message
                                            afterDelay:1.5];
         }
         [[weakSelf.mainTableView infiniteScrollingView] stopAnimating];
         [weakSelf.mainTableView endRefreshing];
         [weakSelf checkCurrentDocNumsAndSetNoDate];
     }];
}

/**
 *  弹出框的删除网络请求操作
 */
- (void)confirmDeleteShareDocNetworkingWithDocModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    WS(weakSelf);
    [MBProgressHUD showInView:self.view];
    [self.viewModel cancelDocumentShareWithDocId:docModel.docIdStr
                                        Complete:^(HXSErrorCode code, NSString *message, BOOL success)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(kHXSNoError == code) {
            NSInteger index = [weakSelf.dataSourceArray indexOfObject:docModel];
            [weakSelf.dataSourceArray removeObject:docModel];
            
            [weakSelf.mainTableView deleteSingleRowWithRowIndex:index
                                                andSectionIndex:0
                                             andDataSourceArray:_dataSourceArray
                                                   andAnimation:UITableViewRowAnimationFade
                                                       Complete:^{
                                                           [weakSelf checkCurrentDocNumsAndSetNoDate];
                                                       }];
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5];
        }
    }];
}


#pragma mark - checkCurrentDocNumsAndSetNoDate

- (void)checkCurrentDocNumsAndSetNoDate
{
    if(!_dataSourceArray
       || _dataSourceArray.count == 0) {
        [_mainTableView setHidden:YES];
        [_noDateLabel setHidden:NO];
        [_noDateImageView setHidden:NO];
    } else {
        [_mainTableView setHidden:NO];
        [_noDateLabel setHidden:YES];
        [_noDateImageView setHidden:YES];
    }
}


#pragma mark - getter

- (HXStoreDocumentLibraryViewModel *)viewModel
{
    if(nil == _viewModel) {
        _viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _viewModel;
}

- (HXSCustomAlertView *)deleteAlertView
{
    if(nil == _deleteAlertView) {
        _deleteAlertView = [[HXSCustomAlertView alloc]initWithTitle:nil
                                                            message:@"确定取消分享该文档？"
                                                    leftButtonTitle:@"取消"
                                                  rightButtonTitles:@"确定"];
    }
    
    return _deleteAlertView;
}

- (HXSPrintListParamModel *)listParamModel
{
    if(nil == _listParamModel) {
        _listParamModel = [HXSPrintListParamModel createDeafultParamModel];
    }
    
    return _listParamModel;
}

@end
