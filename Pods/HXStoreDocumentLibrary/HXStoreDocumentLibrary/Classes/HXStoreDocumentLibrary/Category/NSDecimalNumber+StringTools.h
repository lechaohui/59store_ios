//
//  NSDecimalNumber+StringTools.h
//  Pods
//
//  Created by J006 on 16/10/17.
//
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (StringTools)

/**
 *  返回保留两位小数的NSDecimalNumber（四舍五入）
 */
- (NSDecimalNumber *)twoDecimalPlacesDecimalNumber;

/**
 * 返回保留指定小数位数的string （四舍五入）
 * @prama num : 小数位数
 */
- (NSDecimalNumber *)decimalNumberOfDecimalPlaces:(short)num
                                    decimalNumber:(NSDecimalNumber *)decimalNumber;

@end
