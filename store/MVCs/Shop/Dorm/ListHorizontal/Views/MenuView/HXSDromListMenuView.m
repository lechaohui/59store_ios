//
//  HXSDromListMenuView.m
//  store
//
//  Created by  黎明 on 16/8/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDromListMenuView.h"

#import "HXSDromListMenuCell.h"
#import "HXSCategoryModel.h"
#import "HXSSnacksCategoryModelSet.h"

static NSString * const DromListMenuCell = @"HXSDromListMenuCell";
static CGFloat const kDefaultCellHegiht = 44.0f;


@interface HXSDromListMenuView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<HXSSnacksCategoryModel*> *modelArr;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end


@implementation HXSDromListMenuView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupSubViews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tableView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.922 green:0.925 blue:0.933 alpha:1.000];
    
    [self addSubview:self.tableView];
    
    [self registerTableViewCell];
}

- (void)registerTableViewCell
{
    [self.tableView registerNib:[UINib nibWithNibName:DromListMenuCell bundle:nil] forCellReuseIdentifier:DromListMenuCell];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDefaultCellHegiht;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDromListMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:DromListMenuCell forIndexPath:indexPath];
    
    HXSSnacksCategoryModel *snacksCategoryModel = self.modelArr[indexPath.row];
    cell.titleLabel.text = snacksCategoryModel.categoryName;
    cell.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [cell.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    if(0 == indexPath.row) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        self.selectedIndexPath = indexPath;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedIndexPath.row) {
        // If has selected, don't fetch data any more.
        return;
    } else {
        self.selectedIndexPath = indexPath;
    }
    
    [self.dataSource menuView:self didSelect:indexPath];
}


#pragma mark - Setter Methods

- (NSArray<HXSSnacksCategoryModel*> *)modelArr
{
    _modelArr = [self.dataSource theCategoriesFromServer];
    
    return _modelArr;
}


@end
