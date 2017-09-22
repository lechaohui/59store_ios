//
//  HXSStoreDocumentLibraryCategoryViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSStoreDocumentLibraryCategoryViewController.h"
#import "HXSStoreDocumentLibraryChildCategoryViewController.h"

//views
#import "HXSStoreDocumentLibraryViewCell.h"
#import "HXSStoreDocumentLibraryCategoryView.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"

@interface HXSStoreDocumentLibraryCategoryViewController ()<HXSStoreDocumentLibraryCategoryViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView                      *mainTableView;
@property (nonatomic, strong) HXStoreDocumentLibraryCategoryListModel *listModel;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel         *documentViewModel;

@end

@implementation HXSStoreDocumentLibraryCategoryViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - create

+ (instancetype)createDocumentLibraryCategorVCWithListModel:(HXStoreDocumentLibraryCategoryListModel *)listModel;
{
    HXSStoreDocumentLibraryCategoryViewController *vc = [HXSStoreDocumentLibraryCategoryViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.listModel = listModel;
    
    return vc;
}


#pragma mark - init

- (void)initTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSStoreDocumentLibraryViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXSStoreDocumentLibraryViewCell class])];
}

- (void)initNavigationBar
{
    [self.navigationItem setTitle:_listModel.categoryNameStr];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    
    if(_listModel
       && _listModel.categoryArray.count > 0) {
        
        section = 1;
    }
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSStoreDocumentLibraryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSStoreDocumentLibraryViewCell class])
                                                                            forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat height = [self.documentViewModel getCategoryCellHeight:_listModel
                                                      andIsShowAll:YES];
    
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSStoreDocumentLibraryViewCell *tempCell = (HXSStoreDocumentLibraryViewCell *)cell;
    HXSStoreDocumentLibraryCategoryView *view = [HXSStoreDocumentLibraryCategoryView initLibraryCategoryViewWithCategoryList:_listModel
                                                                                                                andIsShowAll:YES];
    
    view.delegate = self;
    
    [tempCell addSubview:view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark - HXSStoreDocumentLibraryCategoryViewDelegate

- (void)categoryButtonClick:(HXStoreDocumentLibraryCategoryListModel *)listModel
                andCategory:(HXStoreDocumentLibraryCategoryModel *)model;

{
    HXSStoreDocumentLibraryChildCategoryViewController *childCategoryVC = [HXSStoreDocumentLibraryChildCategoryViewController createDocumentLibraryChiledCategorVCWithCategoryId:model.categoryIdNum
                                                                                                                                                                    andTitleName:model.categoryNameStr];
    
    [self.navigationController pushViewController:childCategoryVC animated:YES];
}

#pragma mark - Get Set Methods

- (HXStoreDocumentLibraryViewModel *)documentViewModel
{
    if(nil == _documentViewModel) {
        _documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _documentViewModel;
}

@end
