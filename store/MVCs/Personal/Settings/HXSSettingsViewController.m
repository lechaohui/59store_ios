//
//  HXSSettingsViewController.m
//  store
//
//  Created by chsasaw on 14-10-16.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSPersonal.h"

// Controllers
#import "HXSSettingsViewController.h"
#import "HXSDormAboutUsViewController.h"
#import "HXSServiceSelectViewController.h"
#import "HXSDormAboutUsViewController.h"

// Model
#import "HXSSettingsModel.h"

// Other
#import <MessageUI/MessageUI.h>
#import "HXSFinanceOperationManager.h"

typedef NS_ENUM(NSInteger, HXSSSettingOption) {
    HXSSSettingOptionNotification = 0,
    HXSSSettingOptionAboutUs,
    HXSSSettingOptionVersionUpdate,
    HXSSSettingOptionClearCache,
    
    HXSSSettingOptionVersionLogOut,
    
    HXSSSettingOptionCount
};

@interface HXSSettingsViewController ()<UITableViewDataSource,
                                         UITableViewDelegate,
                                         MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;

@property (nonatomic, strong) HXSSettingsModel *settingsModel;
@property (nonatomic, assign) BOOL notificationHasBeenDenied;

@end

@implementation HXSSettingsViewController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置";
    self.title = @"设置";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginComplete:) name:kLoginCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginComplete:) name:kLogoutCompleted object:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    self.tableView.rowHeight = 55;
    
    [self fetchDevicePushStatus];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self changeNavigationBarBackgroundColor:[UIColor colorWithHexString:@"fde25c"]
                        pushBackButItemImage:[UIImage imageNamed:@"btn_back_normal"]
                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
                                  titleColor:[UIColor whiteColor]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - override

- (void)loginComplete:(NSNotification *)noti
{
    [self.tableView reloadData];
    
    if(![HXSUserAccount currentAccount].isLogin) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [[HXSFinanceOperationManager sharedManager] clearBorrowInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - private method

- (void)notificationSwitchValueChanged:(UISwitch *)sw
{
    [HXSUsageManager trackEvent:kUsageEventSettingNotification parameter:nil];
    
    self.notificationHasBeenDenied = !sw.isOn;
    
    [self updateDevicePushStatus:[NSNumber numberWithBool:sw.isOn]];
}


#pragma mark - Configure

- (HXSSSettingOption)optionForIndexPath:(NSIndexPath *)indexPath
{
    return (HXSSSettingOption)indexPath.section;
}

- (NSString *)titleForOption:(HXSSSettingOption)option
{
    switch (option) {
        case HXSSSettingOptionNotification:     return @"推送通知";
        case HXSSSettingOptionAboutUs:       return @"关于我们";
        case HXSSSettingOptionVersionUpdate:    return @"版本号";
        case HXSSSettingOptionClearCache:       return @"清除缓存";
        case HXSSSettingOptionVersionLogOut:    return @"退出登录";
            break;
        default:
            break;
    }
    
    return @"";
}

- (void) configureCell:(UITableViewCell *)cell option:(HXSSSettingOption) option
{
    cell.textLabel.textColor = [UIColor colorWithRGBHex:0x555555];
    cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xb5b5ba];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = [self titleForOption:option];
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (option) {
        case HXSSSettingOptionNotification:
        {
            UISwitch *sw = [[UISwitch alloc] init];
            [sw setOn:!self.notificationHasBeenDenied animated:NO];
            sw.onImage = [UIImage imageNamed:@"btn_open"];
            sw.offImage = [UIImage imageNamed:@"btn_close"];
            [sw addTarget:self action:@selector(notificationSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = sw;
        }
            break;
        case HXSSSettingOptionAboutUs:
        {
           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
            
        case HXSSSettingOptionClearCache:
        {
            CGFloat size = [[SDImageCache sharedImageCache] getSize]/1024.0;
            NSString *text ;
            if(size > 1024) {
                text = [NSString stringWithFormat:@"%.1fMB", size/1024.0];
            } else {
                text = [NSString stringWithFormat:@"%.1fKB", size];
            }
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
            cell.detailTextLabel.text = text;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case HXSSSettingOptionVersionUpdate:
            cell.detailTextLabel.text = [[HXAppConfig sharedInstance] appVersion];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
            break;
        case HXSSSettingOptionVersionLogOut:
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        default:
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([HXSUserAccount currentAccount].isLogin) {
        return HXSSSettingOptionCount;
    }
    return HXSSSettingOptionCount  - 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
    if (section==0||section==3) {
        return 10;
    }
    
    return 0.01;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingCell";
    
    HXSSSettingOption option = [self optionForIndexPath:indexPath];
    UITableViewCell *cell;
    
    if (option > HXSSSettingOptionVersionUpdate) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        };
    }
    [self configureCell:cell option:option];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSSSettingOption option = [self optionForIndexPath:indexPath];
    
    switch (option) {
        case HXSSSettingOptionNotification:
            break;
        case HXSSSettingOptionClearCache:
        {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:@"清除缓存?"
                                                                      leftButtonTitle:@"取消"
                                                                    rightButtonTitles:@"确定"];
            
            [alertView setRightBtnBlock:^(){
                [MBProgressHUD showInView:self.view status:@"清除缓存..."];
                
                // 清理内存
                [[SDImageCache sharedImageCache] clearMemory];
                
                // 清理webview 缓存
                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (NSHTTPCookie *cookie in [storage cookies]) {
                    [storage deleteCookie:cookie];
                }
                
                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                [config.URLCache removeAllCachedResponses];
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                
                // 清理硬盘
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [self.tableView reloadData];
                }];
 
            }];
            [alertView show];
        }
            break;
        case HXSSSettingOptionVersionUpdate:
            break;
        case HXSSSettingOptionAboutUs:{
            
            HXSDormAboutUsViewController *about = [[HXSDormAboutUsViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
            
        case HXSSSettingOptionVersionLogOut:
            [HXSUsageManager trackEvent:kUsageEventSettingLogout parameter:nil];
            [self LogoutServicesAction];
            break;
        default:
            break;
    }
}


- (void)LogoutServicesAction
{
    __weak HXSSettingsViewController *weakSelf = self;
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                       message:@"您确定退出当前账号吗？"
                                                               leftButtonTitle:@"取消"
                                                             rightButtonTitles:@"确定"];
    alertView.rightBtnBlock = ^{
        [weakSelf logout];
        
    };
    [alertView show];
}

- (void)logout
{
    DLog(@"settings: %@", @"logout");
    
    [[HXSUserAccount currentAccount] logout];
}


#pragma mark - Fetch & Update push status

- (void)fetchDevicePushStatus
{
    NSString *deviceIDStr = [HXAppDeviceHelper uniqueDeviceIdentifier];
    __weak typeof(self) weakSelf = self;
    [self.settingsModel fetchReceivePushStatus:deviceIDStr
                                      complete:^(HXSErrorCode code, NSString *message, NSDictionary *pushStatusDic) {
                                          if (kHXSNoError != code) {
                                              [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                 status:message
                                                                             afterDelay:1.5f];
                                              
                                              return ;
                                          }
                                          
                                          if (DIC_HAS_NUMBER(pushStatusDic, @"receive_status")) {
                                              NSNumber *status = [pushStatusDic objectForKey:@"receive_status"];
                                              
                                              // 0 不接收推送  1 接收推送
                                              weakSelf.notificationHasBeenDenied = ![status boolValue];
                                          }
                                          
                                          [weakSelf.tableView reloadData];
                                      }];
}

- (void)updateDevicePushStatus:(NSNumber *)status
{
    NSString *deviceIDStr = [HXAppDeviceHelper uniqueDeviceIdentifier];
    
    __weak typeof(self) weakSelf = self;
    [self.settingsModel updateReceivePushStatusWithDeviceID:deviceIDStr
                                                     status:status
                                                   complete:^(HXSErrorCode code, NSString *message, NSDictionary *pushStatusDic) {
                                                       if (kHXSNoError != code) {
                                                           [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                              status:message
                                                                                          afterDelay:1.5f];
                                                           
                                                           return ;
                                                       }
                                                       
                                                       
                                                   }];
}


#pragma mark - Setter Getter Methods

- (HXSSettingsModel *)settingsModel
{
    if (nil == _settingsModel) {
        _settingsModel = [[HXSSettingsModel alloc] init];
    }
    
    return _settingsModel;
}

@end
