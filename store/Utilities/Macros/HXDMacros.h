//
//  HXDMacros.h
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#ifndef store_HXDMacros_h
#define store_HXDMacros_h

/*
typedef enum
{
    //未知错误
    kHXDUnknownError = -1,
    
    //服务器返回的错误
    kHXDNoError = 0,
    
    kHXSNormalError = 1,
    
    kHXDInvalidTokenError = 2,
    
    kHXDParamError = 3,
    
    kHXDItemNotExit = 4,
    
    kHXDSignError = 5,
    
    kHXDTimeoutError = 6,
    
    kHXDNeedVerifyCodeError = 7,
    
    //自定义错误
    kHXDNetWorkError = 100,
    
    kHXDRegisterAccountExist = 101,
    
    kHXDLoginNoAccountError = 102,
    
    kHXDLoginPasswordError = 103,
    
    kHXDNotExitDormError         = 1000,
    KHXDDormHasBeenDeleted       = 1001,
    kHXDRestrictedLogin          = 1002,
    kHXDMismatchingDormInfoError = 1003,
    
    kHXDMyLoanRejectNoJump = 1100,
    kHXDMyLoanRejectJumpTo = 1101,
    kHXDMyLoanRejectNoSchool = 1105,
    
    kHXDWechatOnlinePaymentFailed     = 1046,
    kHXDWechatOnlinePaymentPaySuccess = 1048,
    kHXDWechatOnlinePaymentPayFailed  = 1049,
    kHXDPayStatusUnderstock           = 1029,
    
    
} HXDErrorCode;*/


/*
// 消息中心 消息类型
typedef enum : NSUInteger {
    kHXDMessageTypeNone                 = 0,
    kHXDMessageTypePrintNewOrder        = 21,
    kHXDMessageTypePrintPayedOrder      = 22,
    kHXDMessageTypePrintCancelOrder     = 23,
    kHXDMessageTypeDormNewOrder         = 11,
    kHXDMessageTypeDormPayedOrder       = 12,
    kHXDMessageTypeDormCancelOrder      = 13,
} HXDMessageType;*/


// source订单来源
typedef enum : NSUInteger {
    kHXDOrderSourceWeb        = 0,
    kHXDOrderSourceMobile     = 1,
    kHXDOrderSourceShop       = 2,
    kHXDOrderSourceIOS        = 3,
    kHXDOrderSourceAndroid    = 4,
    kHXDOrderSourceElemeH5    = 5,
} HXDOrderSource;

typedef enum : NSUInteger {
    kHXDConsumptionTypeToBed        = 0,
    kHXDConsumptionTypeFaceToFace   = 1,
} HXDConsumptionType;

// 支付类型
typedef enum : NSUInteger {
    kHXDOrderPayTypeCash       = 0,//货到付款
    kHXDOrderPayTypeAlipay     = 1,//支付宝
    kHXDOrderPayTypeWechat     = 2,//微信支付
    kHXDOrderPayTypeBaiHuaHua  = 3,//白花花
    kHXDOrderPayTypeAlipayScan = 4,//支付宝当面付
    kHXDOrderPayTypeWechatScan = 5,//微信刷卡支付
    kHXDORderPayTypeWechatApp  = 6,//微信APP支付
    kHXDORderPayTypeShopKeeper = 7,//店长代付
    kHXDORderPayType59Wallet   = 8,//59钱包支付
} HXDOrderPayType;

//订单类型
typedef enum : NSUInteger {
    kHXDShopTypeDrom   = 0,
    kHXDShopTpeDrink   = 1,
} HXDShopType;

typedef NS_ENUM(NSUInteger, HXDDormentyShopType) {
    HXDShopTypeDorm = 0,
    HXDShopTypeDrink,
    HXDShopTypePrint,
    HXDShopTypeBox,
};

//用户角色
typedef NS_ENUM(NSUInteger, HXDUserRoleType) {
    HXDUserRoleMike = 0,    //脉客
    HXDUserRoleShopManager, //店长
    HXDUserRoleSuperManager,//超级店长
};

// 供应商类型 (0: 大仓 1: 百世 2: 校超 3: 经销商 )
typedef NS_ENUM(NSInteger, HXDSupplerType) {
    HXDSupplerTypeDaCang = 0,
    HXDSupplerTypeBaiShi,
    HXDSupplerTypeXiaoChao,
    HXDSupplerTypeJingXiaoShang,
};

typedef NS_ENUM(NSInteger, HXDPaymentType){
    kHXDPaymentTypeWechat   = 0,    // 微信刷卡
    kHXDPaymentTypeAlipay   = 1,    // 支付宝当面付
    kHXDPaymentTypeStorePay = 2,    // 现金支付
};

typedef NS_ENUM(NSInteger, HXDPurchasePaymentType){
    HXDPurchasePaymentTypeBalance   = 0,    // 余额支付
    HXDPurchasePaymentTypeAlipay    = 1,    // 支付宝
};

// 订单状态 99：已取消   1：待付款   2：待接单   3: 处理中   4：待收货   5：完成
typedef NS_ENUM(NSInteger, HXDPurchaseOrderStatus){
    HXDPurchaseOrderStatusWaitPayment     = 1,     // 待付款
    HXDPurchaseOrderStatusReceiveOrder    = 2,     // 待接单
    HXDPurchaseOrderStatusInProcessing    = 3,     // 处理中(待发货)
    HXDPurchaseOrderStatusReceiveCommdity = 4,     // 待收货(已发货)
    HXDPurchaseOrderStatusCompleted       = 5,     // 已完成
    HXDPurchaseOrderStatusCancled         = 99,    // 已取消
};

// 打印订单状态 0-未支付，1-待打印，6-已打印，2-已完成，5-已取消
typedef NS_ENUM(NSInteger, HXDPrintOrderStatus){
    HXDPrintOrderStatusUnpaied            = 0,     // 未支付
    HXDPrintOrderStatusWaitToPrint        = 1,     // 待打印
    HXDPrintOrderStatusCompleted          = 2,     // 已完成
    HXDPrintOrderStatusCancled            = 5,    // 已取消
    HXDPrintOrderStatusPrinted            = 6,    // 已打印
};


typedef NS_ENUM(NSInteger, HXDPrintOrderDeliveryType){
    HXDPrintOrderDeliveryTypeDormDelivery     = 1,     // 店长配送
    HXDPrintOrderDeliveryTypeUserPick          = 2,     // 上门自取
};

typedef NS_ENUM(NSInteger, HXDPrintOrderFileType){
    HXDPrintOrderFileTypePicture     = 0,     // 照片
    HXDPrintOrderFileTypeDocument    = 1,     // 文档
};


typedef NS_ENUM(NSInteger, HXAvailableBusinessType){
    HXAvailableBusinessTypeDorm    = 0, // 夜猫店
    HXAvailableBusinessTypePrint   = 2, // 云印店
    HXAvailableBusinessTypeBox     = 3, // 零食盒
    HXAvailableBusinessTypeGroupon = 4, // 约团
    HXAvailableBusinessTypeLoan    = 5, // 免费铺货
};


typedef enum : NSUInteger {
    kHXDFaceToFaceOrderStatusNotDone = 0,//已提交,
    kHXDFaceToFaceOrderStatusConfirm = 1,//已确认
    kHXDFaceToFaceOrderStatusDeliver = 2,// 之前是已送出已送出 现在给出已完成
    kHXDFaceToFaceOrderStatusDone    = 4,//已完成
    kHXDFaceToFaceOrderStatusCancel  = 5,//失败
    kHXDFaceToFaceOrderStatusWait    = 11,//等待用户在线支付
} HXDFaceToFaceOrderStatusType;

//面签
//面签列表请求参数的订单状态枚举
typedef NS_ENUM(NSInteger, HXDVisaInterviewParamOrderStatus){
    kHXDVisaInterviewOrderStatusChecking   = 2,    // 审核中
    kHXDVisaInterviewOrderStatusDone       = 3,    // 已完成
    kHXDVisaInterviewOrderStatusUnCheck    = 1,    // 待处理
};

//面签列表请求参数的订单状态枚举
typedef NS_ENUM(NSInteger, HXDVisaInterviewListOrderStatus){
    HXDVisaInterviewListStatusNotGet            = -1,   // 已被其他抢单或其他错误
    HXDVisaInterviewListStatusOrderGet          = 0,    // 已下单
    HXDVisaInterviewListStatusPayDone           = 1,    // 已首付
    HXDVisaInterviewListStatusWaitForGrap       = 2,    // 下单电审通过（待抢单）
    HXDVisaInterviewListStatusCheckNotPass      = 3,    // 下单电审不通过（订单取消，退款）
    HXDVisaInterviewListStatusGrapDone          = 4,    // 已抢单（待上传资料）
    HXDVisaInterviewListStatusUploadDone        = 5,    // 已上传（待面签审核）
    HXDVisaInterviewListStatusCheckDone         = 6,    // 面签审核通过
    HXDVisaInterviewListStatusNeedReUpload      = 7,    // 重新上传（面签审核打回）
    HXDVisaInterviewListStatusReject            = 8,    // 面签审核拒绝
};

typedef NS_ENUM(NSInteger, HXDVisaInterviewTakePhotoType){
    kHXDVisaInterviewTakePhotoTypeIDCard            = 0,    // 身份证正面
    kHXDVisaInterviewTakePhotoTypeIDCardOpp         = 1,    // 身份证反面
    kHXDVisaInterviewTakePhotoTypeStudentCard       = 2,    // 学生证
    kHXDVisaInterviewTakePhotoTypeRisk              = 3,    // 手持风险告知书
    kHXDVisaInterviewTakePhotoTypeGroup             = 4,    // 店长与用户合影
};

typedef NS_ENUM(NSInteger, HXDAccountType){
    HXDAccountTypeNoneAuthority                     = 0,    // 无任何权限（普通用户）
    HXDAccountTypeOnlyShopOwner                     = 1,    // 仅正常店长
    HXDAccountTypeOnlyMankeep                       = 2,    // 仅为脉客
    HXDAccountTypeShopOwnerAndMankeep               = 3,    // 店长／脉客权限兼得
};

typedef NS_ENUM(NSInteger, HXDMyShopFastEntryType) {
    kHXDMyShopFastEntryShopSetting = 0,
    kHXDMyShopFastEntryFactToFace,
    kHXDMyShopFastEntryStrategy,
};

typedef NS_ENUM(NSUInteger, HXDMyShopSectionType) {
    kHXDMyShopSectionTypeStatistic = 0,    //  数据统计
    kHXDMyShopSectionTypeBanner,           //  轮播
    kHXDMyShopSectionTypeOrderStatus,      //  采购单状态
    HXDMyShopSectionTypeFastEntry,         //  快捷入口
};

typedef NS_ENUM(NSInteger, PersonInfoType) {
    PersonInfoNone       = 0,
    // ====================================================
    
    PersonInfoHeaderIcon,                   // 头像
    PersonInfoUserName,                     // 用户名
    
    PersonInfoPhone,                        // 联系方式
    PersonInfoReceiveAddress,               // 取货地址
    PersonInfoPayAccount,                   // 支付宝账号
    
    PersonInfoBroadcast,                    // 店铺公告
    
    PersonInfoFreeDistrbutionPrice,             //起送价
    
    PersonInfoShopName,                     //店铺名称
    PersonInfoSignature,                    //个性签名
    
};

typedef NS_ENUM(NSInteger, HXDSellerMessageType) {
    
    kSellerMessageTypeNotice            = 0,
    
    kSellerMessageTypeSystemMessage     = 1,
};


#pragma mark - Notification Keys

#define NOTIFICATION_ALIPAY_SCAN                    @"notificationAlipayScan"
#define NOTIFICATION_FACE_TO_FACE_SELECTED_ITEM     @"faceToFaceSelectedItem"
#define NOTIFICATION_TODAY_UNPROCESSED_CHANGED      @"todayUnprocessedOrdersChangedNotification"
#define NOTIFICATION_FACE_TO_FACE_SOLD_DONE         @"faceToFaceSoldDone"
#define NOTIFICAATION_PRINT_TODAY_UNPROCESSED_ORDER @"printTodayUnprocessedOrder"

// #################  请求成功跳转至目标页面相关通知  #################
static NSString * const kHXDApplySuccessToSelectSupllierNotification        = @"kHXDApplySuccessToSelectSupllierNotification"; // 跳至选择供应商页面
static NSString * const kHXDApplySuccessToMyLoanNotification                = @"kHXDApplySuccessToMyLoanNotification";  // 跳至我的贷款页面
static NSString * const kHXDApplySuccessToBusinessManageNotification        = @"kHXDApplySuccessToBusinessManageNotification"; // 跳至业务管理
static NSString * const kHXDApplySelectMankeepNotification                  = @"kHXDApplySelectMankeepNotification"; // 选择身份时，点击了想成为脉客

// 打印详情相关通知
static NSString * const kHXDPrintOrderStatusChangeNotification                  = @"kHXDPrintOrderStatusChangeNotification"; // 打印详情通知
static NSString * const kHXDPrintOrderCountChangeNotification                   = @"kHXDPrintOrderCountChangeNotification";  // 打印订单数量通知

// #################  业务开通相关通知 去更新页面 #################

static NSString * const kHXDShopOwnerOpenOtherBusinessNotification           = @"kHXDShopOwnerOpenOtherBusinessNotification"; // 店长身份开通其他业务，更新UI

static NSString * const kHXDPurchaseSelectCountChangedNotification           = @"kHXDPurchaseSelectCountChangedNotification"; // 采购点击加或减，改变数量，保证同一个商品的count一致

static NSString * const kHXDPurchaesCheckoutHasInvalidItemsNotification           = @"kHXDPurchaesCheckoutHasInvalidItemsNotification"; // 有失效商品通知

static NSString * const kHXDPurchaesDetailOrderPaySuccessNotification           = @"kHXDPurchaesDetailOrderPaySuccessNotification"; // 有失效商品通知

static NSString * const kHXDCommodityInfoDidChangeNotification           = @"kHXDCommodityInfoDidChangeNotification"; // 商品信息变更通知


#pragma mark - BOX 相关常量

static NSString *const HXDAvailableDistributeItems = @"HXDAvailableDistributeItems";

// Notification Keys

static NSString *const HXDBoxRenewalNotification  = @"HXDBoxRenewalNotification";                       // 续订新的零食盒子
static NSString *const HXDBoxUnrenewalNotification  = @"HXDBoxUnrenewalNotification";                   // 不在续订新的零食盒子

static NSString *const HXDBoxCompleteDistributeNotification  = @"HXDBoxCompleteDistributeNotification"; // 配货成功
static NSString *const HXDBoxCompleteCheckNotification  = @"HXDBoxCompleteCheckNotification";           // 完整清点

static NSString *const HXDBoxDetailRemarkDidUpdatedNotification = @"HXDBoxDetailRemarkDidChangeNotification"; // 盒子详情备注更新

//static NSString *const HXDPurchaseItemSelectCountUpdated = @"HXDPurchaseItemSelectCountUpdated"; // 采购页面用户选择数量更新
static NSString *const HXDPurchaseDidAddNewbiePackage    =   @"HXDPurchaseDidAddNewbiePackage"; // 一键加入新手包
static NSString *const HXDPurchaseCartDidEmpty        = @"HXDPurchaseCartDidEmpty"; // 采购页面购物车VC 减少到0


#define kSharedLocationManagerForUserDefault  @"kSharedLocationManagerForUserDefault"

#define kHXSBoxAddSKUSearchHistoryUserDefault @"kHXSBoxAddSKUSearchHistoryUserDefault"

#define USER_DEFAULT_LOCATION_MANAGER         @"LocationManager"

#define kPositioningCityChanged         @"kPositioningCityChanged"
#define kCityChanged                    @"kCityChanged"
#define kPositionCityFailed             @"kPositionCityFailed"

// box_status:（0-待配货、1-经营中、2-转让中、3-待结算、4-清点中、5-结算中、99-申请中）
typedef NS_ENUM(NSInteger, HXDBoxStatus) {
    kHXDBoxStatusWaitForDistribute      = 0,
    kHXDBoxStatusOperationing           = 1,
    kHXDBoxStatusTransferring           = 2,
    kHXDBoxStatusWaitForCheck           = 3,
    kHXDBoxStatusMakeInventory          = 4,
    kHXDBoxStatusUnderChecking          = 5,
    kHXDBoxStatusBusinessAppling        = 99,
};

#pragma mark - 主要颜色

#define MainLightBlue ([UIColor colorWithRGBHex:0x07a9fa])
#define LineViewLightGray ([UIColor colorWithRGBHex:0xe1e2e3])  // 线条颜色
#define PriceLightRedColor ([UIColor colorWithRGBHex:0xFF6000])
#define ThreeAllBlackColor ([UIColor colorWithRGBHex:0x333333]) // 近黑色
#define SixAllGrayColor  ([UIColor colorWithRGBHex:0x666666])
#define NineAllLightGrayColor ([UIColor colorWithRGBHex:0x999999])
#define SectionBackgroundColor ([UIColor colorWithRGBHex:0xf4f5f6]) // tableView Section 背景色
#define SystemDefaultLineColor ([UIColor colorWithRGBHex:0xc7c7cc])

/*
typedef NS_ENUM(NSInteger,HXSSubscribeStepIndex){
    HXSSubscribeStepIndexID             = 0,//身份信息
    HXSSubscribeStepIndexAuthorize      = 1,//授权信息学籍信息
    HXSSubscribeStepIndexStudent        = 2,//学籍信息
    HXSSubscribeStepIndexBankCard       = 3,//银行卡信息
    HXSSubscribeStepIndexSubmitSucc     = 4,//提交成功
};*/
#define LineHeight  (1.0 / [UIScreen mainScreen].scale)

/*
// 登录账号
typedef enum
{
    kHXSSinaWeiboAccount,
    kHXSWeixinAccount,
    kHXSQQAccount,
    kHXSRenrenAccount,
    kHXSUnknownAccount = 99,
}HXSAccountType;

// 分享 结果
typedef NS_ENUM(NSUInteger, HXSShareResult) {
    kHXSShareResultOk = 0,
    kHXSShareResultCancel = 1,
    kHXSShareResultFailed = 2
};

typedef NS_ENUM(NSUInteger, HXSShareType) {
    kHXSShareTypeWechatFriends = 0,
    kHXSShareTypeWechatMoments = 1,
    kHXSShareTypeSina          = 2,
    kHXSShareTypeMessage       = 3,   // Do nothing
    kHXSShareTypeQQMoments     = 4,
    kHXSShareTypeQQFriends     = 5,
    kHXSShareTypeCopyLink      = 6
};*/

#endif
