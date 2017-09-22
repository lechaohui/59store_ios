//
//  HXSXiuxianFoodViewController.m
//  store
//
//  Created by caixinye on 2017/9/1.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSXiuxianFoodViewController.h"
#import "HXSSelectView.h"
#import "HXSXiuxianFoodViewController.h"
#import "HXSDoodsCollectionViewCell.h"

@interface HXSXiuxianFoodViewController ()<HXSSelectViewDelegate,goodsCollectioncellDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) HXSSelectView *selectView;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)HXSDoodsCollectionViewCell *collectionCell;


@end

@implementation HXSXiuxianFoodViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initTitleView];
    
    [self.view addSubview:self.selectView];
    
    [self.view addSubview:self.collectionView];
    // 注册collectionViewcell:CollectionViewCell是我自定义的cell的类型
    [self.collectionView registerClass:[HXSDoodsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    
    //[self checkTheScrollViewOffsetAndSetTheNavigationBarWithScrollView:self.shopTableView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    //[self.navigationController.navigationBar at_resetBackgroundColor:HXS_COLOR_MASTER translucent:YES];
}
- (void)initTitleView{


    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    //背景
    UIView *titleBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    titleBackView.backgroundColor=[UIColor colorWithHexString:@"fde25c"];
    [self.view addSubview:titleBackView];
    
    UILabel *titleLb=[Maker makeLb:CGRectMake(0, 20, SCREEN_WIDTH, 44)
                             title:@"休闲零食"
                         alignment:NSTextAlignmentCenter
                              font:[UIFont systemFontOfSize:18]
                         textColor:[UIColor colorWithHexString:@"333333"]];
    [titleBackView addSubview:titleLb];
    
    //backbut
    UIButton *bacBut = [Maker makeBtn:CGRectMake(15, 25, 25, 34) title:nil img:@"btn_back_normal" font:nil target:self action:@selector(back)];
    [titleBackView addSubview:bacBut];
    
}
- (void)back{

    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark HXSSelectViewDelegate
- (void)selectTopButton:(HXSSelectView *)selectView withIndex:(NSInteger)index withButtonType:(ButtonClickType )type1;{

    //价格
    if (index == 102&&type1) {
        switch (type1) {
            case ButtonClickTypeNormal:
                //正常价格
            {
                NSLog(@"正常价格");
                
            }
                break;
            case ButtonClickTypeUp:
                //价格升序排列
            {
                NSLog(@"价格升序排列");
            }
                break;
            case ButtonClickTypeDown:
                //价格降序排列
            {
                NSLog(@"价格降序排列");
            }
                break;
            default:
                break;
        }
    }else if (index == 100){//销量
        NSLog(@"上边按钮的销量");
        
    }else  {//新品
        
        NSLog(@"上边按钮的新品");
    }



}
-(HXSSelectView *)selectView{
    
    if (!_selectView) {
        
        _selectView = [[HXSSelectView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) withArr:nil];
        _selectView.delegate = self;
    }
    _selectView.selectItmeArr = nil;
    return _selectView;
    
}
- (UICollectionView *)collectionView{


    if (_collectionView == nil) {
     UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
     [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
     layout.minimumInteritemSpacing = 10;// 垂直方向的间距
     layout.minimumLineSpacing = 10; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 64+50, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-44) collectionViewLayout:layout];

        _collectionView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        
    }

    return _collectionView;
}
#pragma mark -- UICollectionViewDataSource
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return 7;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXSDoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
   // cell.model = self.dataArray[indexPath.row];
    //要把索引传过去后面用的到
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
#pragma mark -- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH-30)/2.0;
    CGFloat height = 200;
    return CGSizeMake(width, height);
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
}
#pragma goodsCollectioncellDelegate
- (void)onCartButtonClick:(HXSDoodsCollectionViewCell *)cell;{

//    if (cell.indexPath.row < [self.dataArray count]) {
//        BrandSearchModel *model = self.dataArray[cell.indexPath.row];
//        //follow为true为收藏，false为未收藏
//        NSString *follow = [model.follow isEqualToString:@"false"] ? @"true" : @"false";
//        model.follow = follow;//更改本地数据
//        
//        if ([model.follow isEqualToString:@"true"]){
//            [self requestCollectDataWithModel:model andCell:cell];
//        }else {
//            [self requestUncollectDataWithModel:model andCell:cell];
//        }
//    }



}
/*
#pragma mark - =================是否加入购物车=================
//收藏(网络请求)
- (void)requestCollectDataWithModel:(BrandSearchModel *)model andCell:(BrandSearchResultCollectCell *)cell{
    
    NSMutableDictionary *params = [CBConnect getBaseRequestParams];
    [params setValue:model.cxkey forKey:@"cxkey"];//商标注册号
    [params setValue:model.intcls forKey:@"intcls"];//商标国际分类
    
    [CBConnect getBrandCollectTradeMark:params success:^(id responseObject) {
        //请求成功则刷新
        [self.mCollectionView reloadItemsAtIndexPaths:@[cell.indexPath]];
    } successBackfailError:^(id responseObject) {
        model.follow = @"false";//失败的话则恢复原来的值
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}*/
/*
//取消加入购物车
- (void)requestUncollectDataWithModel:(BrandSearchModel *)model andCell:(BrandSearchResultCollectCell *)cell{
    
    NSMutableDictionary *params = [CBConnect getBaseRequestParams];
    [params setValue:model.cxkey forKey:@"cxkey"];//商标注册号
    [params setValue:model.intcls forKey:@"intcls"];//商标国际分类
    
    [CBConnect getBrandUncollectTradeMark:params success:^(id responseObject) {
        //请求成功则刷新
        [self.mCollectionView reloadItemsAtIndexPaths:@[cell.indexPath]];
        
    } successBackfailError:^(id responseObject) {
        model.follow = @"true";//失败的话则恢复原来的值
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
