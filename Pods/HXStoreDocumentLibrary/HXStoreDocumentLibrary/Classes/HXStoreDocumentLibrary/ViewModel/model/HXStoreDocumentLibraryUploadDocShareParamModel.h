//
//  HXStoreDocumentLibraryUploadDocShareParamModel.h
//  Pods
//  文档分享上传model
//  Created by J006 on 16/10/6.
//
//

#import <Foundation/Foundation.h>

@interface HXStoreDocumentLibraryUploadDocShareParamModel : NSObject

/**"docType": 0,   // 1普通文档；2付费文档 */
@property (nonatomic, strong) NSNumber  *docTypeNum;
/**`doc_title` : 1231231，'文档标题' */
@property (nonatomic, strong) NSString  *docTitleStr;
/**"docUrl": "文档路径",   //文档URL*/
@property (nonatomic, strong) NSString  *docUrlStr;
/**"docMd5": "MD5",   //文档M MD5*/
@property (nonatomic, strong) NSString  *docMd5Str;
/**"docTag": "文档标签"*/
@property (nonatomic, strong) NSString  *tagsStr;
/**`price` :100,'文档价格' */
@property (nonatomic, strong) NSDecimalNumber  *priceDecNum;

- (NSMutableDictionary *)itemDictionary;

@end
