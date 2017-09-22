//
//  HXStoreDocumentLibraryShareTagsTableViewCell.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryShareTagsTableViewCell.h"
#import "UIColor+Extensions.h"

@interface HXStoreDocumentLibraryShareTagsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *tagsContentLabel;

@end

@implementation HXStoreDocumentLibraryShareTagsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init

- (void)initDocumentLibraryShareTagsCellWithDocModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    if(docModel.tagsStr) {
        [_tagsContentLabel setText:docModel.tagsStr];
        [_tagsContentLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    } else {
        [_tagsContentLabel setText:@"请选择"];
        [_tagsContentLabel setTextColor:[UIColor colorWithRGBHex:0xCCCCCC]];
    }
}

@end
