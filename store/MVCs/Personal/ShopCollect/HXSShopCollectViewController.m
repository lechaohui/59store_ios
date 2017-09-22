//
//  HXSShopCollectViewController.m
//  store
//
//  Created by caixinye on 2017/9/14.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSShopCollectViewController.h"


#import "HXSShopViewModel.h"

#import "HXSCollectTableViewCell.h"
#import "HXSLoginViewController.h"

#import "HXSUserAccountModel.h"




@interface HXSShopCollectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;

@property (nonatomic, strong) HXSShopViewModel        *shopModel;


@end


@implementation HXSShopCollectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"收藏的店铺";
    self.navigationItem.title = @"收藏的店铺";
    [self initialNav];
    [self.view addSubview:self.tableView];
    
    WS(weakSelf);
    [self.tableView addRefreshHeaderWithCallback:^{
       
        [weakSelf loadData];
        
    }];
    
    
    
    [HXSLoadingView showLoadingInView:self.view];
    
    
    //判断有没有登陆
    if([HXSUserAccount currentAccount].isLogin){
    
        //加载数据
        [self loadData];

    }else{
    
       //跳转到登陆页面
        WS(weakSelf);
        [HXSLoginViewController showLoginController:self loginCompletion:^{
        [weakSelf loadData];
    }];
    
    
    }

}

#pragma mark - Initial methodx

- (void)initialNav
{
    
    self.navigationItem.leftBarButtonItem = nil;
    
    
}

- (UITableView *)tableView{

    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        

    }
    return _tableView;



}
- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self changeNavigationBarBackgroundColor:[UIColor colorWithHexString:@"fde25c"]
                        pushBackButItemImage:[UIImage imageNamed:@"btn_back_normal"]
                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
                                  titleColor:[UIColor whiteColor]];
    
    

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self changeNavigationBarNormal];
}
#pragma mark - fetchData
- (void)loadData{

  __weak typeof(self) weakSelf = self;
    [self.shopModel fetchShopListWithSiteId:nil
                                  dormentry:nil
                                       type:nil
                              crossBuilding:nil complete:^(HXSErrorCode status, NSString *message, NSArray *shopsArr) {
                                  
                                  [weakSelf.tableView endRefreshing];
                                  [HXSLoadingView closeInView:weakSelf.view];
                                  if (kHXSNoError != status) {
                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                         status:message
                                                                     afterDelay:1.5f];
                                      
                                      return ;
                                  }
                                  weakSelf.dataSource  = shopsArr;
                                  [weakSelf.tableView reloadData];
                                  
                                  
                                  
                              }];


}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


     //return self.dataSource.count;
    return 1;
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 80;



}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

      static NSString *cid=@"cellId";
      
    HXSCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell)
        
        cell = [[HXSCollectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        //cell = [[[NSBundle mainBundle] loadNibNamed:@"HXSShopCollectTableViewCell" owner:nil options:nil] lastObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    HXSShopEntity *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setupCellWithEntity:model];
    cell.enterBtnDidClickdBlock = ^(UIButton *sender){
    
        
    [self.shopModel loadDromViewControllerWithShopEntity:model from:self];


    };
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //进入店铺详情页
    HXSShopEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    [self.shopModel loadDromViewControllerWithShopEntity:entity from:self];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
