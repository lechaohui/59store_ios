//
//  HXStoreDocumentLibraryImport.h
//  Pods
//
//  Created by J006 on 16/8/24.
//
//

#ifndef HXStoreDocumentLibraryImport_h
#define HXStoreDocumentLibraryImport_h

#import "UIColor+Extensions.h"
#import "Color+Image.h"
#import "HXMacrosUtils.h"
#import "UIScrollView+HXSPullRefresh.h"
#import "HXMacrosDefault.h"
#import "HXMacrosEnum.h"
#import "HXSMediator+AccountModule.h"
#import "ApplicationSettings.h"
#import "UIViewController+Extensions.h"
#import "HXSBaseNavigationController.h"
#import "UIView+Extension.h"
#import "MBProgressHUD+HXS.h"
#import "HXSCustomAlertView.h"
#import "NSString+Verification.h"
#import "HXSLoadingView.h"
#import "HXSUsageManager.h"
#import "HXBaseJSONModel.h"
#import "HXStoreWebServiceErrorCode.h"
#import "HXStoreWebService.h"
#import "HXSShopEntity.h"
#import "NSDate+Extension.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "HXSMediator.h"
#import "HXSMediator+RootViewController.h"
#import "HXSUserAccount.h"
#import "HXSBuildingEntry.h"
#import "OpenUDID.h"
#import "HXSSite.h"
#import "NSString+Addition.h"
#import "HXAppDeviceHelper.h"
#import "HXSShopManager.h"
#import "UIScrollView+SVInfiniteScrolling.h"

#define kHXSDocumentLibraryShowAlertForWifi @"kHXSDocumentLibraryShowAlertForWifi"

#define kDocumentModelUpdated @"kDocumentModelUpdated"

#define HXS_DOCUMENT_LIBRARY_CATEGORY               @"library/category/listree" // 获取一二级分类列表:（59文库页面）
#define HXS_DOCUMENT_LIBRARY_DOCLIST                @"library/doc/list" // 获取文章列表
#define HXS_DOCUMENT_LIBRARY_DOCSTAR                @"library/doc/star" // 收藏/取消收藏
#define HXS_DOCUMENT_LIBRARY_FETCH_STARDOC          @"library/doc/starlist" // 收藏列表
#define HXS_DOCUMENT_LIBRARY_FINDINGS_LIST          @"library/searching/findings" // 获取发现内容列表
#define HXS_DOCUMENT_LIBRARY_EXCHANGE_LIST          @"library/searching/exchange" // 换一换接口
#define HXS_DOCUMENT_LIBRARY_SEARCH_HOTWORDS        @"library/searching/hotwords" // 换一换接口
#define HXS_DOCUMENT_LIBRARY_SEARCH_LIST            @"library/doc/searching" // 搜索接口
#define HXS_DOCUMENT_LIBRARY_FETCH_DOCMODEL         @"library/doc/info" // 获取单个文档信息接口（文档阅读页面）
#define HXS_DOCUMENT_LIBRARY_STARREAD               @"library/doc/staread" // 用户收藏文档生成阅读记录接口

#define HXS_PRINT_DOCUMENT_LIBRARY_SHARED           @"library/doc/shared" //店长私藏／用户分享文档列表
#define HXS_PRINT_DOCUMENT_LIBRARY_BUYED            @"library/new/doc/list" //已购文档列表接口
#define HXS_PRINT_DOCUMENT_LIBRARY_UPLOADSAHRE      @"library/new/doc/share" //文档分享
#define HXS_PRINT_DOCUMENT_LIBRARY_CANCELUPLOADSAHRE @"library/new/doc/cancel/share" //文档取消分享
#define HXS_PRINT_DOCUMENT_LIBRARY_DOCBUY           @"library/new/doc/buy" //购买文档接口

#endif /* HXStoreDocumentLibraryImport_h */
