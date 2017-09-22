//
//  HXStoreDocumentLibraryShareSuccessViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryShareSuccessViewController.h"

//vc
#import "HXSWebViewController.h"
#import "HXStoreMyDocumentLibraryViewController.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"

@interface HXStoreDocumentLibraryShareSuccessViewController ()

@property (nonatomic, strong) UIBarButtonItem                   *rightBarButton;
@property (weak, nonatomic) IBOutlet UIButton                   *checkButton;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel   *viewModel;

@end

@implementation HXStoreDocumentLibraryShareSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialCheckButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)createDocumentLibraryShareSuccessVC
{
    HXStoreDocumentLibraryShareSuccessViewController *vc = [HXStoreDocumentLibraryShareSuccessViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    return vc;
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"文档分享";
    
    [self.navigationItem setRightBarButtonItem:self.rightBarButton];
}

- (void)initialCheckButton
{
    [_checkButton.layer setCornerRadius:3];
    [_checkButton.layer setMasksToBounds:YES];
}


#pragma mark - Button Action

- (void)rightBarButtonAction
{
    [self jumpToDocumentShareHelpWebVCAction];
}

- (IBAction)checkButtonAction:(id)sender
{
    [self jumpToMyDocumentShareVCAction];
}

#pragma mark - jumpAction

- (void)jumpToDocumentShareHelpWebVCAction
{
    NSString *url = [[ApplicationSettings instance] currentDocLibURL];
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)jumpToMyDocumentShareVCAction
{
    HXStoreMyDocumentLibraryViewController *vc = [HXStoreMyDocumentLibraryViewController createMyDocumentLibraryVC];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - getter

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

- (HXStoreDocumentLibraryViewModel *)viewModel
{
    if(nil == _viewModel) {
        _viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _viewModel;
}


@end
