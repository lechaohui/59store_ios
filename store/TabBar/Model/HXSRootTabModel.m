//
//  HXSRootTabModel.m
//  store
//
//  Created by  黎明 on 16/8/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSRootTabModel.h"


@implementation HXSRootTabItemModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"normal_icon",    @"normalIcon",
                             @"select_icon",    @"selectIcon",
                             @"animation",      @"animationData", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSData *normalIconData = UIImagePNGRepresentation(self.normalIcon);
    NSData *selectIconData = UIImagePNGRepresentation(self.selectIcon);
    
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:normalIconData forKey:@"normalIcon"];
    [aCoder encodeObject:selectIconData forKey:@"selectIcon"];
    [aCoder encodeObject:self.animationData forKey:@"animationData"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self) {
        NSData *normalIconData = [aDecoder decodeObjectForKey:@"normalIcon"];
        NSData *selectIconData = [aDecoder decodeObjectForKey:@"selectIcon"];
        
        _title = [aDecoder decodeObjectForKey:@"title"];
        _normalIcon = [[UIImage alloc] initWithData:normalIconData scale:1];
        _selectIcon = [[UIImage alloc] initWithData:selectIconData scale:1];
        _animationData = [aDecoder decodeObjectForKey:@"animationData"];
        
    }
    return self;
}

@end

@implementation HXSRootTabModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"select_color",   @"selectColor",
                             @"normal_color",   @"normalColor",
                             @"expire_time",    @"expireTime", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_items forKey:@"items"];
    [aCoder encodeObject:_selectColor forKey:@"selectColor"];
    [aCoder encodeObject:_normalColor forKey:@"normalColor"];
    [aCoder encodeObject:_expireTime forKey:@"expireTime"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self) {
        _items = [aDecoder decodeObjectForKey:@"items"];
        _selectColor = [aDecoder decodeObjectForKey:@"selectColor"];
        _normalColor = [aDecoder decodeObjectForKey:@"normalColor"];
        _expireTime = [aDecoder decodeObjectForKey:@"expireTime"];
    }
    return self;
}

@end


@interface JSONValueTransformer (HXSRootTabItemModel)

@end

@implementation JSONValueTransformer (HXSRootTabItemModel)

#pragma mark - string <-> UIImage

- (UIImage *)UIImageFromNSString:(NSString *)string
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:string]];
    
    UIImage *image = [[UIImage alloc] initWithData:data scale:1.0f];
    
    NSInteger standardWidth = 24;
    CGFloat scale = image.size.width / standardWidth;
    
    image = [[UIImage alloc] initWithData:data scale:scale];
    
    return image;
}

- (id)JSONObjectFromUIImage:(UIImage *)image
{
    return image;
}

#pragma mark - string <-> NSData

- (NSData *)NSDataFromNSString:(NSString *)string
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:string]];
    
    return data;
}

- (id)JSONObjectFromNSData:(NSData *)data
{
    return data;
}


@end

