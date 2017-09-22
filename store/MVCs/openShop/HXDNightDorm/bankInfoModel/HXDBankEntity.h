//
//  HXDBankEntity.h
//  59dorm
//
//  Created by J006 on 16/3/2.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXDBankEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *bankIDStr;//"bank_id":str,编号
@property (nonatomic, strong) NSString *bankNameStr;//"bank_name":str,银行名称
@property (nonatomic, strong) NSString *bankImageStr;//"bank_image":str//银行图标

@end
