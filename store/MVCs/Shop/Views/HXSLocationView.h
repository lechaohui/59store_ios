//
//  HXSLocationView.h
//  store
//
//  Created by caixinye on 2017/8/30.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 
 显示定位信息
 
 */
@protocol HXSLocationViewDelegate <NSObject>

- (void)updateLocation;


@end
@interface HXSLocationView : UIView

@property (nonatomic, strong) NSString *locationStr;

@property(nonatomic,weak) id<HXSLocationViewDelegate>delegate;

@end
