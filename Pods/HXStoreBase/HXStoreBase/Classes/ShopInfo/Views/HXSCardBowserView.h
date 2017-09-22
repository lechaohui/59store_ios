//
//  HXSAvatarBrowser.h
//  store
//
//  Created by  黎明 on 16/7/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  身份证图片查看View

#import <UIKit/UIKit.h>

@interface HXSCardBowserView : UIView
{
    CGRect oldframe;
}

@property (nonatomic, copy) void (^reTakePhotoBlock)();

- (void)showImage:(UIImageView *)avatarImageView;

@end
