//
//  NSString+InputLimit.h
//  Pods
//  输入限制扩展
//  Created by J006 on 16/10/7.
//
//

#import <Foundation/Foundation.h>

@interface NSString (InputLimit)

/*
 *限制小数点后位数并且第一位不能是小数点
 */
- (BOOL)checkInputRestrictDigitsWithCounts:(NSInteger)counts;

/*
 *除了中英文字符,限制其他字符出现包括标点符号
 */
- (BOOL)checkInputLimitNoSpecialCharactersWithCounts:(NSInteger)counts;

@end
