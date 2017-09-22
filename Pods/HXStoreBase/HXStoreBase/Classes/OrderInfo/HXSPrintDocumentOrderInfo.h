//
//  HXSPrintDocumentOrderInfo.h
//  Pods
//  文档购买订单
//  Created by J006 on 16/10/8.
//
//

#import <Foundation/Foundation.h>
#import "HXBaseJSONModel.h"

@interface HXSPrintDocumentOrderInfo : HXBaseJSONModel

/**  "id": 123465223676276435,   //订单号 */
@property (nonatomic, strong) NSString *idStr;
/**  "uid": 1446090442898909,   //uid */
@property (nonatomic, strong) NSString *uidStr;
/**  "docId": 216987012960135082,  //文档id */
@property (nonatomic, strong) NSString *docIdStr;
/**  "docTitle": "网管常用命令之雅思",  //文档标题 */
@property (nonatomic, strong) NSString *docTitleStr;
/**  "amount": 2,  //文档金额<价格> */
@property (nonatomic, strong) NSDecimalNumber *amountDecNum;
/**  "commission": 0.4,  //提成金额 */
@property (nonatomic, strong) NSDecimalNumber *commissionDecNum;
/**   "createTime": 1111111111,  //创建时间  long */
@property (nonatomic, strong) NSNumber *createTimeNum;
/**   "payType": null,  //支付方式  1-支付宝；2-微信H5支付；3-59花；6-微信app支付;8-信用支付 */
@property (nonatomic, strong) NSNumber *payTypeNum;
/**  "tradeNo": null,  //交易流水 */
@property (nonatomic, strong) NSString *tradeNoStr;
/**   "status": 0,  //支付状态  0未支付;1已支付 */
@property (nonatomic, strong) NSNumber *statusNum;
/**   "payTime": 1111111111,  //支付时间  long */
@property (nonatomic, strong) NSNumber *payTimeNum;
/**  "type": 21  //用于获取支付方式 */
@property (nonatomic, strong) NSNumber *typeIdNum;


+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
