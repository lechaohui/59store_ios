//
//  HXSPrintMainViewController.m
//  store
//
//  Created by J006 on 16/5/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSPrintMainViewController.h"
#import "HXSShopInfoViewController.h"
#import "TZImagePickerController.h"
#import "HXSMyFilesPrintViewController.h"
#import "HXSMyPhotosPrintCartViewController.h"
#import "HXSLoginViewController.h"
#import "HXStoreDocumentLibraryShopperViewController.h"
#import "HXSPrintShopActionViewController.h"

// Model
#import "HXSMainPrintTypeEntity.h"
#import "HXSPrintModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HXSMyPrintOrderItem.h"
#import "HXSPrintFilesManager.h"

// Views
#import "HXSNoticeView.h"
#import "HXSLocationCustomButton.h"
#import "HXSLoadingView.h"
#import "HXSActionSheet.h"
#import "HXSMyPhotosPrintCartViewController.h"
#import "HXSPrintMainCollectionViewCell.h"
#import "HXSPrintMainCollectionSectionViewCollectionReusableView.h"
#import "HXSPrintMainSingleLabelReusableView.h"

//others
#import "HXSPrintHeaderImport.h"

typedef NS_ENUM(NSInteger,HXSPrintMainViewCollectionViewType){
    kHXSPrintMainViewCollectionViewTypePrintSection      = 0,// 打印
    kHXSPrintMainViewCollectionViewTypeScanSection       = 1 // 扫描,复印
};

static NSInteger const kMaxUploadNums = 20; // 最大上传图片数量

@interface HXSPrintMainViewController ()<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
TZImagePickerControllerDelegate>
/**店铺公告*/
@property (weak ,nonatomic) IBOutlet HXSNoticeView                              *noticeView;
@property (weak ,nonatomic) IBOutlet UICollectionView                           *mainCollectionView;
/**导航栏主标题即店铺名称*/
@property (nonatomic ,strong) HXSLocationCustomButton                           *locationButton;
/**弹出的店铺信息*/
@property (nonatomic ,strong) HXSShopInfoViewController                         *shopInfoVC;
/**是否已经淡出店铺信息*/
@property (nonatomic ,assign) BOOL                                              hasDisplayShopInfoView;
/**当前店铺entity*/
@property (nonatomic ,strong) HXSShopEntity                                     *shopEntity;
/**底部弹出选择照片框*/
@property (nonatomic ,strong) HXSActionSheet                                    *actionSheet;
@property (nonatomic ,strong) TZImagePickerController                           *pickerController;
/**打印类型数组*/
@property (nonatomic ,strong) NSArray<HXSMainPrintTypeEntity *>                 *printTypeArray;
@property (nonatomic ,strong) NSNumber                                          *shopIDIntNum;
@property (nonatomic ,strong) HXSPrintFilesManager                              *printFilesManager;

@property (nonatomic, strong) HXSMyPhotosPrintCartViewController                *printCartVC;
/**欢迎到店体验哦~*/
@property (nonatomic, strong) UILabel                                           *inforLabel;
/**打印店铺信息,包括价格~*/
@property (nonatomic, strong) HXSPrintDormShopEntity                            *printDormShopEntity;
/**是否有店长私货~*/
@property (nonatomic, assign) BOOL                                              hasShopShareDoc;
@property (nonatomic, strong) HXSPrintShopFreePicModel                          *freePicModel;

@end

@implementation HXSPrintMainViewController

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initTheShopInfor];
    
    [self initTheCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshViewWhenGotCurrentShopEntity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark init

+ (instancetype)createPrintVCWithShopId:(NSNumber *)shopIdIntNum
{
    HXSPrintMainViewController *printVC = [HXSPrintMainViewController controllerFromXibWithModuleName:@"HXStorePrint"];
    
    printVC.shopIDIntNum = shopIdIntNum;
    
    return printVC;
}

- (void)initialNavigationBar
{
    self.navigationItem.titleView = self.locationButton;
    
    [_locationButton setTitle:_shopEntity.shopNameStr forState:UIControlStateNormal];
    
    [self.navigationItem.titleView layoutSubviews];
}

- (void)initTheShopInfor
{
    [self fetchShopInfoNetworking];
}

/**
 *  初始化店铺公告信息
 */
- (void)initTheNoticeView
{
    __weak typeof(self) weakSelf = self;
    if(_shopEntity)
    {
        [_noticeView createWithShopEntity:_shopEntity targetMethod:^{
            [weakSelf onClickTitleView:nil];
        }];
    }
    
    [_noticeView setBackgroundColor: [UIColor colorWithRed:0.965 green:0.992 blue:1.000 alpha:1.000]];
    [_noticeView.noticeLabel setTextColor:[UIColor colorWithRed:0.125 green:0.671 blue:0.969 alpha:1.000]];
}

/**
 *  店铺名称点击或者店铺信息点击的事件
 *
 *  @param button
 */
- (void)onClickTitleView:(UIButton *)button
{
    if (self.hasDisplayShopInfoView) {
        [_shopInfoVC dismissView];
    } else {
        __weak typeof(self) weakSelf = self;
        self.shopInfoVC.shopEntity = _shopEntity;
        _shopInfoVC.dismissShopInfoView = ^(void) {
            [weakSelf.shopInfoVC.view removeFromSuperview];
            [weakSelf.shopInfoVC removeFromParentViewController];
            [weakSelf.locationButton setImage:[HXSPrintModel imageFromNewName:@"ic_downwardwhite"] forState:UIControlStateNormal];
            weakSelf.hasDisplayShopInfoView = NO;
        };
        [self addChildViewController:_shopInfoVC];
        [self.view addSubview:_shopInfoVC.view];
        [_shopInfoVC.view mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.edges.equalTo(self.view);
         }];
        
        [_shopInfoVC didMoveToParentViewController:self];
        _hasDisplayShopInfoView = YES;
        [_locationButton setImage:[HXSPrintModel imageFromNewName:@"ic_upwardwhite"] forState:UIControlStateNormal];
    }
}

/**
 *  初始化可支持的打印功能
 */
- (void)initThePrintTypeArray
{
    _printTypeArray = [HXSPrintModel createTheMainPrintTypeArray];
    [_mainCollectionView reloadData];
}

- (void)initTheCollectionView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStorePrint" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintMainCollectionViewCell class]) bundle:bundle]
          forCellWithReuseIdentifier:NSStringFromClass([HXSPrintMainCollectionViewCell class])];
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintMainCollectionSectionViewCollectionReusableView class]) bundle:bundle] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HXSPrintMainCollectionSectionViewCollectionReusableView class])];
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintMainSingleLabelReusableView class]) bundle:bundle] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HXSPrintMainSingleLabelReusableView class])];
    
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger counts = 2;//每section 2个
    
    return counts;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger section = 0;
    
    if(_shopEntity) {
        section = 2;
    }
    
    return section;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    HXSPrintMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXSPrintMainCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell initPrintMainCollectionViewCellWithEntity:[_printTypeArray objectAtIndex:indexPath.row + indexPath.section * 2]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if(indexPath.section == kHXSPrintMainViewCollectionViewTypePrintSection) {
            HXSPrintMainCollectionSectionViewCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([HXSPrintMainCollectionSectionViewCollectionReusableView class]) forIndexPath:indexPath];
            
            [reusableView initPrintMainCollectionSectionViewCollectionReusableViewWithEntity:_printDormShopEntity
                                                                      andHasShowShopShareDoc:_hasShopShareDoc];
            
            [reusableView.jumpToShareButton addTarget:self
                                               action:@selector(jumpToShopShareVC:)
                                     forControlEvents:UIControlEventTouchUpInside];
            
            [reusableView.jumpToShopActionButton addTarget:self
                                                    action:@selector(jumpToShopActionVC:)
                                          forControlEvents:UIControlEventTouchUpInside];
            
            return reusableView;
        } else if(indexPath.section == kHXSPrintMainViewCollectionViewTypeScanSection) {
            HXSPrintMainSingleLabelReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([HXSPrintMainSingleLabelReusableView class]) forIndexPath:indexPath];
            
            return reusableView;
        }
    }
    
    return nil;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kHXSPrintMainViewCollectionViewTypePrintSection:
        {
            [self checkShopIsOpenAndJumpWithPrintType:indexPath.row];
        }
            
            break;
            
        default:
        {
            NSString *message = @"欢迎到店体验哦~";
            [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2];
        }
            break;
    }
}


#pragma mark UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsZero;
    
    if(section == kHXSPrintMainViewCollectionViewTypeScanSection)
    {
        edge = UIEdgeInsetsMake(0, 0, 20, 0);
    }
    
    return edge;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(SCREEN_WIDTH/2,((SCREEN_WIDTH/2)-15-10));
    
    return size;
}

/**
 *Cell最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat space = 0;
    
    return space;
}

/**
 *Cell最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat space = 0;
    
    return space;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeZero;
    if(section == kHXSPrintMainViewCollectionViewTypePrintSection)
    {
        if(_hasShopShareDoc) {
            size = CGSizeMake(SCREEN_WIDTH, TOTAL_HEIGHT);
        } else {
            size = CGSizeMake(SCREEN_WIDTH, NOSHOPPER_HEIGHT);
        }
        
    }
    else if(section == kHXSPrintMainViewCollectionViewTypeScanSection)
    {
        size = CGSizeMake(SCREEN_WIDTH, SINGLE_LABEL_HEIGHT);
    }
    return size;
}


#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        HXSMyPrintOrderItem *printOrderItem = [[HXSMyPrintOrderItem alloc]init];
        
        printOrderItem.fileNameStr = [self.printFilesManager createCameraImageNameByDate];
        
        printOrderItem.picImage = editedImage;
        
        NSMutableArray<HXSMyPrintOrderItem *> *array = [[NSMutableArray<HXSMyPrintOrderItem *> alloc] init];
        
        [array addObject:printOrderItem];
        
        HXSMyPhotosPrintCartViewController *printCartVC = [HXSMyPhotosPrintCartViewController createMyPhotosPrintCartViewControllerWithPrintOrderItemArray:array andShopEntity:_shopEntity];
        [weakSelf.navigationController pushViewController:printCartVC animated:YES];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
                        infos:(NSArray<NSDictionary *> *)infos
{
    if(!photos || [photos count] == 0) {
        return;
    }
    
    NSMutableArray<HXSMyPrintOrderItem *> *array = [[NSMutableArray<HXSMyPrintOrderItem *> alloc] init];
    
    for (UIImage *image in photos) {
        HXSMyPrintOrderItem *printOrderItem = [[HXSMyPrintOrderItem alloc]init];
        printOrderItem.picImage = image;
        
        printOrderItem.fileNameStr = [self.printFilesManager createCameraImageNameByDate];
        
        [array addObject:printOrderItem];
    }
    
    HXSMyPhotosPrintCartViewController *printCartVC = [HXSMyPhotosPrintCartViewController createMyPhotosPrintCartViewControllerWithPrintOrderItemArray:array andShopEntity:_shopEntity];
    
    [self.navigationController pushViewController:printCartVC animated:YES];
}


#pragma mark networking

/**
 *  初始化获取店铺信息网络接口
 */
- (void)fetchShopInfoNetworking
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    HXSLocationManager *manager = [HXSLocationManager manager];
    [HXSPrintModel fetchShopInfoWithSiteId:manager.currentSite.site_id
                                  shopType:[NSNumber numberWithInteger:kHXSShopTypePrint]
                               dormentryId:manager.buildingEntry.dormentryIDNum
                                    shopId:_shopIDIntNum
                                  complete:^(HXSErrorCode status, NSString *message, HXSShopEntity *shopEntity)
     {
         
         
         if (kHXSNoError != status) {
             [HXSLoadingView showLoadFailInView:weakSelf.view
                                          block:^{
                                              [weakSelf fetchShopInfoNetworking];
                                          }];
             
             return ;
         }
         
         weakSelf.shopEntity = shopEntity;
         
         [HXSShopManager shareManager].currentEntry.shopEntity = shopEntity;
         
         [weakSelf fetchPrintDormShopInfoNetworking];
     }];
}

/**
 *  获取店铺信息
 */
- (void)fetchPrintDormShopInfoNetworking
{
    __weak typeof(self) weakSelf = self;
    [HXSPrintModel fetchPrintDormShopDetailWithShopId:_shopEntity.shopIDIntNum
                                             complete:^(HXSErrorCode status, NSString *message, HXSPrintDormShopEntity *printDormShopEntity) {
                                                 [HXSLoadingView closeInView:weakSelf.view];
                                                 
                                                 if (kHXSNoError != status) {
                                                     [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                                  block:^{
                                                                                      [weakSelf fetchPrintDormShopInfoNetworking];
                                                                                  }];
                                                     
                                                     return ;
                                                 }
                                                 
                                                 
                                                 weakSelf.printDormShopEntity = printDormShopEntity;
                                                 
                                                 [weakSelf initialNavigationBar];
                                                 
                                                 [weakSelf initTheNoticeView];
                                                 
                                                 [weakSelf initThePrintTypeArray];
                                                 
                                                 [weakSelf fetchPrintDormShareDocsNetworking];
                                                 
                                             }];
}

- (void)reFetchPrintDormShopInfoNetworking
{
    __weak typeof(self) weakSelf = self;
    [HXSLoadingView showLoadingInView:self.view];
    [HXSPrintModel fetchPrintDormShopDetailWithShopId:_shopEntity.shopIDIntNum
                                             complete:^(HXSErrorCode status, NSString *message, HXSPrintDormShopEntity *printDormShopEntity) {
                                                 [HXSLoadingView closeInView:weakSelf.view];
                                                 
                                                 if (kHXSNoError != status) {
                                                     [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                                  block:^{
                                                                                      [weakSelf reFetchPrintDormShopInfoNetworking];
                                                                                  }];
                                                     
                                                     return ;
                                                 }
                                                 
                                                 
                                                 weakSelf.printDormShopEntity = printDormShopEntity;
                                                 
                                                 [weakSelf.noticeView.noticeLabel setText:weakSelf.shopEntity.noticeStr];
                                                 
                                                 [weakSelf.mainCollectionView reloadData];
                                                 
                                                 [weakSelf fetchPrintDormShareDocsNetworking];
                                             }];
}

/**
 *获取店长私货网络接口
 */
- (void)fetchPrintDormShareDocsNetworking
{
    WS(weakSelf);
    [MBProgressHUD showInView:self.view];
    [HXSPrintModel fetchPrintDormShopShareDocWithShopId:_shopEntity.shopIDIntNum
                                      andParamListModel:[HXSPrintListParamModel createDeafultParamModel]
                                               complete:^(HXSErrorCode status, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *array)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         if(kHXSNoError == status
            && nil != array
            && array.count > 0) {
             weakSelf.hasShopShareDoc = YES;
         } else if(kHXSNoError != status){
             weakSelf.hasShopShareDoc = NO;
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:message
                                            afterDelay:1.5];
         } else {
             weakSelf.hasShopShareDoc = NO;
         }
         [weakSelf.mainCollectionView reloadData];
         [weakSelf fetchPrintShopActionNetworking];
     }];
}

/**
 *获取店长店铺活动网络接口
 */
- (void)fetchPrintShopActionNetworking
{
    WS(weakSelf);
    [MBProgressHUD showInView:self.view];
    [HXSPrintModel fetchShopFreePicWithShopId:_shopIDIntNum
                                     Complete:^(HXSErrorCode status, NSString *message, HXSPrintShopFreePicModel *model)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         if(kHXSNoError == status
            && model) {
             weakSelf.freePicModel = model;
         }
         
         [weakSelf.mainCollectionView reloadData];
     }];
}


#pragma mark TakePhoto or Camera

- (void)cameraAction
{
    [self jumpToTakePhotoViewOrAlbumView:YES];
}

- (void)takePhotoFromAlbumAction
{
    [self jumpToTakePhotoViewOrAlbumView:NO];
}

/**
 *  跳转到相机或者相册界面
 *
 *  @param isCamera
 */
- (void)jumpToTakePhotoViewOrAlbumView:(BOOL)isCamera
{
    if(isCamera) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;//设置不可编辑
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        _pickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaxUploadNums
                                                                           delegate:self];
        _pickerController.allowPickingVideo = NO;
        _pickerController.allowPickingOriginalPhoto = NO;
        
        [self presentViewController:_pickerController animated:YES completion:nil];
    }
}


#pragma mark - check shop is open

/**
 *  检测店铺是否休息中
 *
 *  @return
 */
- (void)checkShopIsOpenAndJumpWithPrintType:(HXSMainPrintType)type
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    HXSLocationManager *manager = [HXSLocationManager manager];
    [HXSPrintModel fetchShopInfoWithSiteId:manager.currentSite.site_id
                                  shopType:[NSNumber numberWithInteger:kHXSShopTypePrint]
                               dormentryId:manager.buildingEntry.dormentryIDNum
                                    shopId:weakSelf.shopEntity.shopIDIntNum
                                  complete:^(HXSErrorCode status, NSString *message, HXSShopEntity *shopEntity)
     {
         [HXSLoadingView closeInView:weakSelf.view];
         weakSelf.shopEntity = shopEntity;
         if(shopEntity
            && !([shopEntity.statusIntNum integerValue] == kHXSShopStatusClosed))
         {
             switch (type) {
                 case kHXSMainPrintTypeDocument:
                 {
                     
                     HXSMyFilesPrintViewController *filesPrintVC = [HXSMyFilesPrintViewController
                                                                    createFilesPrintVCWithEntity:_shopEntity];
                     
                     [weakSelf.navigationController pushViewController:filesPrintVC animated:YES];
                     
                     break;
                 }
                 case kHXSMainPrintTypePhoto:
                 {
                     
                     [weakSelf.actionSheet show];
                     
                     break;
                 }
                     
                 default:
                     
                     break;
             }
         }
         else
         {
             switch (type)
             {
                 case kHXSMainPrintTypeDocument:
                 case kHXSMainPrintTypePhoto:
                 {
                     
                     [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                        status:@"店铺休息中，请稍后光顾~"
                                                    afterDelay:1.5];
                     
                     break;
                 }
                     
                 default:
                     
                     break;
             }
         }
         
     }];
}


#pragma mark - refresh view

- (void)refreshViewWhenGotCurrentShopEntity
{
    HXSShopEntity *tempShopEntity = [[HXSShopManager shareManager].currentEntry shopEntity];
    
    if(!tempShopEntity
       || [[tempShopEntity shopIDIntNum] isEqualToNumber:_shopIDIntNum]) {
        return;
    }
    
    _shopIDIntNum = [tempShopEntity shopIDIntNum];
    
    _shopEntity = tempShopEntity;
    
    _noticeView.shopEntity = tempShopEntity;
    
    _shopInfoVC = nil;
    
    [self initialNavigationBar];
    
    [self reFetchPrintDormShopInfoNetworking];
    
}


#pragma mark - Jump Action

- (void)jumpToShopShareVC:(UIButton *)button
{
    if(!_hasShopShareDoc) {
        return;
    }
    
    HXStoreDocumentLibraryShopperViewController *shopShareVC = [HXStoreDocumentLibraryShopperViewController createDocumentLibraryShopperVCWithShopID:_shopIDIntNum.stringValue];
    
    [self.navigationController pushViewController:shopShareVC animated:YES];
}

- (void)jumpToShopActionVC:(UIButton *)button
{
    if([_shopEntity.statusIntNum integerValue] == kHXSShopStatusClosed) {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"店铺休息中，请稍后再来~"
                                       afterDelay:1.5];
        return;
    }
    
    if(![_freePicModel.hasOpenedNum boolValue]) {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"店铺还在参与活动的路上，请稍等~"
                                       afterDelay:1.5];
        return;
    }
    HXSPrintShopActionViewController *shopActionVC = [HXSPrintShopActionViewController createShopActionVCWithModel:_freePicModel];
    [self.navigationController pushViewController:shopActionVC animated:YES];
}


#pragma mark getter setter

- (HXSLocationCustomButton *)locationButton
{
    if(!_locationButton) {
        _locationButton = [HXSLocationCustomButton buttonWithType:UIButtonTypeCustom];
        [_locationButton addTarget:self action:@selector(onClickTitleView:) forControlEvents:UIControlEventTouchUpInside];
        [_locationButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateHighlighted];
        [_locationButton setImage:[HXSPrintModel imageFromNewName:@"ic_downwardwhite"] forState:UIControlStateNormal];
        [_locationButton setTitle:_shopEntity.shopNameStr forState:UIControlStateNormal];
    }
    return _locationButton;
}

- (HXSShopInfoViewController *)shopInfoVC
{
    if (!_shopInfoVC) {
        _shopInfoVC = [HXSShopInfoViewController controllerFromXibWithModuleName:@"HXStoreBase"];
    }
    
    return _shopInfoVC;
}

- (HXSActionSheet *)actionSheet
{
    if(!_actionSheet){
        HXSActionSheetEntity *cameraEntity = [[HXSActionSheetEntity alloc] init];
        cameraEntity.nameStr = @"拍照";
        HXSActionSheetEntity *photoEntity = [[HXSActionSheetEntity alloc] init];
        photoEntity.nameStr = @"打开本地相册";
        __weak typeof(self) weakSelf = self;
        HXSAction *cameraAction = [HXSAction actionWithMethods:cameraEntity
                                                       handler:^(HXSAction *action){
                                                           [weakSelf cameraAction];
                                                           
                                                       }];
        HXSAction *photoAction = [HXSAction actionWithMethods:photoEntity
                                                      handler:^(HXSAction *action){
                                                          [weakSelf takePhotoFromAlbumAction];
                                                      }];
        
        _actionSheet = [HXSActionSheet actionSheetWithMessage:@""
                                            cancelButtonTitle:@"取消"];
        [_actionSheet addAction:photoAction];
        [_actionSheet addAction:cameraAction];
    }
    return _actionSheet;
}

- (HXSPrintFilesManager *)printFilesManager
{
    if(!_printFilesManager) {
        _printFilesManager = [[HXSPrintFilesManager alloc]init];
    }
    return _printFilesManager;
}

@end
