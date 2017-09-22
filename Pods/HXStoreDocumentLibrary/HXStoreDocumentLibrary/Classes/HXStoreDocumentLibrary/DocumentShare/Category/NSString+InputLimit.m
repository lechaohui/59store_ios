//
//  NSString+InputLimit.m
//  Pods
//
//  Created by J006 on 16/10/7.
//
//

#import "NSString+InputLimit.h"

@implementation NSString (InputLimit)

- (BOOL)checkInputRestrictDigitsWithCounts:(NSInteger)counts
{
    if(self == nil) {
        return NO;
    }
    NSArray *sep = [self componentsSeparatedByString:@"."];
    if([self isEqualToString:@"."]) {
        return NO;
    }
    if([sep count] == 2)//一个小数点
    {
        NSString *sepStr = [NSString stringWithFormat:@"%@",[sep objectAtIndex:1]];
        if (!([sepStr length] > counts)) {
            if ([sepStr length] == counts
                && [self isEqualToString:@"."]) {
                return NO;
            }
            return YES;
        } else{
            return NO;
        }
    } else if([sep count] == 1){ //无小数点
        return YES;
    } else { // 多个小数点
        return NO;
    }
}

- (BOOL)checkInputLimitNoSpecialCharactersWithCounts:(NSInteger)counts
{
    if(self == nil) {
        return NO;
    }
    
    if(self.length > counts) {
        return NO;
    }
    
    if ([self isEqualToString:@"➋"]
        || [self isEqualToString:@"➌"]
        || [self isEqualToString:@"➍"]
        || [self isEqualToString:@"➎"]
        || [self isEqualToString:@"➏"]
        || [self isEqualToString:@"➐"]
        || [self isEqualToString:@"➑"]
        || [self isEqualToString:@"➒"]
        || [self isEqualToString:@""]) {
        return YES;
        
    }
    
    NSString *myRegex = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    BOOL valid = [myTest evaluateWithObject:self];
    
    return valid;
}

@end
