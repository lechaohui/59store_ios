//
//  HXSMessageItem.m
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMessageItem.h"

#define VIWE_WIDTH (SCREEN_WIDTH - kMarpping * 2)
#define DETIAL_TEXT_FONT 14

static CGFloat const kCellBaseHeight = 46.0; // cell只显示标题时的高度
static CGFloat const kSpaceHeight    = 10.0; // 每个空间之间的间距
static CGFloat const kSpaceBotton    = 20.0; // 距离底部空格
static CGFloat const kMarpping       = 15.0; // 每个控件距离边界的距离

@implementation HXSMessageItem

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"message_id"     , @"messageIdStr",
                             @"content"        , @"contentStr",
                             @"create_time"    , @"createTimeStr",
                             @"status"         , @"statusStr",
                             @"type"           , @"typeStr",
                             @"title"          , @"titleStr",
                             @"icon"           , @"iconStr",
                             @"cate_id"        , @"cateIdStr",
                             @"link"           , @"linkStr",
                             @"image"          , @"imageStr",
                             @"operation"      , @"operationStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}


#pragma mark - Getter

- (CGFloat)aspectRatio
{
    // 消息列表页，图片固定630*200的宽高比例 630/200 = 3.15
    return 3.15;
}

- (CGFloat)imageHeight
{
    if(0 < self.imageStr.length) {
        return VIWE_WIDTH / (self.aspectRatio);
    } else {
        return 0;
    }
}

- (CGFloat)contentTextHeight
{
    if( 0 < self.contentStr.length ) {
        UIFont *textFont = [UIFont systemFontOfSize:DETIAL_TEXT_FONT];
        CGSize textSize = CGSizeMake(VIWE_WIDTH, CGFLOAT_MAX);
        NSDictionary *textDic = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName,nil];
        CGSize autoSize = [self.contentStr boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                attributes:textDic context:nil].size;
        return ceilf(autoSize.height);
    } else {
        return 0;
    }
}

- (CGFloat)cellHeight
{
    CGFloat totalHeight = kCellBaseHeight;
    
    if(self.imageStr.length > 0 && self.self.contentStr.length > 0 )
    {
        totalHeight = totalHeight + self.imageHeight + kSpaceHeight + self.contentTextHeight + kSpaceBotton;
    } else if (self.imageStr.length <= 0 || self.contentStr.length <= 0 ) {
        CGFloat tempHeight = self.imageStr.length <= 0 ? self.contentTextHeight : self.imageHeight;
        totalHeight = totalHeight + tempHeight + kSpaceBotton;
    } else {
        // do nothing
    }
    
    return totalHeight;
}

@end
