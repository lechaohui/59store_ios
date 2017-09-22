//
//  HXSLoginMainViewController.m
//  Pods
//
//  Created by caixinye on 2017/9/16.
//
//

#import "HXSLoginMainViewController.h"
#import "SectionChooseView.h"
#import "UIColor+UdeskSDK.h"

@interface HXSLoginMainViewController ()<UIScrollViewDelegate,SectionChooseVCDelegate>

//底部滚动ScrollView
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property(nonatomic,strong)SectionChooseView *sectionChooseView;


@end

@implementation HXSLoginMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 首次进入加载第一个界面通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFirstVC) name:@"ABC" object:nil];
    
    //添加所有子控制器
    [self setupChildViewController];
    
    //初始化UIScrollView
    [self setupUIScrollView];
    
    
}



- (void)setupChildViewController{

    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePathStr = [bundle pathForResource:@"HXStoreLogin" ofType:@"bundle"];
    if (0 < [bundlePathStr length]) {
        bundle = [NSBundle bundleWithPath:bundlePathStr];
    }
    
   // UINavigationController * nav = [[UIStoryboard storyboardWithName:@"Login" bundle:bundle] instantiateViewControllerWithIdentifier:@"HXSLoginViewControllerNavigation"];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:bundle];
    UIViewController *LoginVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSLoginViewController"];
    //HXSPhoneLoginViewController
    UIViewController *RegisterVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSPhoneRegisterViewController"];
    [self addChildViewController:LoginVC];
    [self addChildViewController:RegisterVC];
    
    

}
- (void)setupUIScrollView{

    // 创建底部滚动视图
    self.contentScrollView = [[UIScrollView alloc] init];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    _contentScrollView.frame = CGRectMake(0, 0, screenWidth,screenHeight );
    _contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, 0);
    _contentScrollView.backgroundColor = [UIColor clearColor];
    // 开启分页
    _contentScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _contentScrollView.bounces = NO;
    // 隐藏水平滚动条
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _contentScrollView.delegate = self;
    [self.view addSubview:_contentScrollView];
    
    self.sectionChooseView = [[SectionChooseView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 44) titleArray:@[@"登陆", @"注册"]];
    self.sectionChooseView.selectIndex = 0;
    self.sectionChooseView.delegate = self;
    self.sectionChooseView.normalBackgroundColor = [UIColor whiteColor];
    self.sectionChooseView.selectBackgroundColor = [UIColor colorWithHexString:@"fde25c"];
    self.sectionChooseView.titleNormalColor = [UIColor colorWithHexString:@"fde25c"];
    self.sectionChooseView.titleSelectColor = [UIColor whiteColor];
    self.sectionChooseView.normalTitleFont = 16;
    self.sectionChooseView.selectTitleFont = 16;
    [self.view addSubview:self.sectionChooseView];
    

}
- (void)showFirstVC {
    
    [self showVc:0];
}
#pragma mark -显示控制器的view
/**
 *  显示控制器的view
 *
 *  @param index 选择第几个
 *
 */
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.contentScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark -SMCustomSegmentDelegate

- (void)SectionSelectIndex:(NSInteger)selectIndex {
    
    //NSLog(@"---------%ld",(long)selectIndex);
    
    // 1 计算滚动的位置
    CGFloat offsetX = selectIndex * self.view.frame.size.width;
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:selectIndex];
    
}
#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
    
    // 2.把对应的标题选中
    self.sectionChooseView.selectIndex = index;
    
    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
