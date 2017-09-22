//
//  HXSDromListDetailView.m
//  store
//
//  Created by  黎明 on 16/8/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDromListDetailView.h"

#import "HXSDormItemTableViewCell.h"
#import "HXSDormItemMaskView.h"
#import "HXSShopEntity.h"

static CGFloat const kHeightCell               = 104.0f;
static CGFloat const kHeightCellDesctionpetion = 12.0f;

static NSString * const DormItemTableViewCell = @"HXSDormItemTableViewCell";

@interface HXSDromListDetailView()<UITableViewDataSource,
                                   UITableViewDelegate,
                                   HXSDormItemTableViewCellDelegate>

@end

@implementation HXSDromListDetailView


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
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:self.tableView];
    
    [self registerTableViewCell];
}

- (void)registerTableViewCell
{
    UINib *dormItemTableViewCellNib = [UINib nibWithNibName:NSStringFromClass([HXSDormItemTableViewCell class]) bundle:nil];
    [self.tableView registerNib:dormItemTableViewCellNib forCellReuseIdentifier:DormItemTableViewCell];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemListArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDormItem *dormItem = self.itemListArr[indexPath.row];
    if (0 < [dormItem.promotions count]) {
        return kHeightCell;
    } else {
        NSString *desctionString =dormItem.descriptionStr;
        CGSize size = [desctionString boundingRectWithSize:CGSizeMake(150, 0)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                   context:nil].size;
        
        if(size.height > kHeightCellDesctionpetion) {
            return kHeightCell + size.height - kHeightCellDesctionpetion;
        } else {
            return kHeightCell;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDormItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DormItemTableViewCell forIndexPath:indexPath];
    cell.delegate = self;
    
    if(self.itemListArr.count > indexPath.section) {
        
        HXSDormItem *item = self.itemListArr[indexPath.row];
        
        [cell setItem:item dormStatus:(int)[self.shopEntity.statusIntNum integerValue]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separatorInset = UIEdgeInsetsMake(0, 10.0, 0, 0);
    
    return cell;
}

#pragma mark - HXSDormItemTableViewCellDelegate

- (void)dormItemTableViewCellDidShowDetail:(HXSDormItemTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if(indexPath.section >= [self.itemListArr count]) {
        return;
    }
    
    CGRect frame = cell.imageImageVeiw.frame;
    frame = [cell convertRect:frame toView:[AppDelegate sharedDelegate].window];
    
    HXSDormItem * item = self.itemListArr[indexPath.row];
    UIImage *image = cell.imageImageVeiw.image;
    
    HXSDormItemMaskDatasource *dataSource = [[HXSDormItemMaskDatasource alloc] init];
    dataSource.image = image;
    dataSource.initialImageFrame = frame;
    dataSource.item = item;
    dataSource.shopEntity = self.shopEntity;
    
    HXSDormItemMaskView *itemMaskView = [[HXSDormItemMaskView alloc] initWithDataSource:dataSource delegate:nil];
    [[AppDelegate sharedDelegate].window addSubview:itemMaskView];
    [itemMaskView show];

}

- (void)dormItemTableViewCellDidClickEvent:(HXSClickEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(dormItemTableViewCellDidClickEvent:)]) {
        [self.delegate dormItemTableViewCellDidClickEvent:event];
    }
}

- (void)updateCountOfRid:(NSNumber *)countNum inItem:(HXSDormItem *)item
{
    if(self.delegate) {
        [self.delegate updateCountOfSnack:countNum inItem:item];
    }
}


#pragma mark - GET Methods


- (NSMutableArray *)itemListArr
{
    if(!_itemListArr){
        _itemListArr = [NSMutableArray new];
    }
    return _itemListArr;
}
@end
