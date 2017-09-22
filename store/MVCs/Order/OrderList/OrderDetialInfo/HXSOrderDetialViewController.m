//
//  HXSOrderDetialViewController.m
//  store
//
//  Created by 格格 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderDetialViewController.h"

// Models
#import "HXSMyOrder.h"
#import "HXSOrderViewModel.h"

// Views
#import "HXSOrderStatusCell.h"
#import "HXSOrderStatusDescribeCell.h"
#import "HXSOrderCountdownCell.h"
#import "HXSOrderTimeLineCell.h"
#import "HXSOrderConsigneeInfoCell.h"
#import "HXShopNameAndOrderStatusCell.h"
#import "HXSGoodsInfoCell.h"

/** section类别 */
typedef NS_ENUM(NSInteger, OrderDetialSectionType)
{
    OrderDetialSectionTypeOrderStatus      = 0,  // 订单状态
    OrderDetialSectionTypeOrderCountdown   = 1,  // 倒计时
    OrderDetialSectionTypeOrderTimeLine    = 2,  // 时间轴
    OrderDetialSectionTypeBuyerInfo        = 3,  // 收货人信息
    OrderDetialSectionTypeGoodsList        = 4,  // 商品列表信息
    OrderDetialSectionTypeStageInfo        = 5,  // 分期信息
    OrderDetialSectionTypeBillInfo         = 6,  // 账单信息
    OrderDetialSectionTypeCustomerService  = 7,  // 客服信息
    OrderDetialSectionTypeOrderInfo        = 8   // 订单信息
};

/** 订单状态Row信息 */
typedef NS_ENUM(NSInteger, OrderStatusRowType)
{
    OrderStatusRowTypeStatus      = 0,   //  订单状态
    OrderStatusRowTypeDetialInfo  = 1,   //  退款描述
};

/** 商品列表信息Row类别 */
typedef NS_ENUM(NSInteger, OrderGoodsListRowType)
{
    OrderGoodsListRowTypeShopInfo          = 0,  // 店铺信息
    OrderGoodsListRowTypeGoodItem          = 1,  // 商品信息
};


// 用来保存每个section的类别信息和行数信息
@interface SectionModel : NSObject

@property (nonatomic, assign) OrderDetialSectionType sectionType;
@property (nonatomic, strong) NSMutableArray *rowInfoCellMarr;

@end

@interface RowModel : NSObject

@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, assign) CGFloat cellHeight;

@end


@interface HXSOrderDetialViewController ()//<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *dataMArr;

@property (nonatomic, strong) NSString *orderSnStr;
@property (nonatomic, strong) HXSMyOrder *myOrder;

@end

@implementation HXSOrderDetialViewController


#pragma mark - lift cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigation];
    
    [self initialTable];
    
    [self fectchMyOederDetial];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)controllerWithMyOrder:(NSString *)order_sn;
{
    HXSOrderDetialViewController *controller = [[HXSOrderDetialViewController alloc]initWithNibName:nil bundle:nil];
    controller.orderSnStr = order_sn;
    
    return controller;
}


#pragma mark - initial

- (void) initialNavigation
{
    self.navigationItem.title = @"订单详情";
}

- (void)initialTable
{
//    self.myTable.delegate = self;
//    self.myTable.dataSource = self;
}


#pragma mark - Private Mothed

- (void)updateDataMarr
{
    if (nil == self.myOrder) {
        return;
    }
    
    [self.dataMArr removeAllObjects];
    
    // 订单状态
    if (self.myOrder.orderStatus) {
        
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeOrderStatus;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        // 订单状态显示cell
        HXSOrderStatusCell *orderStatusCell = [HXSOrderStatusCell orderStatusCell];
        orderStatusCell.orderStatus = self.myOrder.orderStatus;
        
        RowModel *orderStatusModel =  [[RowModel alloc]init];
        orderStatusModel.cell = orderStatusCell;
        orderStatusModel.cellHeight = 44;
        
        [sectionModel.rowInfoCellMarr addObject:orderStatusModel];
        
        // 订单描述显示cell
        if (nil != self.myOrder.orderStatus.statusSpecStr) {
            
            HXSOrderStatusDescribeCell * orderStatusDescribeCell = [HXSOrderStatusDescribeCell orderStatusDescribeCell];
            orderStatusDescribeCell.orderStatus = self.myOrder.orderStatus;
            
            RowModel *orderStatusDescribeModel = [[RowModel alloc]init];
            orderStatusDescribeModel.cell = orderStatusDescribeCell;
            orderStatusDescribeModel.cellHeight = self.myOrder.orderStatus.cellHeight;
            
            [sectionModel.rowInfoCellMarr addObject:orderStatusDescribeModel];
        }
        
        [self.dataMArr addObject:sectionModel];
    }
    
    // 倒计时
    if (self.myOrder.orderStatus.invalidTimeStr) {
        
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeOrderCountdown;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        HXSOrderCountdownCell *orderCountdownCell = [HXSOrderCountdownCell orderCountdownCell];
        
        RowModel *orderCountdownModel = [[RowModel alloc]init];
        orderCountdownModel.cell = orderCountdownCell;
        orderCountdownModel.cellHeight = 72;
        
        [sectionModel.rowInfoCellMarr addObject:orderCountdownModel];
    
        [self.dataMArr addObject:sectionModel];
    }
    
    // 时间轴
    if (self.myOrder.timelineStatusArr) {
        
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeOrderTimeLine;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        HXSOrderTimeLineCell *orderTimeLineCell = [HXSOrderTimeLineCell orderTimeLineCell];
        orderTimeLineCell.timelineStatusArr = self.myOrder.timelineStatusArr;
        
        RowModel *orderTimeLineModel = [[RowModel alloc]init];
        orderTimeLineModel.cell = orderTimeLineCell;
        orderTimeLineModel.cellHeight = 72;
        
        [sectionModel.rowInfoCellMarr addObject:orderTimeLineModel];
        
        [self.dataMArr addObject:sectionModel];
    }
    
    // 收货人信息
    if (self.myOrder.buyerAddress) {
        
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeBuyerInfo;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        HXSOrderConsigneeInfoCell *orderConsigneeInfoCell = [HXSOrderConsigneeInfoCell orderConsigneeInfoCell];
        orderConsigneeInfoCell.buyerAddress = self.myOrder.buyerAddress;
        
        RowModel *orderConsigneeInfoModel = [[RowModel alloc]init];
        orderConsigneeInfoModel.cell = orderConsigneeInfoCell;
        orderConsigneeInfoModel.cellHeight = self.myOrder.buyerAddress.cellHeight;
        
        [sectionModel.rowInfoCellMarr addObject:orderConsigneeInfoModel];
        
        [self.dataMArr addObject:sectionModel];
    }
    

    [self.myTable reloadData];
}



#pragma mark - webService

- (void)fectchMyOederDetial
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSOrderViewModel fecthOrderDetialWithOrderId:self.orderSnStr
                                          complete:^(HXSErrorCode status, NSString *message, HXSMyOrder *myOrder) {
        
                                              [HXSLoadingView closeInView:weakSelf.view];
        
                                              if (kHXSNoError == status) {
                                                  weakSelf.myOrder = myOrder;
                                                  
#pragma TODO_XU 添加刷新table的代码
                                              }
    }];
 }


#pragma mark - Setter

- (void)setMyOrder:(HXSMyOrder *)myOrder
{
    _myOrder = myOrder;
    
    [self updateDataMarr];
}


#pragma mark - Getter

- (NSMutableArray *)dataMArr
{
    if(nil == _dataMArr) {
        return [NSMutableArray array];
    }
    
    return _dataMArr;
}

@end
