//
//  HXSSignInSuccessRemindView.m
//  store
//
//  Created by 格格 on 16/9/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSSignInSuccessRemindView.h"

@interface HXSSignInSuccessRemindView ()

@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;

@end

@implementation HXSSignInSuccessRemindView

+ (instancetype)viewFromXib
{
    HXSSignInSuccessRemindView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    view.layer.cornerRadius = 15;
    view.layer.masksToBounds = YES;
    return view;
}

- (void)showInView:(UIView *)view score:(NSNumber *)score delay:(NSTimeInterval)delay;
{
    /*从view的上方滑入，delay一定时间以后滑出*/
    
    self.scoreLabel.text = [NSString stringWithFormat:@"签到成功！获得%d积分",score.intValue];
    
    CGRect frame = CGRectMake((view.bounds.size.width - self.bounds.size.width)/2, - self.bounds.size.height - 64, self.bounds.size.width, self.bounds.size.height);
    self.frame = frame;
    self.alpha = 0.0;
    [view addSubview:self];
    
    WS(weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.center = CGPointMake(self.center.x, self.center.y + 60);
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf dropOut];
        });
    }];
}

- (void)dropOut
{
    WS(weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.center = CGPointMake(self.center.x, self.center.y - 60);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
