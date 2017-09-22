//
//  HXSSignInSuccessRemindView.h
//  store
//
//  Created by 格格 on 16/9/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSSignInSuccessRemindView : UIView

+ (instancetype)viewFromXib;

- (void)showInView:(UIView *)view score:(NSNumber *)score delay:(NSTimeInterval)delay;

@end
