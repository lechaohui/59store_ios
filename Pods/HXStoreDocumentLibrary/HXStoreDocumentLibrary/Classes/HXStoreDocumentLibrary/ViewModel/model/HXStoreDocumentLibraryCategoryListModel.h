//
//  HXStoreDocumentLibraryCategoryListModel.h
//  HXStoreDocumentLibrary_Example
//  一二级分类列表:（59文库页面）
//  Created by J006 on 16/9/7.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

@protocol HXStoreDocumentLibraryCategoryModel
@end

@interface HXStoreDocumentLibraryCategoryModel : HXBaseJSONModel

/** "category_id": 12345,//目录id，bigint(20) */
@property(nonatomic, strong) NSNumber *categoryIdNum;
/** "parent_id": 0,//上级分类id，bigint(20) */
@property(nonatomic, strong) NSNumber *parentIdNum;
/** "category_name": "name",//目录名称 */
@property(nonatomic, strong) NSString *categoryNameStr;
/** "category_image": "image",//缩略图 */
@property(nonatomic, strong) NSString *categoryImageStr;
/** "category_banner_image": "banner image url---",//banner图 */
@property(nonatomic, strong) NSString *categoryBannerImageStr;
/** "is_show": 1,//是否展示：0－否；1－是 */
@property(nonatomic, strong) NSNumber *isShowNum;
/** "is_recommended": 1,//是否推荐：0-否；1-是（一级没有这一项） */
@property(nonatomic, strong) NSNumber *isRecommendedNum;
/**  "create_time":"2016-06-28 16:12:46",//创建时间 */
@property(nonatomic, strong) NSString *createTimeStr;
/**  "sort": 1,//排序字段*/
@property(nonatomic, strong) NSNumber *sortNum;
/**  "subscribe_count": 123,//关注总数*/
@property(nonatomic, strong) NSNumber *subscribeCountNum;
/**  "doc_count": 123,//文档总数*/
@property(nonatomic, strong) NSNumber *docCountNum;
/**  "star_count": 112,//收藏总数*/
@property(nonatomic, strong) NSNumber *starCountNum;
/**  "score_average": 2,//平均分*/
@property(nonatomic, strong) NSNumber *scoreAverageNum;
/**  "read_count": 1,//阅读总数*/
@property(nonatomic, strong) NSNumber *readCountNum;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end

@interface HXStoreDocumentLibraryCategoryListModel : HXBaseJSONModel

/** "category_id": 12345,//目录id，bigint(20) */
@property(nonatomic, strong) NSNumber *categoryIdNum;
/** "parent_id": 0,//上级分类id，bigint(20) */
@property(nonatomic, strong) NSNumber *parentIdNum;
/** "category_name": "name",//目录名称 */
@property(nonatomic, strong) NSString *categoryNameStr;
/** "category_image": "image",//缩略图 */
@property(nonatomic, strong) NSString *categoryImageStr;
/** "category_banner_image": "banner image url---",//banner图 */
@property(nonatomic, strong) NSString *categoryBannerImageStr;
/** "is_show": 1,//是否展示：0－否；1－是 */
@property(nonatomic, strong) NSNumber *isShowNum;
/** "is_recommended": 1,//是否推荐：0-否；1-是（一级没有这一项） */
@property(nonatomic, strong) NSNumber *isRecommendedNum;
/**  "create_time":"2016-06-28 16:12:46",//创建时间 */
@property(nonatomic, strong) NSString *createTimeStr;
/**  "sort": 1,//排序字段*/
@property(nonatomic, strong) NSNumber *sortNum;
/**  "subscribe_count": 123,//关注总数*/
@property(nonatomic, strong) NSNumber *subscribeCountNum;
/**  "doc_count": 123,//文档总数*/
@property(nonatomic, strong) NSNumber *docCountNum;
/**  "star_count": 112,//收藏总数*/
@property(nonatomic, strong) NSNumber *starCountNum;
/**  "score_average": 2,//平均分*/
@property(nonatomic, strong) NSNumber *scoreAverageNum;
/**  "read_count": 1,//阅读总数*/
@property(nonatomic, strong) NSNumber *readCountNum;
/**  "category": [   //下属二级菜单list，同字段内容同上*/
@property(nonatomic, strong) NSArray<HXStoreDocumentLibraryCategoryModel> *categoryArray;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
