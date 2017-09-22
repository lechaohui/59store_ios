//
//  HXSOpenShopViewController.m
//  store
//
//  Created by caixinye on 2017/8/25.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSOpenShopViewController.h"

// Controllers
#import "HXSSettingsViewController.h"
#import "HXSMessageViewController.h"
#import "HXSMessageCenterViewController.h"
#import "HXDDormTabBarViewController.h"
#import "HXDBalanceOfAccountViewController.h"



// Views
#import "UIBarButtonItem+HXSRedPoint.h"
#import "HXSOpenShopHeaderCenterView.h"
#import "HXSPersonalMenuButton.h"





// Models
#import "HXSUserAccountModel.h"
#import "HXSWXApiManager.h"
#import "HXDBusinessItemViewModel.h"

static NSInteger const kTagNavigationTiemButton = 10001;

@interface HXSOpenShopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tbview;
@property(nonatomic,strong)HXSOpenShopHeaderCenterView *headerView;

@property (nonatomic, strong) NSArray<HXDBusinessItemViewModel *> *businessArray;




@end

@implementation HXSOpenShopViewController


#pragma mark - UIViewController Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
       // self.title = @"开店挣钱";
        //self.navigationItem.title = @"开店挣点";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = nil;
    
    //[self initNavigationBarButtonItems];
    self.view.layer.masksToBounds = NO;
    self.view.clipsToBounds = NO;
    
    [self creatTableView];
    [self creatTableHeaderView];
    
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;

    // update head view
    [self.headerView refreshInfo];
    [self loadSellerInfo];
    
}
- (void)creatTableView{

   
    WS(weakSelf);
    _tbview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tbview.delegate = self;
    _tbview.dataSource = self;
    _tbview.backgroundColor = [UIColor colorWithRGBHex:0xF5F6FB];
    _tbview.separatorColor = [UIColor colorWithRGBHex:0xE1E2E3];
    _tbview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tbview];
    _tbview.tableFooterView = [UIView new];
    
    [self.tbview addRefreshHeaderWithCallback:^{
        
        //刷新
       [weakSelf reload];
        
    }];
    
   
}
- (void)reload
{
    // If didn't login, don't refresh
    if (![HXSUserAccount currentAccount].isLogin) {
        [self.tbview endRefreshing];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInfo)
                                                 name:kUserInfoUpdated
                                               object:nil];
    
    // update user info in basic info class.
    [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
    
}
- (void)updateUserInfo
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUserInfoUpdated
                                                  object:nil];
    
    [self.tbview endRefreshing];
    
    [self.headerView refreshInfo];
    
    
}
#pragma mark - Initial Methods
- (void)initNavigationBarButtonItems{


    // Add right bar button
    UIImage *messageImage = [UIImage imageNamed:@"message"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, messageImage.size.width, messageImage.size.height)];
    [rightBtn setImage:messageImage forState:UIControlStateNormal];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBtn addTarget:self
                 action:@selector(clickMessageBtn:)
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTag:kTagNavigationTiemButton];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    NSNumber *unreadMessageNum = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_UNREAD_MESSGE_NUMBER];
    NSString *unreadMessageStr = nil;
    if ([HXSUserAccount currentAccount].isLogin) {
        unreadMessageStr = [NSString stringWithFormat:@"%@", unreadMessageNum ? unreadMessageNum : @0];
    }
    rightBarButton.redPointBadgeValue     = unreadMessageStr;
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    // Add right bar button
    
    



}
#pragma mark - Target Method
- (void)clickMessageBtn:(UIButton *)button{



}
- (void)onClickPersonInfBtn:(HXSPersonalMenuButton *)button{

    if (![HXSUserAccount currentAccount].isLogin) {
        [[AppDelegate sharedDelegate].rootViewController checkIsLoggedin];
    } else {
        
        [self pushPersonalInfoVC];
    }



}
#pragma  mark - tableheaderview
- (UIView *)creatTableHeaderView{

    // __weak typeof (self) weakSelf = self;
    _headerView = [HXSOpenShopHeaderCenterView headerView];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
    self.tbview.tableHeaderView = _headerView;
    _headerView.backgroundColor = [UIColor colorWithRGBHex:0x68B7FC];
    [self.headerView.personInfoButton addTarget:self
                                    action:@selector(onClickPersonInfBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
    return _headerView;
    
    

}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return 6;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 1;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{

    return 50;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{

    return 10;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *const cid=@"mine_cell_id";
    NSArray *array=@[@[@"约团报名"],
                     @[@"夜猫店"],
                     @[@"店长资产"],
                     @[@"店长排行"],
                     @[@"店长考核"],
                     @[@"开店攻略"]];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cid];
    if(!cell)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    cell.textLabel.text=array[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.imageView.image=[UIImage imageNamed:array[indexPath.section][indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;




}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{

    switch (indexPath.section) {
        case 0:{
            //约团报名
            break;
            
        }
        case 1:{
            //夜猫店
            HXDDormTabBarViewController *dormVC = [[HXDDormTabBarViewController alloc] init];
            
            for (HXDBusinessItemViewModel *viewModel in self.businessArray) {
                
                dormVC.businessModel = viewModel;
//                if (HXAvailableBusinessTypeDorm == viewModel.businessType) {
//                    dormVC.businessModel = viewModel;
//                }
            }
            
            [self.navigationController pushViewController:dormVC animated:YES];
            break;
        }
        case 2:{
            
            //店长资产
            HXDBalanceOfAccountViewController *balance = [[HXDBalanceOfAccountViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:balance animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
            break;
        }
        case 3:{
            //店长排行
            break;
        }
        case 4:{
            //店长考核
            break;
        }
        case 5:{
            //开店攻略
            break;
        }
            
        default:
            break;
    }
    
    
    



}
#pragma request
- (void)loadSellerInfo{

    //[HXSLoadingView showLoadingInView:self.view];
   // WS(ws);
    

    




}
#pragma mark - Push Methods

- (void)pushPersonalInfoVC{


    


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
