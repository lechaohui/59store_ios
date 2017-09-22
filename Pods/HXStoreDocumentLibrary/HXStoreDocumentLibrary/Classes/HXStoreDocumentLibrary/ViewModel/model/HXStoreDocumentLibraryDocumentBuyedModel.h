//
//  HXStoreDocumentLibraryDocumentBuyedModel.h
//  Pods
//
//  Created by J006 on 16/9/29.
//
//

#import <Foundation/Foundation.h>
#import "HXBaseJSONModel.h"

@interface HXStoreDocumentLibraryDocumentBuyedModel : HXBaseJSONModel

/**s`doc_id`: 123123，'文档id', */
@property (nonatomic, strong) NSString          *docIdStr;
/**`doc_title` : 1231231，'文档标题' */
@property (nonatomic, strong) NSString          *docTitleStr;
/**`price` :100,'文档价格' */
@property (nonatomic, strong) NSDecimalNumber   *priceDecNum;

@property (nonatomic, strong) NSString          *docSuffixStr;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
