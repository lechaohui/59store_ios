//
//  HXSOpenShopHeaderCenterView.m
//  store
//
//  Created by caixinye on 2017/8/27.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSOpenShopHeaderCenterView.h"
#import "UIButton+AFNetworking.h"
#import "HXSMessageCenterViewController.h"
#import "HXSOpenShopViewController.h"
@interface HXSOpenShopHeaderCenterView(){


    UIView *_bottomSepratorLine;

}

- (IBAction)setbutAction:(UIButton *)sender;
- (IBAction)msgAction:(UIButton *)sender;

@end

@implementation HXSOpenShopHeaderCenterView

- (void)awakeFromNib{

   [super awakeFromNib];
    _headerImgView.layer.masksToBounds = YES;
    _headerImgView.layer.cornerRadius = 30;
    _headerImgView.layer.borderColor = [UIColor colorWithRGBHex:0x6BCBFC].CGColor;
    
    if (_bottomSepratorLine == nil) {
        _bottomSepratorLine = [[UIView alloc] init];
        _bottomSepratorLine.backgroundColor = [UIColor colorWithRGBHex:0xE1E2E3];
        [self addSubview:_bottomSepratorLine];
    }
    
     [self refreshInfo];
    




}

- (void)refreshInfo{

 // 用户已经登录
    if([HXSUserAccount currentAccount].isLogin){
    
        HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
        //HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
        NSString * url = [basicInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_headerImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_headsculpture"]];

        _loginNameLb.text = [NSString stringWithFormat:@"%@", basicInfo.nickName ? basicInfo.nickName : @""];
    
      //根据状态来改变申请成为店长的状态
        _applyLb.text = [NSString stringWithFormat:@"申请成为店长"];
    
    
    }else{
        
        _loginNameLb.text = @"登陆/注册";
        _applyLb.text = [NSString stringWithFormat:@"申请成为店长"];
        
    }
    
}
+ (id)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _bottomSepratorLine.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}


- (IBAction)setbutAction:(UIButton *)sender {

    
    


}

- (IBAction)msgAction:(UIButton *)sender {

    UIViewController *ctr = [self viewController];
    if ([ctr isKindOfClass:[HXSOpenShopViewController class]]) {
        
        HXSMessageCenterViewController *msg = [[HXSMessageCenterViewController alloc] init];
        ctr.hidesBottomBarWhenPushed = YES;
        [ctr.navigationController pushViewController:msg animated:YES];
        ctr.hidesBottomBarWhenPushed = NO;
        
    }
}
/**
 *  返回当前视图的控制器
 */
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
