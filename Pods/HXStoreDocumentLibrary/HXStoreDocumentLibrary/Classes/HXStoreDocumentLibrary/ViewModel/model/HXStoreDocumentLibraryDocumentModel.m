//
//  HXStoreDocumentLibraryDocumentModel.m
//  HXStoreDocumentLibrary_Example
//  
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryDocumentModel.h"

@implementation HXStoreDocumentLibraryDocumentModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"docIdStr",                   @"doc_id",
                                 @"authorIdStr",                @"author_id",
                                 @"docProvisionNameStr",        @"doc_provision_name",
                                 @"categoryImageStr",           @"category_image",
                                 @"docTitleStr",                @"doc_title",
                                 @"isOnNum",                    @"is_on",
                                 @"isTopNum",                   @"is_top",
                                 @"orgIdStr",                   @"org_id",
                                 @"firstCategoryIdNum",         @"first_category_id",
                                 @"secondCategoryIdNum",        @"second_category_id",
                                 @"sourceSizeStr",              @"source_size",
                                 @"typeNum",                    @"type",
                                 @"priceDecNum",                @"price",
                                 @"readCountNum",               @"read_count",
                                 @"starCountNum",               @"star_count",
                                 @"scoreCountNum",              @"score_count",
                                 @"downloadCountNum",           @"download_count",
                                 @"scoreAverageNum",            @"score_average",
                                 @"urlStr",                     @"url",
                                 @"createTimeStr",              @"create_time",
                                 @"isFavorNum",                 @"is_favor",
                                 @"createTimestampStr",         @"create_timestamp",
                                 @"docNum",                     @"doc_num",
                                 @"sourceMd5Str",               @"source_md5",
                                 @"pdfMd5Str",                  @"pdf_md5",
                                 @"sourceSizeNum",              @"source_size",
                                 @"pageReadNum",                @"page_num",
                                 @"docSuffixStr",               @"doc_suffix",
                                 @"hasRightsNum",               @"has_rights",
                                 @"verifyStatusNum",            @"verify_status",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return  [[HXStoreDocumentLibraryDocumentModel alloc] initWithDictionary:object error:nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.docIdStr forKey:@"docIdStr"];
    [aCoder encodeObject:self.authorIdStr forKey:@"authorIdStr"];
    [aCoder encodeObject:self.isOnNum forKey:@"isOnNum"];
    [aCoder encodeObject:self.archiveDocPathURL forKey:@"archiveDocPathURL"];
    [aCoder encodeObject:self.docProvisionNameStr forKey:@"docProvisionNameStr"];
    [aCoder encodeObject:self.docTitleStr forKey:@"docTitleStr"];
    [aCoder encodeObject:self.orgIdStr forKey:@"orgIdStr"];
    [aCoder encodeObject:self.isTopNum forKey:@"isTopNum"];
    [aCoder encodeObject:self.firstCategoryIdNum forKey:@"firstCategoryIdNum"];
    [aCoder encodeObject:self.secondCategoryIdNum forKey:@"secondCategoryIdNum"];
    [aCoder encodeObject:self.sourceSizeStr forKey:@"sourceSizeStr"];
    [aCoder encodeObject:self.typeNum forKey:@"typeNum"];
    [aCoder encodeObject:self.priceDecNum forKey:@"priceNum"];
    [aCoder encodeObject:self.readCountNum forKey:@"readCountNum"];
    [aCoder encodeObject:self.starCountNum forKey:@"starCountNum"];
    [aCoder encodeObject:self.scoreCountNum forKey:@"scoreCountNum"];
    [aCoder encodeObject:self.downloadCountNum forKey:@"downloadCountNum"];
    [aCoder encodeObject:self.scoreAverageNum forKey:@"scoreAverageNum"];
    [aCoder encodeObject:self.urlStr forKey:@"urlStr"];
    [aCoder encodeObject:self.createTimeStr forKey:@"createTimeStr"];
    [aCoder encodeObject:self.isFavorNum forKey:@"isFavorNum"];
    [aCoder encodeObject:self.createTimestampStr forKey:@"createTimestampStr"];
    [aCoder encodeObject:self.pdfNameStr forKey:@"pdfNameStr"];
    [aCoder encodeObject:self.docNum forKey:@"docNum"];
    [aCoder encodeObject:self.sourceMd5Str forKey:@"sourceMd5Str"];
    [aCoder encodeObject:self.pdfMd5Str forKey:@"pdfMd5Str"];
    [aCoder encodeObject:self.sourceSizeNum forKey:@"sourceSizeNum"];
    [aCoder encodeObject:self.pageReadNum forKey:@"pageReadNum"];
    [aCoder encodeObject:self.archiveDocPathStr forKey:@"archiveDocPathStr"];
    [aCoder encodeObject:self.docSuffixStr forKey:@"docSuffixStr"];
    [aCoder encodeObject:self.hasRightsNum forKey:@"hasRightsNum"];
    [aCoder encodeObject:self.verifyStatusNum forKey:@"verifyStatusNum"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super init];
    if (self) {
        _docIdStr                   = [aDecoder decodeObjectForKey:@"docIdStr"];
        _authorIdStr                = [aDecoder decodeObjectForKey:@"authorIdStr"];
        _isOnNum                    = [aDecoder decodeObjectForKey:@"isOnNum"];
        _archiveDocPathURL          = [aDecoder decodeObjectForKey:@"archiveDocPathURL"];
        _docProvisionNameStr        = [aDecoder decodeObjectForKey:@"docProvisionNameStr"];
        _docTitleStr                = [aDecoder decodeObjectForKey:@"docTitleStr"];
        _orgIdStr                   = [aDecoder decodeObjectForKey:@"orgIdStr"];
        _isTopNum                   = [aDecoder decodeObjectForKey:@"isTopNum"];
        _firstCategoryIdNum         = [aDecoder decodeObjectForKey:@"firstCategoryIdNum"];
        _secondCategoryIdNum        = [aDecoder decodeObjectForKey:@"secondCategoryIdNum"];
        _sourceSizeStr              = [aDecoder decodeObjectForKey:@"sourceSizeStr"];
        _typeNum                    = [aDecoder decodeObjectForKey:@"typeNum"];
        _priceDecNum                = [aDecoder decodeObjectForKey:@"priceNum"];
        _readCountNum               = [aDecoder decodeObjectForKey:@"readCountNum"];
        _starCountNum               = [aDecoder decodeObjectForKey:@"starCountNum"];
        _scoreCountNum              = [aDecoder decodeObjectForKey:@"scoreCountNum"];
        _downloadCountNum           = [aDecoder decodeObjectForKey:@"downloadCountNum"];
        _scoreAverageNum            = [aDecoder decodeObjectForKey:@"scoreAverageNum"];
        _urlStr                     = [aDecoder decodeObjectForKey:@"urlStr"];
        _createTimeStr              = [aDecoder decodeObjectForKey:@"createTimeStr"];
        _isFavorNum                 = [aDecoder decodeObjectForKey:@"isFavorNum"];
        _createTimestampStr         = [aDecoder decodeObjectForKey:@"createTimestampStr"];
        _pdfNameStr                 = [aDecoder decodeObjectForKey:@"pdfNameStr"];
        _docNum                     = [aDecoder decodeObjectForKey:@"docNum"];
        _sourceMd5Str               = [aDecoder decodeObjectForKey:@"sourceMd5Str"];
        _pdfMd5Str                  = [aDecoder decodeObjectForKey:@"pdfMd5Str"];
        _sourceSizeNum              = [aDecoder decodeObjectForKey:@"sourceSizeNum"];
        _pageReadNum                = [aDecoder decodeObjectForKey:@"pageReadNum"];
        _archiveDocPathStr          = [aDecoder decodeObjectForKey:@"archiveDocPathStr"];
        _docSuffixStr               = [aDecoder decodeObjectForKey:@"docSuffixStr"];
        _hasRightsNum               = [aDecoder decodeObjectForKey:@"hasRightsNum"];
        _verifyStatusNum            = [aDecoder decodeObjectForKey:@"verifyStatusNum"];        
    }
    return self;
}

- (void)setPriceDecNumWithNSNumber:(NSNumber *)number
{
    _priceDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setPriceDecNumWithNSString:(NSString *)string
{
    _priceDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

@end
