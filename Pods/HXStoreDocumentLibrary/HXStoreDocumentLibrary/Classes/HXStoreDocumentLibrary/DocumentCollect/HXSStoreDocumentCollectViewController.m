//
//  HXSStoreDocumentCollectViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/6.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSStoreDocumentCollectViewController.h"
#import "HXSLoginViewController.h"
#import "HXStoreDocumentLibraryReviewViewController.h"
#import "HXStoreDocumentLibraryPaymentViewController.h"

//views
#import "HXStoreDocumentLibraryStarDocTableViewCell.h"
#import "HXSActionSheet.h"
#import "HXSShareView.h"
#import "HXSCustomAlertView.h"

//model
#import "HXStoreDocumentLibraryPersistencyManger.h"
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"
#import "HXSUserAccount.h"
#import "UITableView+RowsSectionsTools.h"

@interface HXSStoreDocumentCollectViewController ()

@property (weak, nonatomic) IBOutlet UITableView            *mainTableView;
@property (nonatomic, assign) NSInteger                     index;
@property (nonatomic, assign) CGFloat                       beginningOffsetY;
@property (weak, nonatomic) IBOutlet UIView                 *needLoginView;
@property (weak, nonatomic) IBOutlet UIView                 *noCollectView;
@property (weak, nonatomic) IBOutlet UIButton               *needToLoginButton;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel *documentViewModel;
@property (nonatomic, assign) BOOL                          isLoading;
@property (nonatomic, strong) NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *dataSourceArray;
@property (nonatomic, strong) HXStoreDocumentLibraryPersistencyManger   *persistencyManager;
@property (nonatomic, strong) HXSCustomAlertView            *buyAlertView;

@end

@implementation HXSStoreDocumentCollectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initLoginButton];
    
    [self checkLoginCollectsAndSetShow];
    
    [self initialNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.updateSelectionTitle(self.index);
}

- (void)dealloc
{
    self.updateSelectionTitle = nil;
    self.scrollviewScrolled   = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - create

+ (instancetype)createDocumentCollectVCWithIndex:(NSInteger)index;
{
    HXSStoreDocumentCollectViewController *vc = [HXSStoreDocumentCollectViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.index = index;
    
    return vc;
}


#pragma mark - init

- (void)initTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXStoreDocumentLibraryStarDocTableViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXStoreDocumentLibraryStarDocTableViewCell class])];
    
    WS(weakSelf);
    [_mainTableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchCollectDocNetworkingIsNew:YES
                               isHeaderRefresher:YES];
    }];
    
    [_mainTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchCollectDocNetworkingIsNew:NO
                               isHeaderRefresher:NO];
    }];
}

- (void)initLoginButton
{
    _needToLoginButton.layer.cornerRadius = 2;
    [_needToLoginButton.layer setMasksToBounds:YES];
}

- (void)initialNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLoginComplete:)
                                                 name:kLoginCompleted
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDocModel:)
                                                 name:kDocumentModelUpdated
                                               object:nil];
}


#pragma mark - Notification Methods

- (void)onLoginComplete:(NSNotification *)notification
{
    [self checkLoginCollectsAndSetShow];
}

- (void)updateDocModel:(NSNotification *)notification
{
    [self checkLoginCollectsAndSetShow];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if(_dataSourceArray
       && _dataSourceArray.count > 0){
        rows = _dataSourceArray.count;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryStarDocTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreDocumentLibraryStarDocTableViewCell class])
                                                                            forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 90.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryStarDocTableViewCell *tempCell = (HXStoreDocumentLibraryStarDocTableViewCell *)cell;
    [tempCell initPageTableViewCellWithMode:[_dataSourceArray objectAtIndex:indexPath.row]];
    [tempCell.optionButton addTarget:self
                              action:@selector(optionButtonClick:)
                    forControlEvents:UIControlEventTouchUpInside];
    [tempCell.optionButton setTag:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryDocumentModel *model = [_dataSourceArray objectAtIndex:indexPath.row];
    
    HXStoreDocumentLibraryReviewViewController *reviewVC = [HXStoreDocumentLibraryReviewViewController createReviewVCWithDocId:model.docIdStr];
    
    [self.navigationController pushViewController:reviewVC animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginningOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (0 < scrollView.contentSize.height) {
        if (nil != self.scrollviewScrolled) {
            self.scrollviewScrolled(CGPointMake(0, scrollView.contentOffset.y - self.beginningOffsetY));
        }
    }
}


#pragma mark - check login

- (void)checkLoginCollectsAndSetShow
{
    if(![HXSUserAccount currentAccount].isLogin) {
        [_needLoginView setHidden:NO];
        [_noCollectView setHidden:YES];
        [_mainTableView setHidden:YES];
    } else {
        [self checkHasCollects];
    }
}


#pragma mark login

/**
 *  检查是否有收藏文档
 */
- (void)checkHasCollects
{
    [_needLoginView setHidden:YES];
    [_noCollectView setHidden:YES];
    [_mainTableView setHidden:NO];
    
    if(_isLoading) {
        return;
    }
    _isLoading = YES;
    WS(weakSelf);
    [MBProgressHUD showInView:self.view];
    [self.documentViewModel fetchStarDocumentListWithOffset:@(0)
                                                   andLimit:@(DEFAULT_PAGESIZENUM)
                                                   Complete:^(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList) {
                                                       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                       weakSelf.isLoading = NO;
                                                       if(kHXSNoError == code
                                                          && modelList.count > 0) {
                                        
                                                           weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                                                           [_noCollectView setHidden:YES];
                                                           [_mainTableView setHidden:NO];
                                                           [weakSelf.dataSourceArray addObjectsFromArray:modelList];
                                                           
                                                           [weakSelf.mainTableView reloadData];
                                                       }
                                                       else {
                                                           [_noCollectView setHidden:NO];
                                                           [_mainTableView setHidden:YES];
                                                           [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                              status:message
                                                                                          afterDelay:1.5];
                                                       }
                                                       [[weakSelf.mainTableView infiniteScrollingView] stopAnimating];
                                                       [weakSelf.mainTableView endRefreshing];
                                                   }];
}


#pragma mark Button Action

- (IBAction)loginButtonAction:(id)sender
{
    WS(weakSelf);
    [HXSLoginViewController showLoginController:self loginCompletion:^{
        [weakSelf checkHasCollects];
    }];
}

/**
 *  底部弹出按钮列表
 *
 *  @param button 
 */
- (void)optionButtonClick:(UIButton *)button
{
    HXSActionSheetEntity *addToPrintQueueEntity = [[HXSActionSheetEntity alloc] init];
    addToPrintQueueEntity.nameStr = @"添加至打印队列";
    HXSActionSheetEntity *shareEntity = [[HXSActionSheetEntity alloc] init];
    shareEntity.nameStr = @"分享";
    HXSActionSheetEntity *cancelEntity = [[HXSActionSheetEntity alloc] init];
    cancelEntity.nameStr = @"取消收藏";
    __weak typeof(self) weakSelf = self;
    HXSAction *addToPrintQueueAction = [HXSAction actionWithMethods:addToPrintQueueEntity
                                                   handler:^(HXSAction *action){
                                                       [weakSelf addToPrintQueueActionWithIndex:button.tag];
                                                   }];
    HXSAction *shareAction = [HXSAction actionWithMethods:shareEntity
                                                  handler:^(HXSAction *action){
                                                      [weakSelf shareActionWithIndex:button.tag];
                                                  }];
    HXSAction *cancelAction = [HXSAction actionWithMethods:cancelEntity
                                                  handler:^(HXSAction *action){
                                                      [weakSelf unStarAction:button.tag];
                                                  }];
    
    HXSActionSheet *actionSheet = [HXSActionSheet actionSheetWithMessage:@""
                                                       cancelButtonTitle:@"取消"];
    [actionSheet addAction:addToPrintQueueAction];
    [actionSheet addAction:shareAction];
    [actionSheet addAction:cancelAction];
    
    [actionSheet show];
}

/**
 *  取消收藏操作
 */
- (void)unStarAction:(NSInteger)index
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:index];
    WS(weakSelf);
    [self.documentViewModel updateDocmentStarWithDocModelAndSaveLocal:docModel
                                                                andVC:self
                                                          andComplete:^(HXStoreDocumentLibraryDocumentModel *docModel)
    {
        [weakSelf unStarActionWithIndex:index];
    }];
}

/**
 *  分享操作
 *
 *  @param index
 */
- (void)shareActionWithIndex:(NSInteger)index
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:index];
    [self.documentViewModel createShareViewAndShowIn:self
                                        withDocModel:docModel];
}

/**
 *  添加到打印队列操作
 *
 *  @param index
 */
- (void)addToPrintQueueActionWithIndex:(NSInteger)index
{
    HXStoreDocumentLibraryDocumentModel *model = [_dataSourceArray objectAtIndex:index];
    if(![HXSUserAccount currentAccount].isLogin) {
        WS(weakSelf);
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            [weakSelf checkHasCollects];
        }];
        return;
    } else {
        
        if(![model.hasRightsNum boolValue]
           && [model.typeNum isEqualToNumber:@(HXSLibraryDocumentTypeBuy)]) {
            [self addToPrintShowAlertViewWithDoc:model];
            return;
        }

        [self.persistencyManager addDocumentToPrintQueueWithDoc:model
                                                          andVC:self];

        if (self.delegate
            && [self.delegate respondsToSelector:@selector(refreshBadge)]) {
            [self.delegate refreshBadge];
        }
    }
}

- (void)addToPrintShowAlertViewWithDoc:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    WS(weakSelf);
    self.buyAlertView.rightBtnBlock = ^{
        [weakSelf readyToBuyDocActionWithDocModel:docModel];
    };
    [self.buyAlertView show];
}

- (void)readyToBuyDocActionWithDocModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    HXStoreDocumentLibraryReviewViewController *reviewVC = [HXStoreDocumentLibraryReviewViewController createReviewVCWithDocId:docModel.docIdStr];
    
    [self.navigationController pushViewController:reviewVC animated:YES];
}


#pragma mark - delete action rows

/**
 *  取消收藏操作
 *
 *  @param index
 */
- (void)unStarActionWithIndex:(NSInteger)index
{
    [self deleteRowsForTableViewWithIndex:index];
}

/**
 *  取消收藏删除相关行并刷新
 *
 *  @param index
 */
- (void)deleteRowsForTableViewWithIndex:(NSInteger)index
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:index];
    
    [_dataSourceArray removeObject:docModel];
    
    WS(weakSelf);
    [_mainTableView deleteSingleRowWithRowIndex:index
                                andSectionIndex:0
                             andDataSourceArray:_dataSourceArray
                                   andAnimation:UITableViewRowAnimationFade
                                       Complete:^{
        [weakSelf.needLoginView setHidden:YES];
        [weakSelf.noCollectView setHidden:NO];
        [weakSelf.mainTableView setHidden:YES];
    }];
}


#pragma mark networking

/**
 *  获取收藏文档列表网络请求
 */
- (void)fetchCollectDocNetworkingIsNew:(BOOL)isNew
                     isHeaderRefresher:(BOOL)isHeaderRefresher
{
    if(_isLoading) {
        return;
    }
    _isLoading = YES;
    
    //设置最后的id参数
    NSNumber *tempCurrentLastID;
    if(_dataSourceArray
       && [_dataSourceArray count] > 0
       && !isNew) {
        tempCurrentLastID = @(_dataSourceArray.count);
    } else {
        tempCurrentLastID = @(0);
    }
    
    WS(weakSelf);
    if(isNew) {
        [MBProgressHUD showInView:self.view];
    }
    
    [self.documentViewModel fetchStarDocumentListWithOffset:tempCurrentLastID
                                                   andLimit:@(DEFAULT_PAGESIZENUM)
                                                   Complete:^(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         weakSelf.isLoading = NO;
         if(kHXSNoError == code) {
             
             if(isNew) {
                 weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                 [weakSelf.dataSourceArray addObjectsFromArray:modelList];
             } else {
                 if(!weakSelf.dataSourceArray) {
                     weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                 }
                 [weakSelf.dataSourceArray addObjectsFromArray:modelList];
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
    }];
}


#pragma mark - Get Set Methods

- (HXStoreDocumentLibraryViewModel *)documentViewModel
{
    if(nil == _documentViewModel) {
        _documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _documentViewModel;
}

- (NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *)dataSourceArray
{
    if(!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc] init];
    }
    
    return _dataSourceArray;
}

- (HXStoreDocumentLibraryPersistencyManger *)persistencyManager
{
    if(nil == _persistencyManager) {
        _persistencyManager = [[HXStoreDocumentLibraryPersistencyManger alloc]init];
    }
    
    return _persistencyManager;
}

- (HXSCustomAlertView *)buyAlertView
{
    if(nil == _buyAlertView) {
        _buyAlertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                         message:@"该文档为付费文档，\n需购买后才能打印文档"
                                                  leftButtonTitle:@"取消"
                                                rightButtonTitles:@"立即购买"];
    }
    
    return _buyAlertView;
}

@end
