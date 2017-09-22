//
//  HXSPrintCouponViewController.m
//  store
//
//  Created by 格格 on 16/5/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintCouponViewController.h"

//views
#import "HXSPrintCouponViewCell.h"

// Model
#import "HXSPrintCouponModel.h"
#import "HXSPrintModel.h"

@interface HXSPrintCouponViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * coupons;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, assign) BOOL isAll;

@end

@implementation HXSPrintCouponViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.isFromPersonalCenter = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的优惠券";
    self.navigationController.navigationBarHidden = NO;
    
    if (!self.isFromPersonalCenter) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onClickSaveButton:)];
    }
    
    self.currentIndex = -1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = UIColorFromRGB(0xf4f3f2);
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 5;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStorePrint" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintCouponViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXSPrintCouponViewCell class])];
    
    self.coupons = [NSMutableArray array];
    
    [self getPrintCoupons];
}

- (void)setOrderAmount:(NSNumber *)amount docType:(NSNumber *)type isAll:(BOOL)isAll{
    self.amount = amount;
    self.type = type;
    self.isAll = isAll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Action/Target

- (void)onClickSaveButton:(id)sender {
    if(self.currentIndex >= 0
       && self.currentIndex < self.coupons.count) {
        if([self.delegate respondsToSelector:@selector(didSelectCoupon:)]) {
            HXSCoupon *coupon = [self.coupons objectAtIndex:self.currentIndex];
            [self.delegate didSelectCoupon:coupon];
            
            [self back];
        }
    } else {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"请选择一张优惠券"
                                       afterDelay:2];
    }
}


#pragma mark - webService

- (void)getPrintCoupons
{
    __weak typeof(self) weakSelf = self;
    
    [HXSPrintCouponModel getPrintCouponpicListWithType:self.type amount:self.amount isAll:self.isAll complete:^(HXSErrorCode code, NSString *message, NSArray *printCoupons) {
        
        if(code == kHXSNoError) {
            [weakSelf.coupons addObjectsFromArray:printCoupons];
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
        }
        
        [weakSelf showCoupons];
    }];
}


#pragma mark - UITabBarDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.coupons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXSCoupon *coupon = [self.coupons objectAtIndex:indexPath.section];
    HXSPrintCouponViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPrintCouponViewCell class]) forIndexPath:indexPath];
    
    if(coupon.type == HXSCouponTypeCash) {
        cell.materialLabel.hidden = YES;
        
        cell.discountLabel.hidden = NO;
        cell.yuanLabel.hidden = NO;
        
        cell.discountLabel.text = [NSString stringWithFormat:@"%.2f", coupon.discount.floatValue];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", coupon.text];
        cell.couponTipLabel.text = coupon.tip ? coupon.tip : @"";
    } else {
        cell.materialLabel.hidden = NO;
        
        cell.discountLabel.hidden = YES;
        cell.yuanLabel.hidden = YES;
        
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", coupon.text];
        cell.couponTipLabel.text = coupon.tip ? coupon.tip : @"";
    }
    
    cell.codeLabel.text = coupon.couponCode;
    cell.expireTimeLabel.text = [NSString stringWithFormat:@"%@-%@", [NSDate formatDate:[NSDate dateWithTimeIntervalSince1970:coupon.activeTime.integerValue] style:HXFormatDateStylePointDay], [NSDate formatDate:[NSDate dateWithTimeIntervalSince1970:coupon.expireTime.integerValue] style:HXFormatDateStylePointDay]];
    
    if(self.isFromPersonalCenter) {
        [cell.chooseImageView setHidden:YES];
    } else {
        [cell.chooseImageView setHidden:NO];
        
        if(indexPath.section == self.currentIndex) {
            UIImage *image = [HXSPrintModel imageFromNewName:@"btn_choose_blue"];
            cell.chooseImageView.image = image;
        } else {
            UIImage *image = [HXSPrintModel imageFromNewName:@"btn_choose_empty"];
            cell.chooseImageView.image = image;
        }
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    // update color
    [self setupCellColorStatus:cell indexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isFromPersonalCenter) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        self.currentIndex = indexPath.section;
        [self.tableView reloadData];
    }
}


#pragma mark - Setup Cell Methods

- (void)setupCellColorStatus:(HXSPrintCouponViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    HXSCoupon * coupon = [self.coupons objectAtIndex:indexPath.section];
    
    switch ([coupon.status intValue]) {
        case kHSXCouponStatusNotYet:
        case kHSXCouponStatusNormal:
        {
            UIColor *leftColor = [UIColor colorWithR:245 G:166 B:35 A:1.0];
            UIColor *grayColor = [UIColor colorWithR:152 G:152 B:152 A:1.0];
            cell.yuanLabel.textColor           = leftColor;
            cell.discountLabel.textColor       = leftColor;
            cell.materialLabel.textColor       = leftColor;
            cell.titleLabel.textColor          = [UIColor colorWithR:103 G:103 B:103 A:1.0];
            cell.codeNameLabel.textColor       = grayColor;
            cell.codeLabel.textColor           = grayColor;
            cell.expireTimeNameLabel.textColor = grayColor;
            cell.expireTimeLabel.textColor     = grayColor;
            cell.couponTipLabel.textColor      = grayColor;
            
            [cell.imageImageView sd_setImageWithURL:[NSURL URLWithString:coupon.image] placeholderImage:[HXSPrintModel imageFromNewName:@"img_coupon_monster_available"]];
        }
            break;
        case kHXSCouponStatusUsed:
        case kHXSCouponStatusExpired:
        {
            [cell.chooseImageView setHidden:YES];
            
            UIColor *color = [UIColor colorWithR:229 G:229 B:229 A:1.0];
            cell.yuanLabel.textColor           = color;
            cell.discountLabel.textColor       = color;
            cell.materialLabel.textColor       = color;
            cell.titleLabel.textColor          = color;
            cell.codeNameLabel.textColor       = color;
            cell.codeLabel.textColor           = color;
            cell.expireTimeNameLabel.textColor = color;
            cell.expireTimeLabel.textColor     = color;
            cell.couponTipLabel.textColor      = color;
            
            
            [cell.imageImageView sd_setImageWithURL:[NSURL URLWithString:coupon.image] placeholderImage:[HXSPrintModel imageFromNewName:@"img_coupon_monster_failed"]];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - others

- (void)showCoupons {
    if(self.coupons.count > 0) {
        self.tableView .hidden = NO;
        self.cannotFindImageView.hidden = YES;
        self.cannotFindLabel.hidden = YES;
    } else {
        self.tableView.hidden = YES;
        self.cannotFindImageView.hidden = NO;
        [self.cannotFindImageView setImage:[HXSPrintModel imageFromNewName:@"img_coupon_monster_failed"]];
         
        self.cannotFindLabel.hidden = NO;
        self.cannotFindLabel.text = @"您没有优惠券！";
    }
    
    [self.tableView reloadData];
}

@end
