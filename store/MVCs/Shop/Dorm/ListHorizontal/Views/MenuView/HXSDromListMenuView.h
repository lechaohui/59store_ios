//
//  HXSDromListMenuView.h
//  store
//
//  Created by  黎明 on 16/8/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
/************************************************************
 *  夜猫店侧边菜单栏
 ***********************************************************/
#import <UIKit/UIKit.h>

@class HXSSnacksCategoryModel, HXSDromListMenuView;

@protocol HXSDromListMenuViewDataSource<NSObject>

@required
- (NSArray<HXSSnacksCategoryModel*> *)theCategoriesFromServer;

- (void)menuView:(HXSDromListMenuView *)menuView didSelect:(NSIndexPath *)indexPath;

@end


@interface HXSDromListMenuView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<HXSDromListMenuViewDataSource> dataSource;


@end
