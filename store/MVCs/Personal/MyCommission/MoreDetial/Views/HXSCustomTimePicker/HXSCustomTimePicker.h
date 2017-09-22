//
//  HXSCustomTimePicker.h
//  store
//
//  Created by 格格 on 16/10/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSCustomTimePickerDelegate <NSObject>

- (void)finishSelectYear:(NSNumber *)year momth:(NSNumber *)month;

@end

@interface HXSCustomTimePicker : UIView

@property (nonatomic,weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSNumber * selectYear;
@property (nonatomic, strong) NSNumber * selectMonth;

@property (nonatomic, weak) id<HXSCustomTimePickerDelegate> delegate;

+ (instancetype)customTimePickerWithDelegate:(id)delegate;

- (void)showWithAnimation:(BOOL)animation;

@end
