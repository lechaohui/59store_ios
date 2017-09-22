//
//  HXSInfoInputCell.h
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSInfoInputCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *keyLabel;
@property (nonatomic, weak) IBOutlet UITextField *valueTextField;

+ (instancetype)infoInputCell;

@end
