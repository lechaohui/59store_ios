//
//  HXSSearchViewController.m
//  store
//
//  Created by caixinye on 2017/8/28.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSSearchViewController.h"

@interface HXSSearchViewController ()<UISearchBarDelegate>


//搜索框
@property(nonatomic,strong)UISearchBar *searchBar;



@end

@implementation HXSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self createTitleView];


}

- (void)setup{


    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden=YES;
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    

}
//返回statusBar为白色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//标题视图
-(void)createTitleView{

    //背景
    UIView *titleBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    titleBackView.backgroundColor=[UIColor colorWithHexString:@"fde25c"];
    
    [self.view addSubview:titleBackView];
    
    
    //返回按钮
    UIButton *leftBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 25, 30)];
    [leftBut setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftBut addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [titleBackView addSubview:leftBut];
    
    
    
    //搜索框
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(45, 20, SCREEN_WIDTH-90, 44)];
    _searchBar.barStyle=UISearchBarStyleDefault;
    _searchBar.placeholder=@"输入商品名称";
    _searchBar.keyboardType=UIKeyboardTypeDefault;
    _searchBar.barTintColor=[UIColor whiteColor];
    _searchBar.delegate=self;

    //去掉UISearchBar的背景视图
    UIView *sub=[[[_searchBar.subviews firstObject] subviews] firstObject];
    [sub removeFromSuperview];
    //改变输入框颜色
    UITextField *searchTextField =(UITextField *)[[[_searchBar.subviews firstObject] subviews] lastObject];
    //searchTextField.backgroundColor=[UIColor whiteColor];
    searchTextField.font=[UIFont systemFontOfSize:13];
    [titleBackView addSubview:_searchBar];
    [_searchBar becomeFirstResponder];
    



}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //显示取消按钮
    searchBar.showsCancelButton=YES;
    //修改文字
    UIView *subView=[[searchBar subviews] firstObject];
    for(UIView *tmp in subView.subviews)
    {
        if([tmp isKindOfClass:NSClassFromString(@"UINavigationButton")])
        {
            //找到取消按钮
            UIButton *btn=(UIButton *)tmp;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
        }
    }
    return YES;
}
//点击取消时
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
}
#pragma mark － 搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
    
//    SiftViewController *sift=[[SiftViewController alloc]init];
//    sift.pageType=PageTypeSearchResult;
//    //设置搜索关键字
//    sift.searchCondition=searchBar.text;
//    
//    self.hidesBottomBarWhenPushed=NO;
//    [self.navigationController pushViewController:sift animated:YES];
//    self.hidesBottomBarWhenPushed=YES;
}
#pragma mark - targetAction
- (void)back{


    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - 下载搜索热词
-(void)downloadData{


    
    


}
#pragma mark - 刷新UI
-(void)refreshUI{










}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
