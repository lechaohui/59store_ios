//
//  HXStoreDocumentLibraryFirstShareViewController.m
//  Pods
//
//  Created by J006 on 16/10/7.
//
//

#import "HXStoreDocumentLibraryFirstShareViewController.h"

//other
#import "HXStoreDocumentLibraryImport.h"

@interface HXStoreDocumentLibraryFirstShareViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation HXStoreDocumentLibraryFirstShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithR:0 G:0 B:0 A:0.7]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - create

+ (instancetype)createDocumentLibraryFirstShareVC
{
    HXStoreDocumentLibraryFirstShareViewController *vc = [HXStoreDocumentLibraryFirstShareViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    return vc;
}


#pragma mark - Button Action

- (IBAction)closeButtonAction:(id)sender
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

@end
