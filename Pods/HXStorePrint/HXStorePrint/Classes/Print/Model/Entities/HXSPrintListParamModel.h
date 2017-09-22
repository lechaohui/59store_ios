//
//  HXSPrintListParamModel.h
//  Pods
//
//  Created by J006 on 16/9/28.
//
//

#import <Foundation/Foundation.h>

@interface HXSPrintListParamModel : NSObject

/** 类型名称 */
@property (nonatomic ,strong) NSNumber   *offset;
@property (nonatomic ,strong) NSNumber   *limit;
@property (nonatomic ,strong) NSNumber   *sort;

+ (instancetype)createDeafultParamModel;

@end
