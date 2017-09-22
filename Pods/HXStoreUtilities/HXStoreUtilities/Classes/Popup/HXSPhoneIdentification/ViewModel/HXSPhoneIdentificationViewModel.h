//
//  HXSPhoneIdentificationViewModel.h
//  Pods
//
//  Created by ArthurWang on 16/9/1.
//
//

#import <Foundation/Foundation.h>

#import "HXStoreWebService.h"

@interface HXSPhoneIdentificationViewModel : NSObject

+ (void)sendAuthCodeWithPhone:(NSString *)phoneStr
                     complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *authInfo))block;

+ (void)verifAuthCodeWithPhone:(NSString *)phoneStr
                          code:(NSString *)codeStr
                      complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *authInfo))block;


@end
