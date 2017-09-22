//
//  HXSTableViewNoDataView.h
//  store
//
//  Created by 格格 on 16/10/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSTableViewNoDataView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

+ (instancetype)tableViewNoDataView;

@end
