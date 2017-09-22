//
//  HXDMyDormShopViewController.m
//  store
//
//  Created by caixinye on 2017/9/8.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXDMyDormShopViewController.h"
#import "HXDPersonHeaderView.h"
#import "HXDPersonButView.h"

#import "HXDMyshopTableViewCell.h"

@interface HXDMyDormShopViewController ()<UITableViewDelegate,UITableViewDataSource,HXDPersonHeaderViewDelegate,HXDPersonButViewDelegate,HXDMyshopTableViewCellDelegate>

@property(nonatomic,strong)UITableView *tableView;


@property(nonatomic,strong)HXDPersonHeaderView *headerOne;
@property(nonatomic,strong)HXDPersonButView *headerTwo;



@end

@implementation HXDMyDormShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    [self.view addSubview:self.tableView];
    [self initialTableViewHeaderView];
    
    
    
    
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;



}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //判断有没有登陆
    



}
- (void)initialTableViewHeaderView{

   __weak typeof (self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        
        //[weakSelf reload];
    }];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200+50)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    _headerOne = [[HXDPersonHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _headerOne.delegate = self;
    [headerView addSubview:_headerOne];
    
    _headerTwo = [[HXDPersonButView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_headerOne.frame)-25, SCREEN_WIDTH-30, 50)];
    _headerTwo.backgroundColor = [UIColor whiteColor];
    _headerTwo.layer.cornerRadius = 5;
    _headerTwo.delegate = self;
    [headerView addSubview:_headerTwo];
    
    self.tableView.tableHeaderView = headerView;
    
    
    

}
- (UITableView *)tableView{

    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }

    return _tableView;

}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 140;
    

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *iden = @"cell";
    HXDMyshopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell)
        cell = [[HXDMyshopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    //cell.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}
#pragma mark - HXDHeaderViewDelegate
- (void)clickPersonMenuButtonType:(HXDPersonHeaderButtonType)type{
    switch (type) {
        case HXDPersonHeaderButtonAccumulate:{

            //累计销售额
            
            break;
        }
        case HXDPersonHeaderButtonTongji:{
            
            //统计截止
            
            break;
        }
            
        default:
            break;
    }



}
- (void)clickPersonButtonType:(HXDPersonButtonType)type;{


    switch (type) {
        case HXDPersonHeaderButtonVisit:{
            
            //今日访客
            
            break;
        }
        case HXDPersonHeaderButtonNum:{
            
            //今日订单数
            
            break;
        }
        case HXDPersonHeaderButtonSale:{
            
            //今日销售额
            
            break;
        }
            
        default:
            break;
    }




}
#pragma - HXDMyshopTableViewCellDelegate
- (void)clickPersonCellButtonType:(HXDPersonCellButtonType)type;{

    switch (type) {
        case HXDPersonCellButtonShopSetting:{
            
            //店铺设置
            
            break;
        }
        case HXDPersonCellOpenShopIdea:{
            
            //开店攻略
            
            break;
        }
        case HXDPersonCellShouyinTai:{
            
            //收银台
            
            break;
        }
            
        default:
            break;
            
    }



}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
