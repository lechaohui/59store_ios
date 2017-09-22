//
//  HXStoreDocumentLibraryShareTagSettingTableViewCell.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXStoreDocumentLibraryShareTagSettingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView         *bgView;
@property (weak, nonatomic) IBOutlet UIButton       *addButton;
@property (weak, nonatomic) IBOutlet UIButton       *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField    *inputTextField;


- (void)initDocumentLibraryShareTagSettingTableViewCellWithTags:(NSString *)tagsStr;

@end
