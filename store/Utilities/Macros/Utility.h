//
//  Utility.h
//  59dorm
//
//  Created by ArthurWang on 15/9/7.
//  Copyright (c) 2015年 Huanxiao. All rights reserved.
//

#ifndef _9dorm_Utility_h
#define _9dorm_Utility_h

#if     DEBUG
#       define DLog(fmt, ...) NSLog((@"\n%s \n[Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#       define breakpoint(e)  assert(e)//在调试模式下，如果程序进入不期望进入的分支，assert出来,如果在非调试模式下忽略
#else
#       define DLog(...)
#       define breakpoint(e)
#endif


#define SET_NULLTONIL(TARGET, VAL) if(VAL != [NSNull null]) { TARGET = VAL; } else { TARGET = nil; }

#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)
#define HXD_LINE_WIDTH              ([UIScreen mainScreen].scale >= 2 ? 0.5:1)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DIC_HAS_STRING(dic, key)  ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSString class]])

#define DIC_HAS_NUMBER(dic, key)  ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSNumber class]])

#define DIC_HAS_ARRAY(dic, key)  ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSArray class]])

#define DIC_HAS_DIC(dic, key)  ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSDictionary class]])

#define DIC_HAS_MEM(dic, key, className)  ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[className class]])

#define STRING_HAS_NIL(obj) ((obj == nil) ? @"" : obj) // 为空的话置为@""

#define CHECK_NULL(__X__)  (([(__X__) isEqual: [NSNull null]]) || ((__X__) == nil)) ? ((__X__) = @"") : [NSString stringWithFormat:@"%@", (__X__)]

#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(self) strongSelf = weakSelf;
/** 定义字体大小 */
#define TEXT_FONT(value) [UIFont systemFontOfSize:(value)];
/** 定义粗体 */
#define BOLD_FONT(value) [UIFont boldSystemFontOfSize:(value)]
/** 以iPhone6为基准进行尺寸转换 */
#define TRANSFER_SIZE(value) (SCREEN_WIDTH * value / 375.0) // 375 为iPhone6的宽度
#define TRANSFER_HEIGHT(value) (SCREEN_HEIGHT * value / 667.0) // 667.0 为iPhone6的高度度


#define GLOBAL_NORMAL_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GLOBAL_LOW_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)

#define BEGIN_MAIN_THREAD dispatch_async(dispatch_get_main_queue(), ^(){
#define END_MAIN_THREAD   });

#define BEGIN_BACKGROUND_THREAD dispatch_async(GLOBAL_NORMAL_QUEUE, ^(){
#define END_BACKGROUND_THREAD   });

#define BEGIN_LOW_THREAD dispatch_async(GLOBAL_LOW_QUEUE, ^(){
#define END_LOW_THREAD   });


#endif
