//
//  HXSCommissionMoreSectionHeader.m
//  store
//
//  Created by 格格 on 16/10/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommissionMoreSectionHeader.h"

#import "HXSCustomTimePicker.h"
#import "NSDate+Extension.h"

@interface HXSCommissionMoreSectionHeader()<HXSCustomTimePickerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *yearLabel;
@property (nonatomic, weak) IBOutlet UILabel *monthsLabel;
@property (nonatomic, weak) IBOutlet UILabel *incomeAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *spendingAmountLabel;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@implementation HXSCommissionMoreSectionHeader

+ (instancetype)sectionHeader
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

#pragma mark - Target/Action

- (IBAction)timeSelectButtonClickde:(id)sender
{
    HXSCustomTimePicker *customTimePicker = [HXSCustomTimePicker customTimePickerWithDelegate:self];
    customTimePicker.selectMonth = @([self.startDate month]);
    customTimePicker.selectYear = @([self.startDate year]);
    [customTimePicker showWithAnimation:YES];
}


#pragma mark - Private Method

- (void)refreshCommissionInfo
{
    self.incomeAmountLabel.text = [NSString stringWithFormat:@"+%.2f",self.commission.incomeStr.floatValue];
    
    if (0.00 > [self.commission.outlayStr floatValue]) {
        self.spendingAmountLabel.text = [NSString stringWithFormat:@"%.2f",self.commission.outlayStr.floatValue];
    } else {
        self.spendingAmountLabel.text = [NSString stringWithFormat:@"-%.2f",self.commission.outlayStr.floatValue];
    }
    
    [self refreshYear:@([self.startDate year]) momth:@([self.startDate month])];
}

- (void)refreshYear:(NSNumber *)year momth:(NSNumber *)month
{
    self.yearLabel.text = [NSString stringWithFormat:@"%zd年",year.integerValue];
    self.monthsLabel.text = [NSString stringWithFormat:@"%zd月",month.integerValue];
}


#pragma mark - HXSCustomTimePickerDelegate

- (void)finishSelectYear:(NSNumber *)year momth:(NSNumber *)month
{
    [self refreshYear:year momth:month];
    
    NSString *dataStr = [NSString stringWithFormat:@"%zd-%zd-01 00:00:00",year.integerValue,month.integerValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *tempDate = [dateFormatter dateFromString:dataStr];
    
    self.startDate = [tempDate begindayOfMonth];
    self.endDate = [tempDate lastdayOfMonth];
    
    if ([self.delegate respondsToSelector:@selector(selectTimeChange)]) {
        [self.delegate selectTimeChange];
    }
    
}


#pragma mark - Setter

- (void)setCommission:(HXSCommission *)commission
{
    _commission = commission;
    
    [self refreshCommissionInfo];
}


#pragma mark - Getter

- (NSDate *)startDate
{
    if (nil == _startDate) {
        
        NSDate *today = [NSDate date];
        
        return [today begindayOfMonth];
    }
    
    return _startDate;
}

- (NSDate *)endDate
{
    if (nil == _endDate) {
        
        NSDate *today = [NSDate date];
        
        return [today lastdayOfMonth];
    }
    
    return _endDate;
}

- (NSNumber *)startDateTimestamp
{
    return @((long long)(self.startDate.timeIntervalSince1970));
}

- (NSNumber *)endDateTimestamp
{
    long long end = self.endDate.timeIntervalSince1970;
    
    end += 86400; // 月底最后一天，计算到24点
    
    return [NSNumber numberWithLongLong:end];
}

@end
