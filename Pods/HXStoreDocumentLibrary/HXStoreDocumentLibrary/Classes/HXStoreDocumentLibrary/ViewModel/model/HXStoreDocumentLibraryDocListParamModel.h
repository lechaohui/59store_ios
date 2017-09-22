//
//  HXStoreDocumentLibraryDocListParamModel.h
//  HXStoreDocumentLibrary_Example
//  获取文章列表 参数model
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXStoreDocumentLibraryDocListType){
    HXStoreDocumentLibraryDocListTypeHot          = 1,//热门
    HXStoreDocumentLibraryDocListTypeCollect      = 2,//收藏
    HXStoreDocumentLibraryDocListTypePoint        = 3,//好评
    HXStoreDocumentLibraryDocListTypeTime         = 4,//最新
    HXStoreDocumentLibraryDocListTypeDefault      = 7,//默认
};

@interface HXStoreDocumentLibraryDocListParamModel : NSObject

/**second_category_id：str 二级目录id，非必填 */
@property (nonatomic, strong) NSString  *secondCategoryIdStr;
/**doc_id：str 文档id，非必填 */
@property (nonatomic, strong) NSString  *docIdStr;
/**offset：int 开始位置 */
@property (nonatomic, strong) NSNumber  *offsetNum;
/**limit：int 条数 */
@property (nonatomic, strong) NSNumber  *limitNum;
/**sort=1;//排序类型－热门：1,收藏：2，得分：3，时间：4，默认：7 */
@property (nonatomic, strong) NSNumber  *sortNum;
/**keyword：关键字 */
@property (nonatomic, strong) NSString  *keywordStr;

@end
