//
//  HXWebService.h
//  Pods
//
//  Created by ArthurWang on 16/6/6.
//
//

#import <Foundation/Foundation.h>

#import "HXWebServiceModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface HXWebService : NSObject

- (instancetype)createWebServiceWithUserAgent:(NSString *)userAgentStr
                                     deviceID:(NSString *)deviceIDStr;

- (void)updateRequestSerializerHeadFieldWithDic:(NSDictionary *)dic model:(HXWebServiceModel *)model;

- (NSURLSessionDataTask *)postWithWebServiceModel:(HXWebServiceModel *)model
                                       parameters:(NSDictionary * _Nullable)parameters
                                         progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)getWithWebServiceModel:(HXWebServiceModel *)model
                                      parameters:(NSDictionary * _Nullable)parameters
                                        progress:(nullable void (^)(NSProgress * _Nonnull))downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)uploadWithWebServiceModel:(HXWebServiceModel *)model
                                         parameters:(NSDictionary * _Nullable)parameters
                                      formDataArray:(NSArray *)formDataArray
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask * )putWithWebServiceModel:(HXWebServiceModel *)model
                                       parameters:(NSDictionary * _Nullable)parameters
                                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)deleteWithWebServiceModel:(HXWebServiceModel *)model
                                         parameters:(NSDictionary * _Nullable)parameters
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
NS_ASSUME_NONNULL_END

@end
