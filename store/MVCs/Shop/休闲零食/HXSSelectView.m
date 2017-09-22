//
//  HXSSelectView.m
//  store
//
//  Created by caixinye on 2017/9/1.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSSelectView.h"
#import "UIButton+ImageTitleStyle.h"

static char *const btnKey = "btnKey";

@interface HXSSelectView (){
    BOOL show;
}


@end
@implementation HXSSelectView


- (instancetype)initWithFrame:(CGRect)frame withArr:(NSArray *)arr{
    self = [super initWithFrame:frame];
    if (self) {
        //        _selectItmeArr = arr;
        [self initUI];
    }
    return self;
}
- (void)initUI{


    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mainView];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(40);
        make.top.right.left.mas_equalTo(self);
        
        
    }];
    
    //topLine
    UIView *topLine = [UIView new];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:topLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(mainView);
        make.top.mas_equalTo(mainView.mas_bottom);
        
    }];
    
    NSArray *titleArr = @[@"销量",@"新品",@"价格"];
    for ( int i = 0; i<titleArr.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titleArr[i] forState:UIControlStateNormal ];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithR:0 G:142 B:236 A:1] forState:UIControlStateSelected];
        [mainView addSubview:button];
        button.tag = 100+i;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainView).offset(SCREEN_WIDTH/3*i);
            make.top.bottom.equalTo(mainView);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
        }];
        if (i == _defaultSelectIndex) {
            button.selected = YES;
        }
        if (i == 2) {
            
            [button setImage:[UIImage imageNamed:@"jiagenormImage"] forState:UIControlStateNormal];
            [button setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
            objc_setAssociatedObject(button, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
            
        }
        
    }
    
}

- (void)selectClick:(UIButton *)btn{


    for (int i = 0; i<3 ;i++) {
        UIButton *button = [self viewWithTag:i+100];
        button.selected = NO;
    }
    btn.selected = YES;
    [self toggleViewWith:nil];
    
    ButtonClickType type = ButtonClickTypeNormal;
    if (btn.tag == 102) {
        NSString *flag = objc_getAssociatedObject(btn, btnKey);
        if ([flag isEqualToString:@"1"]) {
            [btn setImage:[UIImage imageNamed:@"jiageupImage"] forState:UIControlStateNormal];
            objc_setAssociatedObject(btn, btnKey, @"2", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeUp;
        }else if ([flag isEqualToString:@"2"]){
            [btn setImage:[UIImage imageNamed:@"jiagedownImage"] forState:UIControlStateNormal];
            objc_setAssociatedObject(btn, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeDown;
        }
        
    }else{
    
    
        UIButton *button = [self viewWithTag:102];
        [button setImage:[UIImage imageNamed:@"jiagenormImage"] forState:UIControlStateNormal];
        objc_setAssociatedObject(button, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
        type = ButtonClickTypeNormal;
        
    
    }
    
    if ([self.delegate respondsToSelector:@selector(selectTopButton:withIndex:withButtonType:)]) {
        [self.delegate selectTopButton:self withIndex:btn.tag withButtonType:type];
    }


}
- (void)toggleViewWith:(UIButton *)btn{

    
    if (_defaultSelectItmeIndex != 0) {
        btn.selected = YES;
    }else{
        btn.selected = NO;
    }
    


}
-(void)setSelectItmeArr:(NSArray *)selectItmeArr{
    
    _selectItmeArr = selectItmeArr;
    _defaultSelectIndex = 0;
    UIButton *button = [self viewWithTag:102];
    [button setImage:[UIImage imageNamed:@"jiagenormImage"] forState:UIControlStateNormal];
    objc_setAssociatedObject(button, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
    button.selected = NO;
    for (int i = 0; i<3 ;i++) {
        UIButton *button = [self viewWithTag:i+100];
        if (i == 0) {
            button.selected = YES;
            continue;
        }
        if (i == 2) {
            
            continue;
        }
        
        button.selected = NO;
    }


}
@end
