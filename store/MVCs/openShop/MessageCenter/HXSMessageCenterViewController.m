//
//  HXSMessageCenterViewController.m
//  store
//
//  Created by caixinye on 2017/8/27.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSMessageCenterViewController.h"
#import "SegmentControl.h"



@interface HXSMessageCenterViewController ()<SegmentControlDelegate>

@property (nonatomic, strong) UITableView *noticeTabelView;
@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) SegmentControl *segmentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;




@end

@implementation HXSMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self initialSubviews];
    
    
}
- (void)setup{
 self.navigationItem.title = @"消息中心";
    

    
    
}
- (void)initialSubviews {
    
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.container];
    self.segmentView.scrollView = self.scrollView;
    
    [self.container addSubview:self.messageTableView];
    [self.container addSubview:self.noticeTabelView];
    
    WS(ws);
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view);
        make.left.right.equalTo(ws.view);
        make.height.mas_equalTo(52);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(ws.segmentView.mas_bottom);
    }];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.scrollView);
        make.height.equalTo(ws.scrollView);
    }];
    
    // 公告
    [self.noticeTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(ws.container);
        make.width.mas_equalTo(ws.view);
    }];
    // 消息
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(ws.container);
        make.left.equalTo(ws.noticeTabelView.mas_right);
        make.width.mas_equalTo(ws.view);
        make.right.equalTo(ws.container);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
