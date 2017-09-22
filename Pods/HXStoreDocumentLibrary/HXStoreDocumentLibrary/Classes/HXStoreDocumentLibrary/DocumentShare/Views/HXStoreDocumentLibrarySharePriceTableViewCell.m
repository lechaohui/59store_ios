//
//  HXStoreDocumentLibrarySharePriceTableViewCell.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibrarySharePriceTableViewCell.h"

@interface HXStoreDocumentLibrarySharePriceTableViewCell()

@end

@implementation HXStoreDocumentLibrarySharePriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init

- (void)initDocumentLibrarySharePriceCellWithPriceNum:(NSDecimalNumber *)priceNum
{
    [_priceTextField setText:@""];
    
    [_priceTextField setText:priceNum != nil ? priceNum.stringValue : @""];
}

@end
