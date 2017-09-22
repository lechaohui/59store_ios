//
//  HXSSelectView.h
//  store
//
//  Created by caixinye on 2017/9/1.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSSelectView;

typedef NS_ENUM(NSInteger,ButtonClickType){
    ButtonClickTypeNormal = 0,
    ButtonClickTypeUp = 1,
    ButtonClickTypeDown = 2,
};


@protocol HXSSelectViewDelegate <NSObject>

@optional
//选中最上方的按钮的点击事件
- (void)selectTopButton:(HXSSelectView *)selectView withIndex:(NSInteger)index withButtonType:(ButtonClickType )type;


@end

@interface HXSSelectView : UIView


@property (nonatomic, weak) id<HXSSelectViewDelegate>delegate;
//默认选中，默认是第一个
@property (nonatomic, assign) int defaultSelectIndex;

//默认选中项，默认是第一个
@property (nonatomic, assign) int defaultSelectItmeIndex;
//设置可选项数组
@property (nonatomic, copy) NSArray *selectItmeArr;

- (instancetype)initWithFrame:(CGRect)frame withArr:(NSArray *)arr;


@end
