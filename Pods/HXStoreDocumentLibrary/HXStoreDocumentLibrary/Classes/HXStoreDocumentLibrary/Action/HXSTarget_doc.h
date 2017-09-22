//
//  HXSTarget_DocumentLibrary.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/26.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HXSTarget_doc : NSObject

/** 文库首页 */
// hxstore://doc/library
- (UIViewController *)Action_library:(NSDictionary *)paramsDic;

@end
