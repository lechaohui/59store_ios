//
//  HXSMessageItemListVC.m
//  store
//
//  Created by 格格 on 16/8/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  分类下的消息列表

#import "HXSMessageItemListVC.h"

// Models
#import "HXSMessageBoxViewModel.h"
#import "HXSMessageBoxViewModel.h"

// Views
#import "HXSMessageItemCell.h"


static NSString *kHXSMessageItemCellId = @"HXSMessageItemCell";


@interface HXSMessageItemListVC ()<UITableViewDelegate,
                                   UITableViewDataSource,
                                   HXSMessageItemCellDelegate>

@property (nonatomic,weak) IBOutlet UITableView *myTable;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
@property (nonatomic,assign) BOOL ifGetMore;

@property (nonatomic,strong) NSMutableArray<HXSMessageItem *> *dataArray;
@property (nonatomic,strong) HXSMessageCate *messageCate;

@property (nonatomic, strong) UIView *noDataFooterView;

@end

@implementation HXSMessageItemListVC


#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initialPrama];
    
    [self initialMyTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)controllerWithMessageCate:(HXSMessageCate *)messageCate
{
    HXSMessageItemListVC *controller = [[HXSMessageItemListVC alloc]initWithNibName:nil bundle:nil];
    controller.messageCate = messageCate;
    return controller;
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title =  self.messageCate.cateNameStr;
}

- (void)initialPrama
{
    self.page = 1;
    self.size = 20;
    self.ifGetMore = NO;
    self.dataArray = [NSMutableArray array];
}

- (void)initialMyTable
{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.myTable registerNib:[UINib nibWithNibName:kHXSMessageItemCellId bundle:nil] forCellReuseIdentifier:kHXSMessageItemCellId];
    
    WS(weakSelf);
    [self.myTable addRefreshHeaderWithCallback:^{
        weakSelf.ifGetMore = NO;
        [weakSelf fetMessageItemList];
    }];
    
    [self fetMessageItemList];
    
    [self.myTable addInfiniteScrollingWithActionHandler:^{
        weakSelf.ifGetMore = YES;
        [weakSelf fetMessageItemList];
    }];
    
    [self.myTable setShowsInfiniteScrolling:NO];
}


#pragma mark - webservice

- (void)fetMessageItemList
{
    NSInteger currentpage;
    if(self.ifGetMore) {
        currentpage = self.page + 1;
    } else {
        currentpage = 1;
    }
    WS(weakSelf);
    [HXSMessageBoxViewModel fetMesssageListWithModel:self.messageCate
                                                page:currentpage
                                                size:self.size
                                            complete:^(HXSErrorCode code, NSString *message, NSArray *messageItemArr) {
                                                
                                                [weakSelf.myTable endRefreshing];
                                                [[weakSelf.myTable infiniteScrollingView] stopAnimating];
                                                
                                                if(kHXSNoError == code) {
                                                    if(!weakSelf.ifGetMore) {
                                                        [weakSelf.dataArray removeAllObjects];
                                                    }
                                                    weakSelf.page = currentpage;
                                                    
                                                    [weakSelf.myTable setShowsInfiniteScrolling:messageItemArr.count > 0];
                                                    
                                                    [weakSelf.dataArray addObjectsFromArray:messageItemArr];
                                                    
                                                    if(weakSelf.dataArray.count > 0) {
                                                        [weakSelf.myTable setTableFooterView:nil];
                                                    } else {
                                                        [weakSelf.myTable setTableFooterView:weakSelf.noDataFooterView];
                                                    }
                                                    
                                                    [weakSelf.myTable reloadData];
                                                    
                                                } else {
                                                    [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                                }
    }];

}


#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSMessageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kHXSMessageItemCellId];
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section < self.dataArray.count) {
        
        HXSMessageItem *messageItem = [self.dataArray objectAtIndex:indexPath.section];
        
        cell.messageItem = messageItem;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.dataArray.count) {
        
        HXSMessageItem *messageItem = [self.dataArray objectAtIndex:indexPath.section];
        return messageItem.cellHeight;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.dataArray count] - 1 > section)
        return 0.1;
    return 15; // 最后一条消息距离底部留15的距离
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < self.dataArray.count) {
        
        HXSMessageItem *messageItem = [self.dataArray objectAtIndex:section];
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [timeLabel setFont:[UIFont systemFontOfSize:14]];
        [timeLabel setTextColor:HXS_INFO_NOMARL_COLOR];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        timeLabel.text = [self messageTimeStr:messageItem.createTimeStr];
        
        return timeLabel;
        
    } else {
        
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXSMessageItem *messageItem = [self.dataArray objectAtIndex:indexPath.section];
    
    [self pushToVCWithLink:messageItem.linkStr];
}


#pragma mark - HXSMessageItemCellDelegate

- (void)messageItemCell:(HXSMessageItemCell *)messageItemCell
            copyMessage:(HXSMessageItem *)messageItem
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    NSString *copyText = [NSString stringWithFormat:@"%@\n%@",messageItem.titleStr,messageItem.contentStr];
    [pasteboard setString:copyText];
}

- (void)messageItemCell:(HXSMessageItemCell *)messageItemCell
          deleteMessage:(HXSMessageItem *)messageItem
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSMessageBoxViewModel deleteMessageItemWithMessageId:messageItem.messageIdStr
                                                  complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                                      
                                                      [HXSLoadingView closeInView:weakSelf.view];
                                                      
                                                      if(kHXSNoError == code) {
                                                          
                                                          [weakSelf.dataArray removeObject:messageItem];
                                                          [weakSelf.myTable reloadData];
                                                          
                                                      } else {
                                                          
                                                          [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                                      }
        
    }];

}


#pragma mark Puch To LinkStr VCs

- (void)pushToVCWithLink:(NSString *)linkStr
{
    NSURL *url = [NSURL URLWithString:linkStr];
    if (nil == url) {
        url = [NSURL URLWithString:[linkStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:url
                                                                               completion:nil];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - Private method

- (NSString *)messageTimeStr:(NSString *)messageTiem
{
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:messageTiem.longLongValue];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc]init];
    // 今天
    if([currentCalendar isDateInToday:messageDate]) {
        [dateFormatter setDateFormat:@"HH:mm"];
    } else if ([currentCalendar isDateInYesterday:messageDate]) {
        [dateFormatter setDateFormat:@"昨天 HH:mm"];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateFormatter stringFromDate:messageDate];
}


#pragma mark - Getter

- (UIView *)noDataFooterView
{
    if(!_noDataFooterView) {
        _noDataFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 265)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 180)/2, 75, 180,140)];
        [imageView setImage:[UIImage imageNamed:@"img_kong_wodehuifu"]];
        [_noDataFooterView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 234, SCREEN_WIDTH, 21)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"暂无消息哦";
        lable.textColor = HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL;
        [lable setFont:[UIFont systemFontOfSize:14]];
        [_noDataFooterView addSubview:lable];
    }
    return _noDataFooterView;
}

@end
