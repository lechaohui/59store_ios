//
//  HXSPrintCheckOutOrderParam.h
//  Pods
//
//  Created by J006 on 16/9/20.
//
//

#import <Foundation/Foundation.h>
#import "HXSPrintCartEntity.h"

@interface HXSPrintCheckOutOrderParam : NSObject
/**手机号码 */
@property (nonatomic, strong) NSString *phoneStr;
/**收货地址 */
@property (nonatomic, strong) NSString *addressStr;
/**备注 */
@property (nonatomic, strong) NSString *remarkStr;
/**支付方式 */
@property (nonatomic, strong) NSNumber *payTypeNum;
/**用户所在楼栋id */
@property (nonatomic, strong) NSNumber *dormentryIdNum;
/**店铺id */
@property (nonatomic, strong) NSNumber *shopIdNum;
/**是否免费打印 0不开启  1开启免费打印 */
@property (nonatomic, strong) NSNumber *openAdNum;
/**购物车对象*/
@property (nonatomic, strong) HXSPrintCartEntity *printCartEntity;
/**访问地址 */
@property (nonatomic, strong) NSString *apiStr;
/**收货地址中的购买人姓名 */
@property (nonatomic, strong) NSString *buyNameStr;
/**用户购物车看到的免费张数 */
@property (nonatomic, strong) NSNumber *cartFreeNum;

@end
