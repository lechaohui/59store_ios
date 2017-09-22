//
//  HXStoreDocumentLibrarySharePriceTableViewCell.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXStoreDocumentLibrarySharePriceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

- (void)initDocumentLibrarySharePriceCellWithPriceNum:(NSDecimalNumber *)priceNum;

@end
