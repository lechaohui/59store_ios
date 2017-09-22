//
//  HXDMainViewController.m
//  store
//
//  Created by caixinye on 2017/9/7.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXDMainViewController.h"

@interface HXDMainViewController ()<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView            *tableView;

@property (nonatomic, strong) HXDBlankView           *noDataBlankView;
@property (nonatomic, assign) CGFloat                headerViewHeight;

@end

@implementation HXDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationItem.title = @"我的订单";
    [self initTitleView];
    [self initialSubviews];
    
    
    
}


- (void)initTitleView{


    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    //背景
    UIView *titleBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    titleBackView.backgroundColor=[UIColor colorWithHexString:@"fde25c"];
    [self.view addSubview:titleBackView];
    
    UILabel *titleLb=[Maker makeLb:CGRectMake(0, 20, SCREEN_WIDTH, 44)
                             title:@"订单处理"
                         alignment:NSTextAlignmentCenter
                              font:[UIFont systemFontOfSize:18]
                         textColor:[UIColor colorWithHexString:@"333333"]];
    [titleBackView addSubview:titleLb];
    
    //backbut
    UIButton *bacBut = [Maker makeBtn:CGRectMake(15, 25, 25, 34) title:nil img:@"btn_back_normal" font:nil target:self action:@selector(back)];
    [titleBackView addSubview:bacBut];
    
    //rightBut
    UIButton *rightBut = [Maker makeBtn:CGRectMake(SCREEN_WIDTH-65, 30, 60, 25) title:@"历史订单" img:nil font:[UIFont systemFontOfSize:14] target:self action:@selector(history:)];
    [titleBackView addSubview:rightBut];
    



}
#pragma mark - Intial Methods

- (void)initialSubviews{

    
    //[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil]; // 先删除之前视图
    
    WS(ws);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.edges.equalTo(ws.view);
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
        make.top.equalTo(ws.view).offset(64);
        make.bottom.equalTo(ws.view);

    }];
    
    
    

    
    
    



}
#pragma mark - Lazy Load

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //_tableView.tableHeaderView = self.headerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        WS(ws);
        //[_tableView registerNib:[UINib nibWithNibName:kHXDUnprocessedOrderTableViewCell bundle:nil]
         //forCellReuseIdentifier:kHXDUnprocessedOrderTableViewCellIdentifier];
//        _tableView.mj_header = [HXDRefreshHeader headerWithRefreshingBlock:^{
//           // [ws loadTheUnCompleteOrdersWithMBProressHUD:NO];
//        }];
        [_tableView addRefreshHeaderWithCallback:^{
            
            
            
            
        }];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //    NSInteger section = 0;
//    if(_unprocessedOrdersArray && [_unprocessedOrdersArray count]>0)
//        section = [_unprocessedOrdersArray count];
//    return section;
    return 1;
    
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 173.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    HXDUnprocessedOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHXDUnprocessedOrderTableViewCellIdentifier];
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    HXDUnprocessedOrderTableViewCell *unprocessedCell = (HXDUnprocessedOrderTableViewCell *)cell;
    HXDOrderModel *order = _unprocessedOrdersArray[indexPath.section];
    [unprocessedCell configWithOrderModel:order];
    if (order.status == 1 || (order.paytype == kHXDOrderPayTypeAlipay && order.paystatus == kHXDPayStatusNotPayed)) {
        [unprocessedCell hideRedPoint];
    } else {
        [unprocessedCell showRedPoint];
    }
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    /*
    HXDOrderDetailViewController *vc = [[HXDOrderDetailViewController alloc] initWithNibName:@"HXDOrderDetailViewController" bundle:nil];
    HXDOrderModel *order = _unprocessedOrdersArray[indexPath.section];
    vc.orderModel = order;
    vc.delegate = self;
    if (order.status == 0) { // 订单状态 0表示已提交
        if (order.paystatus == kHXDPayStatusNotPayed && order.paytype == kHXDOrderPayTypeAlipay)  {
            //支付宝订单未支付，do nothing
        } else { //其它情况把订单状态改成开始处理
            WEAKSELF
            [order startProcessingWithBlocksSuccess:^{
                order.status = 1;
                [weakSelf.tableView reloadData];
            } failure:nil];
        }
    }
    [self.navigationController pushViewController:vc animated:YES];*/
}
#pragma mark - target
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)history:(UIButton *)sender{







}
@end
