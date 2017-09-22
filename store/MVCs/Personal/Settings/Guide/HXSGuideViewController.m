//
//  HXSGuideViewController.m
//  Animation
//
//  Created by hudezhi on 15/8/2.
//  Copyright (c) 2015年 59store. All rights reserved.
//

#import "HXSGuideViewController.h"

@interface GuidePageView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *topImageView;
@property (nonatomic, weak) IBOutlet UILabel     *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel     *deltialLabel;
@property (nonatomic, weak) IBOutlet UIButton    *entryButton;

@property (nonatomic, weak) IBOutlet UIImageView *iphone4GuidImage;

@end

@implementation GuidePageView

@end

@interface HXSGuideViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *pageViewArr;

@end

@implementation HXSGuideViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initialScrollView];
    
    [self initialPageControl];
    
    [self.view bringSubviewToFront:self.pageControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.block = nil;
    
    DLog(@"%s dealloc.", __FILE__);
}


#pragma mark - Override Methods

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _scrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    CGFloat width = _scrollView.width;
    
    for(int i = 0; i < [self.pageViewArr count]; i++) {
        GuidePageView *pageView = [self.pageViewArr objectAtIndex:i];
        pageView.frame = CGRectMake(i * width, 0, width, _scrollView.height);
    }

    // scrollview content size
    _scrollView.contentSize = CGSizeMake(width * [self.pageViewArr count], _scrollView.height);
    
    [self.view layoutIfNeeded];
}


#pragma mark - Initial Methods

- (void)initialPageControl
{
    self.pageControl.pageIndicatorTintColor = HXS_INFO_NOMARL_COLOR;
    self.pageControl.currentPageIndicatorTintColor = HXS_COLOR_MASTER;
}

- (void)initialScrollView
{
    NSArray *imageNameArr = @[@"img_yingdaoye01",
                              @"img_yingdaoye02",
                              @"img_yingdaoye03",
                              @"img_yingdaoye04"];

    NSArray *titleTextColors = @[[UIColor colorWithHexString:@"#50c9ba"],
                                  [UIColor colorWithHexString:@"#e8b100"],
                                  [UIColor colorWithHexString:@"#5bcbfc"],
                                  [UIColor colorWithHexString:@"#53e07e"],];
    
    NSArray *titleStrs = @[
                           @"多店选择",
                           @"59约团",
                           @"订单管理",
                           @"我的59"
                           ];
    
    NSArray *detialStrs = @[
                            @"多店个性化展示，更多自由选择",
                            @"超值性价比商品，拼团价更低",
                            @"订单一目了然",
                            @"个人中心，轻松管理账户"
                            ];
    
    NSMutableArray *viewMArr = [[NSMutableArray alloc] initWithCapacity:4];
    
    for (int i = 0; i < [imageNameArr count]; i++) {
        UIImage *topImage = [UIImage imageNamed:imageNameArr[i]];
        NSString *title = titleStrs[i];
        UIColor *color = titleTextColors[i];
        NSString *detialStr = detialStrs[i];
        
        GuidePageView *pageView = [[[NSBundle mainBundle] loadNibNamed:@"GuidePageView"
                                                                 owner:nil
                                                               options:nil] firstObject];
        [pageView.topImageView setImage:topImage];
        pageView.titleLabel.text = title;
        [pageView.titleLabel setTextColor:color];
        pageView.deltialLabel.text = detialStr;
        pageView.entryButton.hidden = (i != (imageNameArr.count -1));
        
        // iphone4 上面不显示按钮，直接左滑进入应用
        if ([UIScreen mainScreen].bounds.size.height < 568){
            
            pageView.entryButton.hidden = YES;
            
            if (i == (imageNameArr.count - 1)) {
                pageView.iphone4GuidImage.hidden = NO;
            }
        }
        
        [viewMArr addObject:pageView];
        
        pageView.entryButton.layer.cornerRadius = 4;
        pageView.entryButton.layer.borderColor = [UIColor colorWithHexString:@"#4bbc69"].CGColor;
        pageView.entryButton.layer.borderWidth = 1;
        
        [pageView.entryButton addTarget:self action:@selector(start59StoreNow) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:pageView];
    }
    
    self.pageViewArr = viewMArr;
    
    [self.pageControl setNumberOfPages:[viewMArr count]];
}

#pragma mark -  Action Methods

- (void)performBlock
{
    [self dismissViewControllerAnimated:NO completion:^{
        if(self.block) {
            self.block();
            self.block = nil;
        }
    }];
}

- (void)start59StoreNow
{
    self.view.userInteractionEnabled = NO;

    [self performBlock];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x < 0) {
        return;
    }
    
    int page = (int)scrollView.contentOffset.x / scrollView.width;
    
    [self.pageControl setCurrentPage:page];
    
    // start APP
    CGFloat padding = 0;
    if (320 == [UIScreen mainScreen].bounds.size.width) {
        padding = 50;
    } else {
        padding = 80;
    }
    if (scrollView.contentOffset.x > (scrollView.width * ([self.pageViewArr count] - 1) + padding)) {
        [self start59StoreNow];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (int)((scrollView.contentOffset.x + 2.0)/scrollView.width);
    
    [self.pageControl setCurrentPage:page];
}

@end
