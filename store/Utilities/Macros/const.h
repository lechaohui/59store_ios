//
//  const.h
//  dorm
//
//  Created by ranliang on 15/6/2.
//  Copyright (c) 2015年 Huanxiao. All rights reserved.
//

#ifndef dorm_const_h
#define dorm_const_h

//#define kHXSSecret                      @"a2c09d6b29eb11e5a3ba985aeb89a1ce"
//#define kChannelKey                     @"A11000"//渠道key
//#define kMobclickKey                    @"559625de67e58e3c36003f5e"//友盟统计key
//#define kUMFeedBackKey                  @"559625de67e58e3c36003f5e" //友盟反馈key

//qq
//#define kTencentAppId  @"1105007275"
//#define kTencentAppKey @"RMmP0ehix5syhINr"

//sina
//#define kSinaWeiboAppKey             @"3097569651"
//#define kSinaWeiboAppSecret          @"890c68e532b815fe0f65d94ac4f34899"
//#define kSinaWeiboAppRedirectURI     @"http://www.59store.com/callback"

//wechat
//#define kWeixinAppId     @"wxeb35de01465da561"
//#define kWeixinAppSecret @"05a50d754338bfa4c9ee35cc032b0d60"

#define kHXDURLStringForDefaultUserPortrait   @"http://dormimg.59store.com/portrait/app/default.jpg"

// 客服热线
#define kCustomerServiceTelphone  @"0571-57879537"

//SDK-UI配置
#define  Config [UDConfig sharedUDConfig]

// 是否IOS7
#define ud_isIOS7                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
// 是否IOS6
#define ud_isIOS6                  ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)
//是否是iOS8以上
#define ud_isIOS8                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)

//是否是iOS9以上
#define ud_isIOS9                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)

/* ------------------------------ 网络请求相关 --------------------------------------*/

// 生产服务器
//#define HXD_SERVER_URL                  @"http://120.55.72.115:8080/dormapi/"

// stage
//#define HXD_SERVER_URL                  @"http://dormappapistaged.59store.com/dormapi/"

// 公司内网，防火墙
//#define HXD_SERVER_URL                  @"http://dormappapi.59temai.com/"

// 公司内网
//#define HXD_SERVER_URL                  @"http://172.16.107.218:3000/dormapi/"

#define HXD_SERVER_URL                   [[ApplicationSettings instance] currentServiceURL]

//URI
#define HXD_TOKEN_UPDATE          @"app/token/new"
#define HXD_DEVICE_UPDATE         @"app/device/update"
#define HXD_USER_LOGOUT           @"user/logout"
#define HXD_DORM_INFO             @"dorm/info"
#define HXD_DORM_UPDATE_INFO      @"dorm/updateinfo"
#define HXD_ORDER_TOTOLIST        @"order/todolist"       // 取全部代办订单
#define HXD_ORDER_DONELIST        @"order/donelist" //历史订单(不含收银台订单) APP2.0
#define HXD_ORDER_FOODS           @"order/foods"
#define HXD_ORDER_PROCESS         @"order/process"
#define HXD_ORDER_CANCEL          @"order/cancel"
#define HXD_ORDER_CONFIRM         @"order/confirm"
#define HXD_VERSION_INFO          @"app/version/info"
#define HXD_RECEIVE_STATUS        @"app/device/receive_status"// 获取推送新订单消息开关状态
#define HXD_ORDER_ALIPAY_SCAN_URL @"order/alipay_scan_url"
#define HXD_ORDER_INFO            @"order/info"
#define HXD_SLIDE_LIST            @"app/slide/list"

#define HXD_PERSONAL              @"shopowner/info"//个人信息
#define HXD_UPDATEPERSONAL        @"shopowner/update"//更新个人信息
#define HXD_GETSMSCODE            @"shopowner/smscode" //获取手机验证码
#define HXD_CHECKSMSCODE          @"shopowner/check_scmcode" // 校验原有手机短信验证码
#define HXD_DORMITEM_LIST         @"dormitem/catelist" // 获取店长商品列表 (收银台)
#define HXD_DORMITEM_CATEGORIES   @"dormitem/categories" // 获取商品分类 (收银台)

/****************************** 商家信息 *****************************/
#define HXD_SELLER_INFO           @"seller/info"            // 商家信息
#define HXD_SELLER_DETAIL_INFO    @"seller/baseinfo"        // 商家基本信息
#define HXD_UPLOADAVATAR          @"seller/uploadportrait"  // 更改商家头像
#define HXD_UPDATE_SELLERINFO     @"seller/update"          // 更新商家地址信息
#define HXD_SELLER_ENTRY_LIST     @"seller/entry/list"      // 商家所在学校楼栋列表
#define HXD_SELLER_BANK_INFO      @"seller/bank/info"       // 银行卡信息
#define HXD_UPLOADBANK            @"seller/bank/update"      // 录入银行卡信息 @"shopowner/bank"
#define HXD_BANK_LIST             @"seller/bank/optionlist" // 获取可选银行列表 // @"shopowner/banklist"

/****************************** 选择地址相关 *****************************/
//location
#define HXS_CITY_LIST                   @"location/city/list"           // 获取城市列表
#define HXS_CITY_SITE_LIST              @"location/city/site/list"      // 获取城市站点列表
#define HXS_DORMENTRY_LIST              @"location/dormentry/list"      // 获取带楼区的楼栋列表
#define HXS_SITE_INFO                   @"location/site/info"           // 站点服务信息
#define HXS_SITE_POSITION               @"location/site/position"       // 获取附近学校
#define HXS_SITE_SEARCH                 @"location/site/search"         // 搜索站点

/****************************** 用户User相关 *****************************/
#define HXD_USER_LOGIN            @"user/login"
#define HXD_USER_PHONE_GETCODE    @"user/phone/getcode"
#define HXD_URDER_PHONE_LOGIN     @"user/phone/login"
#define HXD_USER_REGISTER_GETCODE @"user/register/getcode"         // 注册 获取手机验证码
#define HXD_USER_REGISTER         @"user/register"                 // 注册
#define HXD_USER_REGISTER_CHECKCODE  @"user/register/checkcode"    // 注册 验证码校验

/****************************** 账户安全相关 *****************************/
#define HXD_PWD_STATUSLIST             @"pwd/statuslist"           //当前店长所有状态
#define HXD_PWD_LOGIN_SET              @"pwd/login_set"            //登录密码修改
#define HXD_PWD_PAY_SET                @"pwd/pay_set"              //支付密码修改
#define HXD_PWD_GET_SMSCODE            @"pwd/get_smscode"          //支付密码忘记获取短信验证码
#define HXD_PWD_CHECK_SMSCODE          @"pwd/check_smscode"        //支付密码验证码校验
#define HXD_PWD_SET_BYSMSCODE          @"pwd/pay_set_bysmscode"    //支付密码验证码校验修改

/****************************** 业务相关API  *****************************/

#define HXD_BUSINESS_LIST         @"business/list"              // 首页店长相关业务权限展示
#define HXD_BUSINESS_INFO         @"business/info"              // 获取业务信息
#define HXD_BUSINESS_UPDATE       @"business/update"            // 更新业务信息
#define HXD_BUSINESS_SET_SWITCH   @"business/set_switch"        // 业务相关开关
#define HXD_BUSINESS_SET_STATUS   @"business/setstatus"         // 设置店铺状态 V2.3取消店铺状态了
#define HXD_DORMENTRY_SETLOGO     @"business/setlogo"           // 修改业务对应的logo
#define HXD_BUSINESS_OPEN         @"business/open"              // 业务开通
#define HXD_BUSINESS_APPLY_OPEN   @"dorm/applyBizOpen"          // 创建店铺(创建业务)

#define HXD_NEWBIETASK_QUERY      @"dorm/newbietask/query"      // "创建店铺成功" 页面标志位查询 只有新的店长才显示该页面

/****************************** 零食盒子相关API  *****************************/
// 零食盒管理
#define HXD_BOX_LIST              @"box/list"                   // 店长零食盒列表
#define HXD_BOX_APPROVE           @"box/approve"                // 店长零食盒审批
#define HXD_BOX_APPLY_LIST        @"shopapply/shopList"         // 店长业务申请列表
// 配货相关
#define HXD_BOX_DEFAULT_DELIVERY          @"boxdelivery/getOrderBlank"  // 默认配货单查询
#define HXD_BOX_ALL_DELIVERY              @"boxdelivery/getAllRepos"    // 可配货商品查询
#define HXD_BOX_CONFIRM_DELIVERY          @"boxdelivery/confirm"        // 确认配货
// 盒子详情相关
#define HXD_BOX_INFO                  @"box/info"                       // 店长零食盒详情
#define HXD_BOX_UPDATE                @"box/update"                     // 店长零食盒更新
#define HXD_BOX_USE_RECORD            @"box/userecord"                  // 店长零食盒使用记录
// 清点盒子相关
#define HXD_BOX_REPOS                     @"box/repos"                  // 店长零食盒商品列表
#define HXD_BOX_SEND_BILL                 @"box/sendBill"               // 店长零食盒发送账单
#define HXD_BOX_START_MAKE_INVENTORY      @"box/inventory"              // 开始清点零食盒
#define HXD_BOX_CANCEL_MAKE_INVENTORY     @"box/cancelInventory"        // 取消清点零食盒
// 支付相关
#define HXD_BOX_UNTPAID_BILL                 @"boxpay/getBill"              // 结算中的账单查询(未支付零食列表)
#define HXD_BOX_PAID_UNTOKEN_REPOS           @"boxpay/bill/getUntokenRepos" // 结算中的账单查询(已支付未领取零食明细)
#define HXD_BOX_PAID_GET_ORDERS              @"boxpay/bill/getOrders"       // 结算中的账单查询(已支付订单列表)
#define HXD_BOX_PAID_CASH                    @"boxpay/bill/payCash"         // 现金支付
#define HXD_BOX_PAID_RESULT                  @"boxpay/bill/getPayInfo"      // 结算中的账单查询(查看支付结果)


#define HXD_BOX_PAID_GET_ORDERINFO           @"boxpay/bill/getOrderInfo"    // 结算中的订单查询(已支付订单详情)
#define HXD_BOX_PAY_BOX_RENEW                @"boxpay/boxRenew"  //是否续订

/****************************** 采购下单相关API  *****************************/
// 采购
#define HXD_PURCHASE_SUPPLIERS               @"purchase/suppliers/get"          // 供应商列表查询
#define HXD_PURCHASE_SUPPLIERS_REPO          @"purchase/supplier/repos/get"     // 供应商供货商品列表
#define HXD_PURCHASE_SUPPLIERS_COLLECT       @"purchase/supplier/repo/collect"  // 收藏商品/取消收藏 post
#define HXD_PURCHASE_SUPPLIERS_REPO_DETAIL   @"purchase/supplier/repo/detail"   // 供应商供货商品所有图片和收藏标示
#define HXD_PURCHASE_NEWBIE_PACKAGE_REPO     @"purchase/supplier/packagerepos/get" // 供应商采购包商品列表(新手采购包)
// 下单
#define HXD_PURCHASE_DELIVERY_ADDRESS        @"purchase/delivery/address/get"   // 收货地址查询
#define HXD_PURCHASE_DELIVERY_ADDRESS_SAVE   @"purchase/delivery/address/save"  // 收货地址修改
#define HXD_PURCHASE_COUPONS                 @"purchase/coupons/get"            // 店长可用优惠券
#define HXD_DORM_COUPONS                     @"purchase/dorm/coupons/get"       // 店长所有优惠券
#define HXD_PURCHASE_CREATE_ORDER            @"purchase/order/create"           // 创建采购单
#define HXD_PURCHASE_PAY_ORDER               @"purchase/order/pay"              // 支付采购单
#define HXD_PURCHASE_PAY_ORDER_RESULT        @"purchase/order/payresult"        // 支付结果
// 采购单列表
#define HXD_PURCHASE_ORDER_LIST              @"purchase/order/list"             // 采购单列表
#define HXD_PURCHASE_ORDER_DETAIL            @"purchase/order/detail"           // 采购单详情
#define HXD_PURCHASE_ORDER_RECEIVE           @"purchase/order/receive"          // 采购单收获
#define HXD_PURCHASE_ORDER_CANCEL            @"purchase/order/cancel"           // 采购单收货
#define HXD_PURCHASE_ORDER_COUNT             @"purchase/order/count"            // 夜猫店各种状态采购单的数量

// 余额&充值相关
#define HXD_TRANSACTION_RECORD_LIST          @"dorm/transactionRecordList"      // 获取店长交易记录
#define HXD_TRANSACTION_DETAIL               @"dorm/transactionDetail"          // 获取店长交易记录详情

#define HXD_PAY_DORM_RECHARGE                @"dorm/dormRecharge"               // 店长充值
#define HXD_PAY_DORM_RECHARGE_CALLBACK       @"pay/dormRecharge_back"           // 店长充值回调接口
#define HXD_DORM_AVAILABLE_CASH              @"dorm/availablecash"              // 可提现金额
#define HXD_DORM_WITHDRAWAL                  @"dorm/withdrawal"                 // 店长提现
#define HXD_DORM_CAPITAL_STATUS              @"dorm/capital/status"             // 店长资金状态

#define HXD_MK_WITHDRAW                      @"mkappapi/mk/withdraw"                 // 脉客提现
#define HXD_MK_TRANSACTION_SCHEDULE          @"mkappapi/mk/transaction/schedule"     // 脉客交易记录
#define HXD_MK_SHOW                          @"mkappapi/mk/show"                     // 脉客信息
#define HXD_MK_REGISTER                      @"mkappapi/mk/register"                 // 注册脉客

/****************************** 经营贷相关API  *****************************/
//经营贷
#define HXS_LOAN_DETAILS                     @"finance/loandetails" // 还款计划明细
#define HXS_LOAN_FETCH_INFOR                 @"creditcard/whole/info" // 查询查询信用钱包额度、用户基础信息接口
#define HXS_LOAN_OPEN                        @"creditcard/apply/open" // 金融开通接口
#define HXS_LOAN_ADD_IDENTIFY                @"creditcard/add/identity/info" // 身份信息校验接口
#define HXS_LOAN_ADD_SCHOOL                  @"creditcard/add/school/roll" // 学籍信息校验接口
#define HXS_LOAN_ADD_AUTHRIZE                @"creditcard/authorize/next" // 授权信息校验接口
#define HXS_LOAN_FETCH_URL                   @"creditcard/agreement/url" // 获取协议地址
#define HXS_LOAN_ADD_SCHOOL_NEW              @"creditcard/add/school/roll/new" // 新生学籍信息校验接口<经营贷专用>
#define HXS_LOAN_VERITYCODE                  @"creditcard/bank_card/verify_code/send" // 发送手机验证码
#define HXS_LOAN_ADD_BANK                    @"creditcard/bank_card/update" // 银行信息校验接口
#define HXS_LOAN_FETCH_BANKLIST              @"creditcard/bank_list" // 银行列表
#define HXS_LOAN_ACCOUNT_UPDATE              @"creditcard/account/pay_password/update" // 设置或者修改密码
#define HXS_LOAN_PHOTO_UPLOAD                @"creditcard/upload/picture/ios" // 上传图片
#define HXS_LOAN_ADD_CONTACTS                @"creditcard/add/contacts/info" // 通讯录授权
#define HXS_LOAN_ADD_POSITION                @"creditcard/add/position/info" // 定位授权
#define HXS_LOAN_ADD_RECORDS                 @"creditcard/add/call/records" // 通话记录授权
#define HXS_LOAN_FETCH_AUTH_STATUS           @"creditcard/auth_status" // 获取授权状态
#define HXS_LOAN_UPDATE_EMERGENCY            @"creditcard/emergency_contacts_update" // 填写紧急联系人
#define HXS_LOAN_FETCH_EMERGENCY             @"creditcard/query/emergency/contact" // 获取紧急联系人

/****************************** 账户安全相关 *****************************/
#define HXS_REPO_DORMITEM_LIST                        @"repo/dormitem/list"        // 商品列表
#define HXS_REPO_DORMITEM_SETSTATUS                   @"repo/dormitem/setstatus"   // 商品上下架
#define HXS_REPO_DORMITEM_ADJUSTPRICE                 @"repo/dormitem/adjustprice" // 商品价格修改

/****************************** 超级店长相关 *****************************/
#define HXS_SUPERDORM_PAYINFO                         @"superdorm/payinfo"        // 获得超级店长付款金额和订单ID
#define HXS_SUPERDORM_REGISTER                        @"superdorm/register"       // 超级店长支付完成后的邀请码
#define HXS_SUPERDORM_INFO                            @"superdorm/info"           // 超级店长信息
#define HXS_SUPERDORM_FOLLOWERINFO                    @"superdorm/followerinfo"   // 已经发展的店长的信息
#define HXS_SUPERDORM_BALANCEPAY                      @"superdorm/balancepay"     // 申请成为店长支付金额

/****************************** 店铺相关统计 *****************************/
#define HXD_BOXSHOP_STATISTICS                        @"dorm/boxshop/stastics"    // 店长零食盒销售统计
#define HXD_DORMSHOP_STATISTICS                       @"dorm/yemaoshop/stastics"  // 店长夜猫店统计

/****************************** 收银台相关API  *****************************/

#define HXD_FACETOFACEHISTORY_LIST  @"order/cashierlist" //历史订单(收银台订单)


// online pay
#define HXD_PAY_ONLINE_PAYMENT              @"pay/onlinePayment"           // 微信刷卡支付(订单详情中)
#define HXD_PAY_ONLINE_ORDER_FAILED_RETRY   @"pay/onlineOrderFailedRetry"  // 微信刷卡支付失败尝试(订单详情中)
#define HXD_PAY_CANCEL                      @"pay/cancel"                  // 微信刷卡支付取消(收银台)
#define HXD_PAY_ONLINE_CASHIER_FAILED_RETRY @"pay/onlineCashierFailedRetry"// 失败输入密码后重试(收银台)
#define HXD_PAY_ORDER_CANCEL                @"pay/ordercancel"             // 微信刷卡支付取消(订单详情)
#define HXD_PAY_DEFAULT                     @"pay/default"                 // 默认支付－（支付宝二维码）用生成支付宝二维码支付的相关信息
#define HXD_PAY_PAYMENT                     @"pay/payment"                 // 支付
#define HXD_PAY_IN_CASH                     @"pay/payInShop"               // 收银台 现金收款

/****************************** 消息中心相关API  *****************************/

#define HXD_SELLER_NOTICE_UNREADCOUNT       @"seller/mc/unreadcount"        // 消息中心未读数量
#define HXD_SELLER_NOTICE_LIST              @"seller/mc/notice/list"        // 公告列表
#define HXD_SELLER_NOTICE_DETAIL            @"seller/mc/notice/detail"      // 公告详情
#define HXD_SELLER_MESSAGE_LIST             @"seller/mc/message/list"       // 消息列表
#define HXD_NOTICE_ACCESSINFO_UPDATE        @"seller/mc/notice/accessinfo/update" // 公告访问信息更新 标记是否已读


// 跨楼配送
#define HXD_ENTRY_UPDATE @"entry/update"
#define HXD_ENTRY_LIST   @"entry/list"

//请求参数key
#define SYNC_REQUEST_TOKEN              @"token"
#define SYNC_REQUEST_DEVICE_ID          @"device_id"
#define SYNC_REQUEST_ORDER_ID           @"order_id"
#define SYNC_REQUEST_SHOP_TYPE          @"shop_type"
#define SYNC_REQUEST_DORM_ID            @"dorm_id"
#define SYNC_REQUEST_ORDER_TYPE         @"type"
#define SYNC_REQUEST_ORDER_PAGE         @"page"
#define SYNC_REQUEST_ORDER_PAGE_SIZE    @"page_size"
#define SYNC_REQUEST_SHOP_ID            @"shop_id"
#define SYNC_REQUEST_NAME               @"name"
#define SYNC_REQUEST_NOTICE             @"notice"
#define SYNC_REQUEST_SIGNATURES         @"signatures"
#define SYNC_REQUEST_FREESHIP_AMOUNT    @"freeship_amount"
#define SYNC_REQUEST_ISCF_DELIVERY      @"iscf_delivery"
#define SYNC_REQUEST_DORMENTRY_STATUS   @"status"
#define SYNC_DEVICE_ID                  @"device_id"
#define SYNC_DEVICE_TOKEN               @"device_token"
#define SYNC_SYSTEM_VERSION             @"system_version"
#define SYNC_APP_SOURCE_TYPE            @"app_source_type"


//全局返回response的字典key
#define SYNC_RESPONSE_MSG               @"msg"
#define SYNC_RESPONSE_STATUS            @"status"
#define SYNC_RESPONSE_DATA              @"data"
#define SYNC_RESPONSE_TOKEN             @"token"
#define SYNC_RESPONSE_OPERATION_STATUS  @"status"

//店长信息 API response key
#define SYNC_RESPONSE_DORM_ADDRESS         @"delivery_address"
#define SYNC_RESPONSE_DORM_ZHIFUBAO        @"zhifubao"
#define SYNC_RESPONSE_DORM_NOTICE          @"notice"
#define SYNC_RESPONSE_DORM_NAME            @"name"
#define SYNC_RESPONSE_DORM_SIGNATURES      @"signatures"
#define SYNC_RESPONSE_DORM_FREESHIP_AMOUNT @"freeship_amount"
#define SYNC_RESPONSE_DORM_BALANCE         @"balance"
#define SYNC_RESPONSE_DORM_ID              @"dorm_id"

//Orders API response key
#define SYNC_RESPONSE_ORDERS            @"orders"

//用户自定义相关账号名称
#define HXD_USERDEFAULTS_LOGIN_USERNAME @"LoginUserName"


//一般的搜索列表返回的默认每页数量
#define defaultPageSize 50
//#define MESSAGE_CODE_WAITING_TIME  60

#endif
