//
//  HXSPhoneIdentificationViewModel.m
//  Pods
//
//  Created by ArthurWang on 16/9/1.
//
//

#import "HXSPhoneIdentificationViewModel.h"

#import "NSString+Verification.h"
#import "HXSUserBasicInfo.h"
#import "HXMacrosEnum.h"
#import "HXSAccountManager.h"
#import "HXSUserAccount.h"
#import "HXMacrosUtils.h"
#import "HXMacrosDefault.h"
#import "HXSDeviceUpdateRequest.h"

@implementation HXSPhoneIdentificationViewModel

+ (void)sendAuthCodeWithPhone:(NSString *)phoneStr
                     complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *authInfo))block
{
    NSString *verifySrc = @"app_login";
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [phoneStr compressBlank], @"phone",
                              verifySrc, @"src", nil];
    
    [HXStoreWebService getRequest:HXS_VERIFICATION_CODE_REQUEST
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError == status) {
                                  block(status, msg, data);
                              } else {
                                  block(status, msg, nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

+ (void)verifAuthCodeWithPhone:(NSString *)phoneStr
                          code:(NSString *)codeStr
                      complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *authInfo))block
{
    NSString *typeStr = @"app_login";
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              phoneStr, @"phone",
                              codeStr,  @"code",
                              typeStr, @"src",nil];
    
    [HXStoreWebService getRequest:HXS_VERIFICATION_CODE_VERIFY
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError == status) {
                                  HXSUserBasicInfo *basicInfo = [[HXSUserBasicInfo alloc] initWithServerDic:data];
                                  [HXSAccountManager sharedManager].accountType = kHXSUnknownAccount;
                                  
                                  [HXSUserAccount currentAccount].userID = basicInfo.uid;
                                  [[HXSUserAccount currentAccount] loadUserInfo:basicInfo];
                                  
                                  if ([typeStr isEqualToString:@"app_login"]) {
                                      BEGIN_MAIN_THREAD
                                      [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCompleted object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:status], @"code",@"登录成功",@"msg", nil]];
                                      
                                      [[HXSDeviceUpdateRequest currentRequest] startUpdate];
                                      END_MAIN_THREAD
                                  }
                                  
                                  block(status, msg, data);
                              } else {
                                  block(status, msg, nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

@end
