//
//  HXStoreDocumentLibraryPageTableViewCell.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXStoreDocumentLibraryDocumentModel.h"

@interface HXStoreDocumentLibraryPageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton       *starButton;

- (void)initPageTableViewCellWithMode:(HXStoreDocumentLibraryDocumentModel *)docModel;

@end
