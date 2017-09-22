//
//  NSString+YFEmoji.h
//  EDU
//
//  Created by MaoKebing on 6/3/15.
//  Copyright (c) 2015 Edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(YFEmoji)

- (NSString *)stringByReplacingEmojiWithString:(NSString *)string;

- (NSString *)stringByRemoveAllEmoji;

@end
