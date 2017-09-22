//
//  HXSMessageViewController.m
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  消息盒子

#import "HXSMessageViewController.h"

// Controller
#import "HXSMessageItemListVC.h"
#import "HXSLoginViewController.h"

// Models
#import "HXSMessageBoxViewModel.h"
#import "Udesk.h"
#import "UdeskAgentMenuViewController.h"

// Views
#import "HXSMessageBoxCell.h"
#import "HXSLineView.h"

static NSString *kHXSMessageBoxCell = @"HXSMessageBoxCell";

@interface HXSMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) IBOutlet UITableView *myTable;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *noDataFooterView;

@end

@implementation HXSMessageViewController


#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initialPrama];
    
    [self initialMyTable];
    
    [self initialNewConfigUdesk];
    
    [self fetchMessageCateList];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self changeNavigationBarBackgroundColor:[UIColor colorWithHexString:@"fde25c"]
                        pushBackButItemImage:[UIImage imageNamed:@"btn_back_normal"]
                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
                                  titleColor:[UIColor whiteColor]];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"消息中心";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
}

- (void)initialPrama
{
    self.dataArray = [NSMutableArray array];
}

- (void)initialMyTable
{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable registerNib:[UINib nibWithNibName:kHXSMessageBoxCell bundle:nil] forCellReuseIdentifier:kHXSMessageBoxCell];
    self.myTable.rowHeight = 66;
    [self.myTable setBackgroundColor:[UIColor clearColor]];
    [self.myTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    WS(weakSelf);
    [self.myTable addRefreshHeaderWithCallback:^{
        [weakSelf fetchMessageCateList];
    }];
}

- (void)initialNewConfigUdesk
{
    // 构造参数
    HXSUserInfo *userInfo = [HXSUserAccount currentAccount].userInfo;
    
    NSString *nick_name = userInfo.basicInfo.uName;
    NSString *sdk_token = [[HXSUserAccount currentAccount] strToken];
    NSString *uid = [NSString stringWithFormat:@"%@", userInfo.basicInfo.uid];
    
    //获取用户自定义字段
    [UdeskManager getCustomerFields:^(id responseObject, NSError *error) {
        
        NSDictionary *customerFieldValueDic = @{};
        for (NSDictionary *dict in responseObject[@"user_fields"]) {
            if ([dict[@"field_label"] isEqualToString:@"用户id"]) {
                NSString *keyStr = dict[@"field_name"];
                
                customerFieldValueDic = @{keyStr: uid};
            }
        }
        
        NSDictionary *userDic = @{
                                  @"sdk_token":              [NSString md5:sdk_token],
                                  @"nick_name":              nick_name,
                                  @"customer_field":         customerFieldValueDic,
                                  };
        
        NSDictionary *parameters = @{@"user":userDic};
        // 创建用户
        [UdeskManager createCustomerWithCustomerInfo:parameters];
    }];
    
}


#pragma mark - webService

- (void)fetchMessageCateList
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSMessageBoxViewModel fetchMessageCateListComplete:^(HXSErrorCode code, NSString *message, NSArray *messageCateArr) {
        
        [HXSLoadingView closeInView:weakSelf.view];
        [weakSelf.myTable endRefreshing];
        
        if(kHXSNoError == code) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:messageCateArr];
            
            if(weakSelf.dataArray.count > 0) {
                [weakSelf.myTable setTableFooterView:nil];
            } else {
                [weakSelf.myTable setTableFooterView:weakSelf.noDataFooterView];
            }
            
            [weakSelf.myTable reloadData];
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5];
        }
    }];
}

- (void)updateMessageReaded:(HXSMessageCate *)messageCate
{
    [HXSLoadingView showLoadingInView:self.view];
    
    WS(weakSelf);
    
    [HXSMessageBoxViewModel updateMessageReadedWithCateId:messageCate.cateIdStr
                                                messageId:nil
                                                 complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                                     
                                                     [HXSLoadingView closeInView:weakSelf.view];
                                                     
                                                     if(kHXSNoError == code) {
                                                         
                                                         [weakSelf fetchMessageCateList];
                                                         // 更新外面的红点
                                                         [HXSMessageBoxViewModel fetchUnreadMessage];
                                                         
                                                     } else {
                                                         
                                                         [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                            status:message
                                                                                        afterDelay:1.5];
                                                     }
        
    }];
}


#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSMessageBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:kHXSMessageBoxCell];
    cell.messageCate = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    HXSLineView *lineView = [[HXSLineView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [lineView setBackgroundColor:HXS_COLOR_SEPARATION_STRONG];
    return lineView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row < [self.dataArray count]) {
        
        HXSMessageCate *messageCate = [self.dataArray objectAtIndex:indexPath.row];
        
        //cateIdStr == 5 为在线客服
        if ([messageCate.cateIdStr isEqualToString:@"5"]) {
            
            UdeskSDKManager *chatViewManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle defaultStyle]];
            
            [chatViewManager pushUdeskViewControllerWithType:UdeskMenu viewController:self];
            
            return;
        }
        
        HXSMessageItemListVC *MessageItemListVC = [HXSMessageItemListVC controllerWithMessageCate:messageCate];
        
        [self updateMessageReaded:messageCate];
        
        [self.navigationController pushViewController:MessageItemListVC animated:YES];
    }
}


#pragma mark - Getter
- (UIView *)noDataFooterView
{
    if(!_noDataFooterView) {
        _noDataFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 265)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 180)/2, 75, 180,140)];
        [imageView setImage:[UIImage imageNamed:@"icon_zanwuxiaoxi"]];
        [_noDataFooterView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 234, SCREEN_WIDTH, 21)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"暂时木有消息呦";
        lable.textColor = HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL;
        [lable setFont:[UIFont systemFontOfSize:14]];
        [_noDataFooterView addSubview:lable];
    }
    return _noDataFooterView;
}

@end
