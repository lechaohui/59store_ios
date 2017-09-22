//
//  HXSCustomTimePicker.m
//  store
//
//  Created by 格格 on 16/10/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCustomTimePicker.h"
#import "NSDate+Extension.h"

static NSInteger const minYear  = 2016;

@interface HXSCustomTimePicker ()

@property (nonatomic, strong) UIButton *begButton;

@property (nonatomic, strong) NSMutableArray *yearMArr;
@property (nonatomic, strong) NSMutableArray *monthMArr;

@end

@implementation HXSCustomTimePicker

+ (instancetype)customTimePickerWithDelegate:(id)delegate
{
    HXSCustomTimePicker *customTimePicker = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    customTimePicker.delegate = delegate;
    
    return customTimePicker;
}

- (void)showWithAnimation:(BOOL)animation
{
    [self.pickerView selectRow:(self.selectYear.integerValue - minYear) inComponent:0 animated:YES];
    [self.pickerView selectRow:(self.selectMonth.integerValue - 1) inComponent:1 animated:YES];
    
    [[AppDelegate sharedDelegate].window addSubview:self.begButton];
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,276);
    [[AppDelegate sharedDelegate].window addSubview:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 276, SCREEN_WIDTH,276);
    }];
}

- (void)disappear
{
    [UIView animateWithDuration:0.4 animations:^{
        
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,276);
        
    } completion:^(BOOL finished) {
        
        [self.begButton removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (UIButton *)begButton
{
    if (nil == _begButton) {
        
        _begButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_begButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4]];
        [_begButton addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _begButton;
}

#pragma mark - Target/Action

- (IBAction)cancleButtonClicked:(id)sender
{
    [self disappear];
}

- (IBAction)sureButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(finishSelectYear:momth:)]) {
        
        [self.delegate finishSelectYear:self.selectYear momth:self.selectMonth];
    }

    [self disappear];
}


#pragma mark - UIPickerViewDataSource/UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ( 0 == component) {
        
        return self.yearMArr.count;
    }
    
    return self.monthMArr.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0 == component) {
        
        NSNumber *year = [self.yearMArr objectAtIndex:row];
        return [NSString stringWithFormat:@"%zd年",year.integerValue];
    
    } else {
        
        NSNumber *month = [self.monthMArr objectAtIndex:row];
        return [NSString stringWithFormat:@"%zd月",month.integerValue];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component) {
        
        self.selectYear = [self.yearMArr objectAtIndex:row];
        [self.pickerView reloadComponent:1];
        
    } else {
        
        self.selectMonth = [self.monthMArr objectAtIndex:row];
    }
}


#pragma mark - Getter

- (NSNumber *)selectYear
{
    if (nil == _selectYear) {
        
        NSDate *date = [NSDate date];
        _selectYear = @([date year]);
    }
    
    return _selectYear;
}

- (NSNumber *)selectMonth
{
    if (nil == _selectMonth) {
        
        NSDate *date = [NSDate date];
        _selectMonth = @([date month]);
    }
    
    return _selectMonth;
}

- (NSMutableArray *)yearMArr
{
    if (nil == _yearMArr)
    {
        _yearMArr = [NSMutableArray arrayWithCapacity:2];
        
        NSDate *date = [NSDate date];
        NSInteger thisYear = [date year];
        
        for (NSInteger i = minYear; i <= thisYear; i ++) {
            [_yearMArr addObject:@(i)];
        }
    }
    return _yearMArr;
}

- (NSMutableArray *)monthMArr
{
    NSDate *date = [NSDate date];
    NSInteger thisYear = [date year];
    NSInteger thisMonth = [date month];
    
    NSMutableArray *monthArr =  [NSMutableArray arrayWithCapacity:12];
    
    if (thisYear > self.selectYear.integerValue) {
        [monthArr addObjectsFromArray:@[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10),@(11),@(12)]];
    } else {
        
        for (NSInteger i = 1; i <= thisMonth; i++) {
            [monthArr addObject:@(i)];
        }
    
    }
    
    return monthArr;
}

@end
