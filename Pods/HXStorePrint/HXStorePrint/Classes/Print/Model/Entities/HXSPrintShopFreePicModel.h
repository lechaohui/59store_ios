//
//  HXSPrintShopFreePicModel.h
//  Pods
//  免费照片打印信息
//  Created by J006 on 16/10/19.
//
//

#import <Foundation/Foundation.h>
#import "HXBaseJSONModel.h"

@interface HXSPrintShopFreePicModel : HXBaseJSONModel

/** "phone" "18966499006"//店铺联系电话 */
@property (nonatomic, strong) NSString *phoneStr;
/** "has_opend":0,//int,开通:1；未开通:0； */
@property (nonatomic, strong) NSNumber *hasOpenedNum;
/** "url": str,  //二维码地址 */
@property (nonatomic, strong) NSString *urlStr;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
