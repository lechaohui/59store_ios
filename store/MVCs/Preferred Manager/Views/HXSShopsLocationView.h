//
//  HXSShopsLocationView.h
//  store
//
//  Created by caixinye on 2017/9/5.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 
 定位信息
 
 */
@protocol HXSShopsLocationViewDelegate <NSObject>

- (void)doUpdateLocation;


@end
@interface HXSShopsLocationView : UIView

@property (nonatomic, strong) NSString *locationStr;

@property(nonatomic,weak) id<HXSShopsLocationViewDelegate>delegate;



@end
