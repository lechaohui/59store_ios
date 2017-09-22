//
//  NSDecimalNumber+HXSStringValue.h
//  store
//
//  Created by 格格 on 16/9/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (HXSStringValue)

/**
 *   返回保留两位小数的String （四舍五入）
 */
- (NSString *)twoDecimalPlacesString;

/**
 *  返回保留指定小数位数的string （四舍五入）
 *  @prama num : 小数位数
 */
- (NSString *)stringOfDecimalPlaces:(short)num;

/**
 *  返回保留两位小数的NSDecimalNumber（四舍五入）
 */
- (NSDecimalNumber *)twoDecimalPlacesDecimalNumber;

/**
 * 返回保留指定小数位数的NSDecimalNumber （四舍五入）
 * @prama num : 小数位数
 */
- (NSDecimalNumber *)decimalNumberOfDecimalPlaces:(short)num
                                    decimalNumber:(NSDecimalNumber *)decimalNumber;

/**
 * 返回元为单位的string，原来是分
 */
- (NSString *)yuanString;

/**
 *返回元为单位的，原来是分
 */
- (NSDecimalNumber *)yuanDecialNum;

@end
