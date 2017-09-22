//
//  HXStoreDocumentLibraryDocumentModel.h
//  HXStoreDocumentLibrary_Example
//  文档单个Model
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

typedef NS_ENUM(NSInteger, HXSLibraryDocumentType) {
    HXSLibraryDocumentTypeNormal = 1,
    HXSLibraryDocumentTypeBuy = 2
};

typedef NS_ENUM(NSInteger, HXSLibraryDocumentBuyType) {
    HXSLibraryDocumentBuyTypeNot = 2,
    HXSLibraryDocumentBuyTypeSuccess = 3,
    HXSLibraryDocumentBuyTypeFree = 1
};

typedef NS_ENUM(NSInteger, HXSLibraryDocumentVerifyStatusType) {
    HXSLibraryDocumentVerifyStatusChecking  = 0,//审核中
    HXSLibraryDocumentVerifyStatusPass      = 1,//审核通过
    HXSLibraryDocumentVerifyStatusNotPass   = 2//审核不通过
};

@interface HXStoreDocumentLibraryDocumentModel : HXBaseJSONModel

/**s`doc_id`: 123123，'文档id', */
@property (nonatomic, strong) NSString  *docIdStr;
/**`author_id` : 123123，'贡献者ID', */
@property (nonatomic, strong) NSString  *authorIdStr;
/**`doc_provision_name` : 123123，'贡献者' */
@property (nonatomic, strong) NSString  *docProvisionNameStr;
/**`doc_title` : 1231231，'文档标题' */
@property (nonatomic, strong) NSString  *docTitleStr;
/**`is_on` : 1，'是否上架：0-下架；1-上架' */
@property (nonatomic, strong) NSNumber  *isOnNum;
/**`is_top` : 1，'是否置顶：0-否；1-是' */
@property (nonatomic, strong) NSNumber  *isTopNum;
/**`org_id` : 123123'，所属机构id' */
@property (nonatomic, strong) NSString  *orgIdStr;
/**`first_category_id` : 12312313，'一级分类id', */
@property (nonatomic, strong) NSNumber  *firstCategoryIdNum;
/**`second_category_id` : 123123123，'二级分类id' */
@property (nonatomic, strong) NSNumber  *secondCategoryIdNum;
/**``source_size` : 1024,'文档大小,单位k'' */
@property (nonatomic, strong) NSString  *sourceSizeStr;
/**`type` : 1'文档类型，1-普通文档；2-付费文档' */
@property (nonatomic, strong) NSNumber  *typeNum;
/**`price` :100,'文档价格' */
@property (nonatomic, strong) NSDecimalNumber  *priceDecNum;
/**`read_count` : '用户点击数' */
@property (nonatomic, strong) NSNumber  *readCountNum;
/**`star_count` : '收藏总次数' */
@property (nonatomic, strong) NSNumber  *starCountNum;
/**`score_count` : 1,'评分总次数' */
@property (nonatomic, strong) NSNumber  *scoreCountNum;
/**`download_count` : 1,'下载量' */
@property (nonatomic, strong) NSNumber  *downloadCountNum;
/**`score_average` : 1.3,'平均分'*/
@property (nonatomic, strong) NSNumber  *scoreAverageNum;
/**url : ,转换后的文档地址url*/
@property (nonatomic, strong) NSString  *urlStr;
/**`create_time` : 2016-06-28 16:12:46,'创建时间'*/
@property (nonatomic, strong) NSString  *createTimeStr;
/**`is_favor; // 是否收藏 0-未收藏 1-已收藏*/
@property (nonatomic, strong) NSNumber  *isFavorNum;
/**"create_timestamp";//时间戳*/
@property (nonatomic, strong) NSString  *createTimestampStr;
/**"doc_num":,//文档页数*/
@property (nonatomic, strong) NSNumber  *docNum;
/**"source_md5":,//原文档md5*/
@property (nonatomic, strong) NSString  *sourceMd5Str;
/**"pdf_md5":,//转换后文档md5*/
@property (nonatomic, strong) NSString  *pdfMd5Str;
/**"source_size"://文档大小*/
@property (nonatomic, strong) NSNumber  *sourceSizeNum;
/**page_num:1,//阅读的页数*/
@property (nonatomic, strong) NSNumber  *pageReadNum;
/**"doc_suffix":docx,//文档后缀*/
@property (nonatomic, strong) NSString  *docSuffixStr;
/**"has_rights":1,//如果该文档为付费文档则这个字段标示用户是否有权限查看该文档*/
@property (nonatomic, strong) NSNumber  *hasRightsNum;
/** "verify_status":0, //审核状态：0待审核，1审核通过，2审核不通过 */
@property (nonatomic, strong) NSNumber  *verifyStatusNum;

@property (nonatomic, strong) NSString  *tagsStr;

//以下为自定义属性
@property (nonatomic, strong) NSURL     *archiveDocPathURL;
/** 存储到本地的地址如: /Users/j006/Library/Developer/CoreSimulator/Devices/D000E078-DF65-44CB-8106-AA7DFFEC80C0/data/Containers/Data/Application/93B46F02-6E7B-455E-8985-4A95CA1ED659/Documents/DocumentDownloadFiles/xxx.pdf */
@property (nonatomic, strong) NSString  *archiveDocPathStr;
@property (nonatomic, strong) NSString  *pdfNameStr;
@property (nonatomic, assign) BOOL      isShowTagsAndPrice;//文档分享界面:是否展示标签和价格

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
