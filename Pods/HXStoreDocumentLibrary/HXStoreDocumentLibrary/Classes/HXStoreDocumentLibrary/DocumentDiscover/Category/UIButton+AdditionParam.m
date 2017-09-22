//
//  UIButton+AdditionParam.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/10.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "UIButton+AdditionParam.h"

@implementation UIButton (AdditionParam)

static char UIB_SECTIONINDEX_KEY;

@dynamic sectionIndex;

- (NSInteger)sectionIndex
{
    return [objc_getAssociatedObject(self, &UIB_SECTIONINDEX_KEY) integerValue];
}

- (void)setSectionIndex:(NSInteger)sectionIndex
{
    objc_setAssociatedObject(self, &UIB_SECTIONINDEX_KEY, [NSNumber numberWithInteger:sectionIndex], OBJC_ASSOCIATION_ASSIGN);
}


@end
