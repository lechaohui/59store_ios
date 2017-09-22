//
//  HXStoreDocumentLibraryShareTagSettingTableViewCell.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryShareTagSettingTableViewCell.h"

//other
#import "HXStoreDocumentLibraryImport.h"

@implementation HXStoreDocumentLibraryShareTagSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - init

- (void)initDocumentLibraryShareTagSettingTableViewCellWithTags:(NSString *)tagsStr
{
    if(tagsStr
       && ![[tagsStr trim] isEqualToString:@""]) {
        [_inputTextField setText:tagsStr];
    }
    
    _bgView.layer.cornerRadius = 3;
    _bgView.layer.borderColor = [UIColor colorWithRGBHex:0xE1E2E3].CGColor;
    _bgView.layer.borderWidth = 0.5;
    [_bgView.layer setMasksToBounds:YES];
}

@end
