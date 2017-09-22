//
//  HXSRootTabModel.h
//  store
//
//  Created by  黎明 on 16/8/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//


@protocol HXSRootTabItemModel
@end

@interface HXSRootTabItemModel : HXBaseJSONModel<NSCoding>

@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) UIImage *normalIcon;
@property (nonatomic ,strong) UIImage *selectIcon;
@property (nonatomic, strong) NSData *animationData;

@end


@interface HXSRootTabModel : HXBaseJSONModel<NSCoding>

@property (nonatomic ,strong) UIColor *selectColor;
@property (nonatomic ,strong) UIColor *normalColor;
@property (nonatomic ,strong) NSNumber *expireTime;
@property (nonatomic ,strong) NSArray<HXSRootTabItemModel> *items;

@end



