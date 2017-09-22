//
//  HXStoreDocumentLibraryModel.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/7.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

//model
#import "HXStoreDocumentLibraryCategoryListModel.h"
#import "HXStoreDocumentLibraryDocListParamModel.h"
#import "HXStoreDocumentLibraryDocumentModel.h"
#import "HXSPrintListParamModel.h"
#import "HXStoreDocumentLibraryDocumentBuyedModel.h"
#import "HXSMyPrintOrderItem.h"
#import "HXStoreDocumentLibraryUploadDocShareParamModel.h"
#import "HXSPrintDocumentOrderInfo.h"

//other
#import "HXStoreDocumentLibraryImport.h"

typedef NS_ENUM(NSInteger, HXSLibraryDocumentFindingType) {
    kHXSLibraryDocumentFindingTypeSuppose = 1,
    kHXSLibraryDocumentFindingTypeRecommend = 2,
    kHXSLibraryDocumentFindingTypeNearby = 3
};

static NSInteger const DEFAULT_PAGESIZENUM          = 10;// 每页10条
static NSInteger const columnsLimitCategoryCell     = 3;//一行三列
static NSInteger const rowsLimitCategoryCell        = 3;//最大3行
static CGFloat   const rowsSingleHeightCell         = 44.0;//单行高度

@interface HXStoreDocumentLibraryViewModel : NSObject

/**
 *  获取一二级分类列表:（59文库页面）
 *
 *  @param block
 */
- (void)fetchDocumentCategoryListWithOffset:(NSNumber *)offset
                                   andLimit:(NSNumber *)limit
                                   Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryCategoryListModel *> *modelList))block;

/**
 *  获取文档列表
 *
 *  @param paramModel
 *  @param block
 */
- (void)fetchDocumentListWithParamModel:(HXStoreDocumentLibraryDocListParamModel *)paramModel
                               Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList))block;

/**
 *  获取单个文档
 *
 *  @param docIdStr
 *  @param block
 */
- (void)fetchDocumentModelWithDocId:(NSString *)docIdStr
                           Complete:(void (^)(HXSErrorCode code, NSString *message, HXStoreDocumentLibraryDocumentModel *docModel))block;

/**
 *  更新文档收藏状态
 *
 *  @param docIdStr
 *  @param starType
 *  @param block
 */
- (void)updateDocumentStarWithDocId:(NSString *)docIdStr
                            andtype:(NSNumber *)starType
                           Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL success))block;
/**
 *  收藏列表
 *
 *  @param offset
 *  @param limit
 *  @param block
 */
- (void)fetchStarDocumentListWithOffset:(NSNumber *)offset
                               andLimit:(NSNumber *)limit
                               Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList))block;

/**
 *  获取发现内容列表
 *
 *  @param block
 */
- (void)fetchFindingDocumentListComplete:(void (^)(HXSErrorCode code, NSString *message, NSMutableDictionary *modelList, NSMutableArray<NSString *> *tagStrArray, NSMutableArray<NSNumber *> *offsetNumsArray))block;

/**
 *  换一换接口
 *
 *  @param type
 *  @param offSet
 *  @param limitsNum
 *  @param block
 */
- (void)fetchFindingExchangeDocumentListWithType:(NSNumber *)type
                                       andOffser:(NSNumber *)offSet
                                       andLimits:(NSNumber *)limitsNum
                                        Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList))block;

/**
 *  热门搜索接口
 *
 *  @param block
 */
- (void)fetchSearchHotwordsComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray<NSString *> *hotWordsArray))block;

/**
 *  搜索接口
 *
 *  @param paramModel
 *  @param block
 */
- (void)fetchSearchDocumentListWithParamModel:(HXStoreDocumentLibraryDocListParamModel *)paramModel
                                     Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList))block;

/**
 *  用户收藏文档生成阅读记录接口
 *
 *  @param pageNums
 *  @param docId
 */
- (void)updateDocumentReadPagesWithPageNums:(NSNumber *)pageNums
                                   andDocId:(NSString *)docId
                                   Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;


/**
 *  根据子类目数目确认cell 高度
 *
 *  @param categoryListModel
 *  @param isShowAll
 *
 *  @return
 */
- (CGFloat)getCategoryCellHeight:(HXStoreDocumentLibraryCategoryListModel *)categoryListModel
                    andIsShowAll:(BOOL)isShowAll;

- (UIImage *)imageFromNewName:(NSString *)nameStr;

/**
 *  存储到本地的URL转换成字符串,去除前缀file://
 *
 *  @param block
 */
- (NSString *)saveLocalDocPathURLWithURL:(HXStoreDocumentLibraryDocumentModel *)docModel;

/**
 *  根据docModel进行收藏
 *
 *  @param docModel
 *  @param vc
 *
 */
- (void)updateDocmentStarWithDocModelAndSaveLocal:(HXStoreDocumentLibraryDocumentModel *)docModel
                                            andVC:(UIViewController *)vc
                                      andComplete:(void (^)(HXStoreDocumentLibraryDocumentModel *docModel))block;
/**
 *  生成一个分享界面分享文档
 *
 *  @param vc
 *  @param docModel
 */
- (void)createShareViewAndShowIn:(UIViewController *)vc
                    withDocModel:(HXStoreDocumentLibraryDocumentModel *)docModel;

/**
 *  为icon imageView 设置图片
 *
 *  @param imageView
 *  @param docModel
 */
- (void)setImageForIconImageView:(UIImageView *)imageView
                       withModel:(HXStoreDocumentLibraryDocumentModel *)docModel;

/**
 *  根据timestamp计算出年月日
 *
 *  @param timeStamp
 */
- (NSString *)createUploadTimeYearMonthDayWithTimeStamp:(NSString *)timeStamp;

/**
 *  根据标签转换成一个数组
 *
 *  @param tagsStr
 */
- (NSMutableArray<NSString *> *)createTagsArrayForTagsStr:(NSString *)tagsStr;

/**
 *  根据数组转换成一个标签
 *
 *  @param tagsStr
 */
- (NSString *)createTagsStrWithTagsArray:(NSMutableArray<NSString *> *)tagsArray;

- (void)checkTheTextFieldTextIsMoreThanMax:(UITextField *)textField
                           andMaxInputNums:(NSInteger)maxInputNums;

/**
 *  获取店长私藏或者个人上传的文档列表
 *
 *  @param shopIdIntNum 店铺id
 *  @param block
 */
- (void)fetchPrintDormShopShareDocWithShopId:(NSNumber *)shopIdIntNum
                           andParamListModel:(HXSPrintListParamModel *)paramListModel
                                    complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *array))block;

/**
 *  获取店长私藏或者个人上传的文档总数
 *
 *  @param shopIdIntNum 店铺id
 *  @param block
 */
- (void)fetchPrintDormShopShareDocTotalNumsWithShopId:(NSNumber *)shopIdIntNum
                                             Complete:(void (^)(HXSErrorCode code, NSString *message, NSNumber *totalNums))block;

/**
 *  获取已购文档
 *
 *  @param paramListModel
 *  @param block
 */
- (void)fetchPrintBuyedDocsListWithParamListModel:(HXSPrintListParamModel *)paramListModel
                                         Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentBuyedModel *> *array))block;

/**
 *  文档分享
 *
 *  @param isAnonymous 是否是匿名
 *  @param docListArray
 *  @param block
 */
- (void)upLoadDocumentShareWithIsAnonymous:(NSNumber *)isAnonymous
                            andDocListArray:(NSMutableArray<HXStoreDocumentLibraryUploadDocShareParamModel *> *)docListArray
                                  Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL success))block;

/**
 *  文档取消分享
 *
 *  @param docIdStr
 *  @param block
 */
- (void)cancelDocumentShareWithDocId:(NSString *)docIdStr
                            Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL success))block;

/**
 *  购买文档接口,生成一个订单
 *
 *  @param docIdStr
 *  @param block
 */
- (void)createDocumentOrderInfoWithDocId:(NSString *)docIdStr
                                Complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintDocumentOrderInfo *docOrderInfo))block;

/**
 *  将购物车里的对象转换成doc对象数组
 *
 *  @param cartArray
 *  @param block
 */
- (NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *)convertOrderItemArrayToDocLibArray:(NSMutableArray<HXSMyPrintOrderItem> *)cartArray;

/**
 *  将普通Doc对象数组转换成可分享的doc数组
 *
 *  @param cartArray
 */
- (NSMutableArray<HXStoreDocumentLibraryUploadDocShareParamModel *> *)convertNormalDocModelArrayToParamModelArray:(NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *)docModelArray;

@end
