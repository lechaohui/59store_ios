//
//  HXSPrintListParamModel.m
//  Pods
//
//  Created by J006 on 16/9/28.
//
//

#import "HXSPrintListParamModel.h"

@implementation HXSPrintListParamModel

+ (instancetype)createDeafultParamModel
{
    HXSPrintListParamModel *model = [[HXSPrintListParamModel alloc]init];
    model.offset = @(0);
    model.limit  = @(10);
    model.sort   = @(7);
    
    return model;
}

@end
