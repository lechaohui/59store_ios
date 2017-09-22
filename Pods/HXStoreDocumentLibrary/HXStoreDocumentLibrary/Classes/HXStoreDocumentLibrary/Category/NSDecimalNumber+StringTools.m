//
//  NSDecimalNumber+StringTools.m
//  Pods
//
//  Created by J006 on 16/10/17.
//
//

#import "NSDecimalNumber+StringTools.h"

@implementation NSDecimalNumber (StringTools)

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

@end
