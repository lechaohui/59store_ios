//
//  NSDecimalNumber+HXSStringValue.m
//  store
//
//  Created by 格格 on 16/9/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "NSDecimalNumber+HXSStringValue.h"

@implementation NSDecimalNumber (HXSStringValue)

/**
 *   返回保留两位小数的String （四舍五入）
 */
- (NSString *)twoDecimalPlacesString
{
    return [self stringOfDecimalPlaces:2];
}

/**
 *  返回保留指定小数位数的string （四舍五入）
 *  @prama num : 小数位数
 */
- (NSString *)stringOfDecimalPlaces:(short)num
{
    NSDecimalNumber *resultNum = [self decimalNumberOfDecimalPlaces:num decimalNumber:self];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *zeroStr = num > 0 ? @"." : @"";
    for(int i = 0 ; i < num ; i ++) {
        zeroStr = [zeroStr stringByAppendingString:@"0"];
    }
    NSString *formatStr = [NSString stringWithFormat:@"￥#####0%@",zeroStr];
    [numberFormatter setPositiveFormat:formatStr];
    
    return [numberFormatter stringFromNumber:resultNum];
}


/**
 *  返回保留两位小数的NSDecimalNumber（四舍五入）
 */
- (NSDecimalNumber *)twoDecimalPlacesDecimalNumber
{
    return [self decimalNumberOfDecimalPlaces:2 decimalNumber:self];
}


/**
 * 返回保留指定小数位数的string （四舍五入）
 * @prama num : 小数位数
 */
- (NSDecimalNumber *)decimalNumberOfDecimalPlaces:(short)num
                                    decimalNumber:(NSDecimalNumber *)decimalNumber
{
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                                                                             scale:num
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:YES];
    NSDecimalNumber *resultNum =  [decimalNumber decimalNumberByRoundingAccordingToBehavior:handler];
    
    return resultNum;
}

/**
 * 返回元为单位的string，原来是分
 */
- (NSString *)yuanString
{
    NSDecimalNumber *yuanDecialNum = [self decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    NSDecimalNumber *resultNum = [self decimalNumberOfDecimalPlaces:2 decimalNumber:yuanDecialNum];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setPositiveFormat:@"￥#####0.00;"];
    
    return [numberFormatter stringFromNumber:resultNum];
}

/**
 *返回元为单位的，原来是分
 */
- (NSDecimalNumber *)yuanDecialNum
{
    NSDecimalNumber *yuanDecialNum = [self decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    NSDecimalNumber *resultNum = [self decimalNumberOfDecimalPlaces:2 decimalNumber:yuanDecialNum];
    
    return  [self decimalNumberOfDecimalPlaces:2 decimalNumber:resultNum];
}

@end
