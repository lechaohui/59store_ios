//
//  HXPlistReader.m
//  store
//
//  Created by chsasaw on 14-10-14.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXPlistReader.h"

@interface HXPlistReader()

@property(nonatomic, strong) NSDictionary *attributes;

@end

@implementation HXPlistReader

@synthesize attributes;

+(HXPlistReader *)plistReaderForFile:(NSString *)file {
    HXPlistReader *reader = [[HXPlistReader alloc] init];
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:file ofType:@"plist"];
    if (fullPath == nil)
        return nil;
    reader.attributes = [NSDictionary dictionaryWithContentsOfFile:fullPath];
    return reader;
}

-(NSArray *)allKeys {
    NSArray *keys = [self.attributes allKeys];
    return [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

-(NSString *)stringValueForKey:(NSString *)key {
    return [self.attributes objectForKey:key];
}

-(NSArray *)arrayValueForKey:(NSString *)key {
    return [self.attributes objectForKey:key];
}

-(NSDictionary *)dictValueForKey:(NSString *)key {
    return [self.attributes objectForKey:key];
}

-(BOOL)boolValueForKey:(NSString *)key {
    id value = [self.attributes objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
        return [(NSNumber *)value boolValue];
    else if ([value isKindOfClass:[NSString class]]) {
        NSString *str = [(NSString *)value lowercaseString];
        if ([str isEqualToString:@"yes"] || [str isEqualToString:@"true"])
            return YES;
        else
            return NO;
    } else
        return NO;
}

-(NSInteger)intValueForKey:(NSString *)key {
    id value = [self.attributes objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
        return [(NSNumber *)value intValue];
    else if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value intValue];
    } else
        return 0;
}

-(float)floatValueForKey:(NSString *)key {
    id value = [self.attributes objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
        return [(NSNumber *)value floatValue];
    else if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value floatValue];
    } else
        return 0;
}

-(NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    NSString *value = [self.attributes objectForKey:key];
    if (value == nil)
        return defaultValue;
    else
        return value;
}

-(NSArray *)arrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue {
    NSArray *value = [self.attributes objectForKey:key];
    if (value == nil)
        return defaultValue;
    else
        return value;
}

-(NSDictionary *)dictValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue {
    NSDictionary *value = [self.attributes objectForKey:key];
    if (value == nil)
        return defaultValue;
    else
        return value;
}

-(BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    id value = [self.attributes objectForKey:key];
    if (value == nil)
        return defaultValue;
    if ([value isKindOfClass:[NSNumber class]])
        return [(NSNumber *)value boolValue];
    else if ([value isKindOfClass:[NSString class]]) {
        NSString *str = [(NSString *)value lowercaseString];
        if ([str isEqualToString:@"yes"] || [str isEqualToString:@"true"])
            return YES;
        else
            return NO;
    } else
        return NO;
}

-(NSInteger)intValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    id value = [self.attributes objectForKey:key];
    if (value == nil)
        return defaultValue;
    if ([value isKindOfClass:[NSNumber class]])
        return [(NSNumber *)value intValue];
    else if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value intValue];
    } else
        return 0;
}

-(float)floatValueForKey:(NSString *)key defaultValue:(float)defaultValue {
    id value = [self.attributes objectForKey:key];
    if (value == nil)
        return defaultValue;
    if ([value isKindOfClass:[NSNumber class]])
        return [(NSNumber *)value floatValue];
    else if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value floatValue];
    } else
        return 0;
}

@end
