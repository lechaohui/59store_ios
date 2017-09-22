//
//  HXStoreDocumentLibraryShareViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryShareViewController.h"

//vc
#import "HXSWebViewController.h"
#import "HXStoreDocumentLibraryShareTagSettingViewController.h"
#import "HXStoreDocumentLibraryShareSuccessViewController.h"
#import "HXSLoginViewController.h"

//views
#import "HXStoreDocumentLibraryShareTableViewCell.h"
#import "HXStoreDocumentLibraryShareTagsTableViewCell.h"
#import "HXStoreDocumentLibrarySharePriceTableViewCell.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"
#import "HXStoreDocumentLibraryPersistencyManger.h"

//other
#import "HXStoreDocumentLibraryImport.h"
#import "UITableView+RowsSectionsTools.h"
#import "NSString+InputLimit.h"

typedef NS_ENUM(NSInteger,HXSLibraryShareRowsIndex){
    HXSLibraryShareRowsIndexName             = 0,//文档名称
    HXSLibraryShareRowsIndexTags             = 1,//文档标签
    HXSLibraryShareRowsIndexPrice            = 2//文档价格
};

NSInteger const maxPricePointRange = 2;//小数点后两位
CGFloat   const maxDocPriceEnter   = 99.99;//最大文档价格

@interface HXStoreDocumentLibraryShareViewController ()<HXStoreDocumentLibraryShareTagSettingViewControllerDelegate,
                                                        UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView                                    *mainTableView;
@property (nonatomic, strong) NSMutableArray<HXSMyPrintOrderItem *>                 *cartArray;
@property (nonatomic, strong) NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *dataSourceArray;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel                       *viewModel;
@property (nonatomic, strong) HXStoreDocumentLibraryPersistencyManger               *persistencyManager;
@property (weak, nonatomic) IBOutlet UIView                                         *bottomView;
@property (nonatomic, strong) UIBarButtonItem                                       *rightBarButton;
@property (weak, nonatomic) IBOutlet UIButton                                       *anonymousButton;
@property (weak, nonatomic) IBOutlet UIButton                                       *confirmShareButton;
@property (nonatomic, strong) HXSCustomAlertView                                    *leaveAlertView;
@property (nonatomic, strong) UIBarButtonItem                                       *backBarButton;

@end

@implementation HXStoreDocumentLibraryShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - create

+ (instancetype)createDocumentLibraryShareVCWithArray:(NSMutableArray<HXSMyPrintOrderItem *> *)array;
{
    HXStoreDocumentLibraryShareViewController *vc = [HXStoreDocumentLibraryShareViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    vc.cartArray       = array;
    vc.dataSourceArray = [vc.viewModel convertOrderItemArrayToDocLibArray:array];
    
    return vc;
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"文档分享";
    
    [self.navigationItem setRightBarButtonItem:self.rightBarButton];
    
    [self.navigationItem setLeftBarButtonItem:self.backBarButton];
}

- (void)initTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXStoreDocumentLibraryShareTableViewCell class])
                                               bundle:bundle]
         forCellReuseIdentifier:NSStringFromClass([HXStoreDocumentLibraryShareTableViewCell class])];
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXStoreDocumentLibraryShareTagsTableViewCell class])
                                               bundle:bundle]
         forCellReuseIdentifier:NSStringFromClass([HXStoreDocumentLibraryShareTagsTableViewCell class])];
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXStoreDocumentLibrarySharePriceTableViewCell class])
                                               bundle:bundle]
         forCellReuseIdentifier:NSStringFromClass([HXStoreDocumentLibrarySharePriceTableViewCell class])];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    
    if(_dataSourceArray
       && _dataSourceArray.count > 0) {
        section = _dataSourceArray.count;
    }
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:section];
    
    NSInteger rows = 1;
    
    if(docModel.isShowTagsAndPrice) {
        rows = 3;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:indexPath.section];
    
    if(docModel.isShowTagsAndPrice) {
        
        switch (indexPath.row)
        {
            case HXSLibraryShareRowsIndexTags:
            {
                HXStoreDocumentLibraryShareTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreDocumentLibraryShareTagsTableViewCell class])
                                                                                                 forIndexPath:indexPath];
                return cell;
            }
                break;
                
            case HXSLibraryShareRowsIndexPrice:
            {
                HXStoreDocumentLibrarySharePriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreDocumentLibrarySharePriceTableViewCell class])
                                                                                                     forIndexPath:indexPath];
                return cell;
            }
                break;
                
            default:
            {
                HXStoreDocumentLibraryShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreDocumentLibraryShareTableViewCell class])
                                                                                                 forIndexPath:indexPath];
                return cell;
            }
                break;
        }
        
    } else {
        HXStoreDocumentLibraryShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreDocumentLibraryShareTableViewCell class])
                                                                                         forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:indexPath.section];
    
    if(docModel.isShowTagsAndPrice) {
        
        switch (indexPath.row)
        {
            case HXSLibraryShareRowsIndexTags:
            {
                HXStoreDocumentLibraryShareTagsTableViewCell *tempCell = (HXStoreDocumentLibraryShareTagsTableViewCell *)cell;
                [tempCell initDocumentLibraryShareTagsCellWithDocModel:docModel];
            }
                break;
                
            case HXSLibraryShareRowsIndexPrice:
            {
                HXStoreDocumentLibrarySharePriceTableViewCell *tempCell = (HXStoreDocumentLibrarySharePriceTableViewCell *)cell;
                tempCell.priceTextField.delegate = self;
                [tempCell.priceTextField setTag:indexPath.section];
                [tempCell initDocumentLibrarySharePriceCellWithPriceNum:docModel.priceDecNum];
            }
                break;
                
            default:
            {
                HXStoreDocumentLibraryShareTableViewCell *tempCell = (HXStoreDocumentLibraryShareTableViewCell *)cell;
                [tempCell initDocumentLibraryShareCellWithDocModel:docModel];
            }
                break;
        }
        
    } else {
        HXStoreDocumentLibraryShareTableViewCell *tempCell = (HXStoreDocumentLibraryShareTableViewCell *)cell;
        [tempCell initDocumentLibraryShareCellWithDocModel:docModel];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:indexPath.section];
    NSInteger sectionIndex = [_dataSourceArray indexOfObject:docModel];
    
    if(docModel.isShowTagsAndPrice
       && indexPath.row == HXSLibraryShareRowsIndexTags) {
        [self jumpToTagsViewControllerActionWithDocModel:docModel];
    }
    
    else if(indexPath.row == HXSLibraryShareRowsIndexName) {
        
        if(!docModel.isShowTagsAndPrice) {
            docModel.isShowTagsAndPrice = YES;
        } else {
            docModel.isShowTagsAndPrice = NO;
        }
        
        [_mainTableView reloadSectionsWithSectionIndex:sectionIndex
                                          andAnimation:UITableViewRowAnimationFade];
        
        [self checkCurrentShareStatusAndSettingBottomView];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - HXStoreDocumentLibraryShareTagSettingViewControllerDelegate

- (void)saveTags:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    NSInteger section = 0;
    
    for (HXStoreDocumentLibraryDocumentModel *model in _dataSourceArray) {
        if([model.pdfMd5Str isEqualToString:docModel.pdfMd5Str]) {
            model.tagsStr = docModel.tagsStr;
            section = [_dataSourceArray indexOfObject:model];
            [_mainTableView reloadSectionsWithSectionIndex:section
                                              andAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{    
    //判断小数点只有两位
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL isPass = [newString checkInputRestrictDigitsWithCounts:maxPricePointRange];
    if(!isPass) {
        return isPass;
    }
    
    NSInteger index = textField.tag;
    NSMutableString *stringText = [[NSMutableString alloc]initWithString:textField.text];
    if(![[string trim] isEqualToString:@""]) {
        [stringText appendString:string];
    }
    
    [self settingPriceToModelPriceNum:stringText
                             andIndex:index];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger index = textField.tag;
    NSString *text = textField.text;
    
    CGFloat price = [text doubleValue];
    if(price > maxDocPriceEnter) {
        NSString *message = [NSString stringWithFormat:@"文档价格不得超过%.2f元",maxDocPriceEnter];
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:message
                                       afterDelay:1.5];
        text = @"0";//clear price
        [textField setText:text];
    }
    
    [self settingPriceToModelPriceNum:text
                             andIndex:index];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSInteger index = textField.tag;
    [textField resignFirstResponder];
    
    [self settingPriceToModelPriceNum:@""
                             andIndex:index];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


#pragma mark - check Bottom View Button Status

/**
 *检测当前选中的文件状态来决定底部按钮的状态
 */
- (void)checkCurrentShareStatusAndSettingBottomView
{
    BOOL hasSelectDoc = NO;
    NSInteger selectedDocCounts = 0;
    
    for (HXStoreDocumentLibraryDocumentModel *model in _dataSourceArray) {
        if(model.isShowTagsAndPrice) {
            hasSelectDoc = YES;
            selectedDocCounts++;
        }
    }
    
    NSString *contentStr = [NSString stringWithFormat:@"确认分享(%zd)",selectedDocCounts];
    [_confirmShareButton setEnabled:hasSelectDoc];
    [_confirmShareButton setTitle:contentStr forState:UIControlStateNormal];
    [_confirmShareButton setTitle:contentStr forState:UIControlStateDisabled];
}


#pragma mark - networking

- (void)uploadShareDocumentLibraryListNetworkingWithIsAnonymous:(NSNumber *)isAnonymousNum
                                                andDocListArray:(NSMutableArray<HXStoreDocumentLibraryUploadDocShareParamModel *> *)docListArray
{
    [MBProgressHUD showInView:self.view];
    WS(weakSelf);
    [self.viewModel upLoadDocumentShareWithIsAnonymous:isAnonymousNum
                                       andDocListArray:docListArray
                                              Complete:^(HXSErrorCode code, NSString *message, BOOL success)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view
                              animated:YES];
         if(kHXSNoError == code
            && success) {
             [weakSelf jumpToShareSuccessVC];
         } else if(kHXSNetWorkError != code) {
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:@"分享失败，请重试"
                                            afterDelay:1.5];
         } else {
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:message
                                            afterDelay:1.5];
         }
     }];
}


#pragma mark - Button Action

- (void)rightBarButtonAction
{
    [self jumpToDocumentShareHelpWebVCAction];
}

- (IBAction)anonymousButtonAction:(id)sender
{
    if(_anonymousButton.isSelected) {
        [_anonymousButton setSelected:NO];
    } else {
        [_anonymousButton setSelected:YES];
    }
}

- (IBAction)confrimToShareButtonAction:(id)sender
{
    BOOL hasSomeDocNoTag = NO;
    for (HXStoreDocumentLibraryDocumentModel *docModel in _dataSourceArray) {
        if(!docModel.tagsStr
           || [[docModel.tagsStr trim] isEqualToString:@""]) {
            hasSomeDocNoTag = YES;
            break;
        }
    }
    
    if(hasSomeDocNoTag) {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"请先设置标签"
                                       afterDelay:1.5];
        return;
    }
    
    WS(weakSelf);
    if([HXSUserAccount currentAccount].isLogin) {
        NSNumber *isAnonymousNum = [NSNumber numberWithBool:[_anonymousButton isSelected]];
        NSMutableArray<HXStoreDocumentLibraryUploadDocShareParamModel *> *array = [self.viewModel convertNormalDocModelArrayToParamModelArray:_dataSourceArray];
        [self uploadShareDocumentLibraryListNetworkingWithIsAnonymous:isAnonymousNum
                                                      andDocListArray:array];
    } else {
        [HXSLoginViewController showLoginController:self
                                    loginCompletion:nil];
    }
}

- (void)backBarButtonAction
{
    [self.leaveAlertView show];
}

#pragma mark - jumpAction

/**
 *跳转到标签设置界面
 */
- (void)jumpToTagsViewControllerActionWithDocModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    HXStoreDocumentLibraryShareTagSettingViewController *vc = [HXStoreDocumentLibraryShareTagSettingViewController createDocumentLibraryShareTagSettingWithDoc:docModel];
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToDocumentShareHelpWebVCAction
{
    NSString *url = [[ApplicationSettings instance] currentDocLibURL];
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)jumpToShareSuccessVC
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDocumentLibUploaded
                                                        object:nil
                                                      userInfo:nil];
    
    HXStoreDocumentLibraryShareSuccessViewController *shareSuccVC = [HXStoreDocumentLibraryShareSuccessViewController createDocumentLibraryShareSuccessVC];
    
    [self.persistencyManager checkShareDocModelArrayAndSaveLocalDownloadEntity:_dataSourceArray
                                                    andWithPrintOrderItemArray:_cartArray];
    
    [self clearCartArray];
    
    [self replaceCurrentViewControllerWith:shareSuccVC animated:YES];
}


#pragma mark - Setting Price TextField's text to PriceNum

- (void)settingPriceToModelPriceNum:(NSString *)priceStr
                           andIndex:(NSInteger)index
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:index];
    if([[priceStr trim] isEqualToString:@""]) {
        [docModel setPriceDecNum:@(0)];
        [docModel setTypeNum:@(HXSLibraryDocumentTypeNormal)];//普通文档
        return;
    }
    
    [docModel setPriceDecNum:[[NSDecimalNumber alloc]initWithString:priceStr]];
    [docModel setTypeNum:@(HXSLibraryDocumentTypeBuy)];//收费文档
}


#pragma mark - clear the cart Array

- (void)clearCartArray
{
    for (HXSMyPrintOrderItem *printOrderItem in _cartArray) {
        printOrderItem.isAddToCart = NO;
    }
    
    [_cartArray removeAllObjects];
}


#pragma mark - getter

- (HXStoreDocumentLibraryViewModel *)viewModel
{
    if(nil == _viewModel) {
        _viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _viewModel;
}

- (UIBarButtonItem *)rightBarButton
{
    if(nil == _rightBarButton) {
        UIImage *image = [self.viewModel imageFromNewName:@"ic_help_white"];
        _rightBarButton = [[UIBarButtonItem alloc] initWithImage:image
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(rightBarButtonAction)];
    }
    
    return _rightBarButton;
}

- (HXStoreDocumentLibraryPersistencyManger *)persistencyManager
{
    if(nil == _persistencyManager) {
        _persistencyManager = [[HXStoreDocumentLibraryPersistencyManger alloc]init];
    }
    
    return _persistencyManager;
}

- (HXSCustomAlertView *)leaveAlertView
{
    if(nil == _leaveAlertView) {
        _leaveAlertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                            message:@"确定离开当前页面？"
                                                    leftButtonTitle:@"取消"
                                                  rightButtonTitles:@"确定"];
        WS(weakSelf);
        _leaveAlertView.rightBtnBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
    }
    
    return _leaveAlertView;
}

- (UIBarButtonItem *)backBarButton
{
    if(!_backBarButton) {
        UIImage *backImage = [self.viewModel imageFromNewName:@"btn_back_normal"];
        _backBarButton =[[UIBarButtonItem alloc] initWithImage:backImage
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backBarButtonAction)];
        
    }
    return _backBarButton;
}


@end
