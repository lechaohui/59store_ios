//
//  HXSStoreDocumentLibraryCategoryView.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSStoreDocumentLibraryCategoryView.h"
#import "HXStoreDocumentLibraryViewModel.h"
#import "HXSLineView.h"

CGFloat const singleButtonHeight = 44.0;

#define limitTotalCategoryNum columnsLimitCategoryCell*rowsLimitCategoryCell

@interface HXSStoreDocumentLibraryCategoryView()

@property (nonatomic, strong) HXStoreDocumentLibraryViewModel           *viewModel;
@property (nonatomic, strong) HXStoreDocumentLibraryCategoryListModel   *categoryListModel;
@property (nonatomic, assign) BOOL                                      isShowAll;

@end

@implementation HXSStoreDocumentLibraryCategoryView

+ (instancetype)initLibraryCategoryViewWithCategoryList:(HXStoreDocumentLibraryCategoryListModel *)categoryListModel
                                           andIsShowAll:(BOOL)isShowAll
{
    HXSStoreDocumentLibraryCategoryView *categoryView = [[HXSStoreDocumentLibraryCategoryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    CGFloat viewHeight =  [categoryView.viewModel getCategoryCellHeight:categoryListModel
                                                           andIsShowAll:isShowAll];
    [categoryView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
    categoryView.categoryListModel = categoryListModel;
    categoryView.isShowAll         = isShowAll;
    
    [categoryView setupSubView];
    
    return categoryView;
}


#pragma mark - life cycle

-(void)drawRect:(CGRect)rect
{
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupSubView
{
    NSArray *categoryArray = _categoryListModel.categoryArray;
    NSMutableArray<HXStoreDocumentLibraryCategoryModel *> *currentCategoryArray = [[NSMutableArray<HXStoreDocumentLibraryCategoryModel *> alloc]init];
    
    if(_isShowAll) {
        [currentCategoryArray addObjectsFromArray:categoryArray];
    } else {
        for (NSInteger i = 0; i < limitTotalCategoryNum; i++) {
            [currentCategoryArray addObject:[categoryArray objectAtIndex:i]];
        }
    }
    
    for (HXStoreDocumentLibraryCategoryModel *categoryModel in currentCategoryArray) {
        
        UIButton *button = [self createCategoryButton:categoryModel
                                     andCategoryArray:categoryArray];
        
        [self addSubview:button];
        
        [self categoryButtonAutoLayoutMasonry:button];
    }
    
    [self drawLineForViewWithCategoryArray:currentCategoryArray];
}

/**
 *  制作单个category 按钮
 *
 *  @param categoryModel
 *  @param categoryArray
 *
 *  @return 
 */
- (UIButton *)createCategoryButton:(HXStoreDocumentLibraryCategoryModel *)categoryModel
                  andCategoryArray:(NSArray<HXStoreDocumentLibraryCategoryModel *> *)categoryArray
{
    UIButton *button = [[UIButton alloc]init];
    if(categoryArray.count > limitTotalCategoryNum
       && [categoryArray indexOfObject:categoryModel] == limitTotalCategoryNum - 1
       && !_isShowAll) {
        [button setTitle:@"更多分类" forState:UIControlStateNormal];
    } else {
        [button setTitle:categoryModel.categoryNameStr forState:UIControlStateNormal];
    }
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [button setTag:[categoryArray indexOfObject:categoryModel]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [button setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(categoryButtonClickAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

/**
 *  按钮点击事件
 *
 *  @param categoryButton
 */
- (void)categoryButtonClickAction:(UIButton *)categoryButton
{
    if(!_isShowAll
       && categoryButton.tag == limitTotalCategoryNum - 1) {
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(categoryMoreButtonClick:)]) {
            [self.delegate categoryMoreButtonClick:_categoryListModel];
        }
    } else {
        HXStoreDocumentLibraryCategoryModel *model = [_categoryListModel.categoryArray objectAtIndex:categoryButton.tag];
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(categoryButtonClick:andCategory:)]) {
            [self.delegate categoryButtonClick:_categoryListModel
                                   andCategory:model];
        }
    }
}

/**
 *  给每一个按钮进行布局
 *
 *  @param button
 */
- (void)categoryButtonAutoLayoutMasonry:(UIButton *)button
{
    CGFloat butonWidth = SCREEN_WIDTH / 3;
    CGFloat buttonHeight = singleButtonHeight;
    NSInteger tag = button.tag;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        if(tag % columnsLimitCategoryCell == 0) {//左边列
            make.left.equalTo(self);
        } else if(tag % columnsLimitCategoryCell == 1) {//中间列
            make.left.equalTo(self).offset(butonWidth);
        } else {//右边列
            make.right.equalTo(self);
        }
        
        make.top.equalTo(self).offset((tag / columnsLimitCategoryCell) * singleButtonHeight);
        make.width.mas_equalTo(butonWidth);
        make.height.mas_equalTo(buttonHeight);
    }];
}

/**
 *  根据当前界面画分割线
 */
- (void)drawLineForViewWithCategoryArray:(NSMutableArray *)currentCategoryArray
{
    UIColor *lineColor = [UIColor colorWithRGBHex:0xE1E2E3];
    NSInteger countsCategory = [currentCategoryArray count];
    NSInteger totalRows = countsCategory / columnsLimitCategoryCell + (countsCategory % columnsLimitCategoryCell == 0 ? 0 : 1);
    CGFloat butonWidth = SCREEN_WIDTH / 3;
    
    for (NSInteger i = 0; i < totalRows - 1; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, singleButtonHeight * (i + 1))];
        [path addLineToPoint:CGPointMake(self.width, singleButtonHeight * (i + 1))];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor     = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor   = lineColor.CGColor;
        shapeLayer.lineWidth     = 1;
        shapeLayer.path          = path.CGPath;
        
        [self.layer addSublayer:shapeLayer];
    }
    //画第一条竖线
    UIBezierPath *pathColum1st = [UIBezierPath bezierPath];
    [pathColum1st moveToPoint:CGPointMake(butonWidth, 0)];
    [pathColum1st addLineToPoint:CGPointMake(butonWidth, self.height)];
    CAShapeLayer *shapeLayerColum1st = [CAShapeLayer layer];
    shapeLayerColum1st.fillColor     = [UIColor clearColor].CGColor;
    shapeLayerColum1st.strokeColor   = lineColor.CGColor;
    shapeLayerColum1st.lineWidth     = 1;
    shapeLayerColum1st.path          = pathColum1st.CGPath;
    [self.layer addSublayer:shapeLayerColum1st];
    
    //画第二条竖线
    if(countsCategory == 1) {
        return;
    }    
    UIBezierPath *pathColum2nd = [UIBezierPath bezierPath];
    [pathColum2nd moveToPoint:CGPointMake(butonWidth * 2, 0)];
    
    if(countsCategory % columnsLimitCategoryCell == 0
       || countsCategory % columnsLimitCategoryCell == 2) {
        [pathColum2nd addLineToPoint:CGPointMake(butonWidth * 2, self.height)];
    } else {
        [pathColum2nd addLineToPoint:CGPointMake(butonWidth * 2, self.height - singleButtonHeight)];
    }
    CAShapeLayer *shapeLayerColum2nd = [CAShapeLayer layer];
    shapeLayerColum2nd.fillColor     = [UIColor clearColor].CGColor;
    shapeLayerColum2nd.strokeColor   = lineColor.CGColor;
    shapeLayerColum2nd.lineWidth     = 1;
    shapeLayerColum2nd.path          = pathColum2nd.CGPath;
    [self.layer addSublayer:shapeLayerColum2nd];
}

#pragma mark - getter setter

- (HXStoreDocumentLibraryViewModel *)viewModel
{
    if(nil == _viewModel) {
        _viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _viewModel;
}

@end
