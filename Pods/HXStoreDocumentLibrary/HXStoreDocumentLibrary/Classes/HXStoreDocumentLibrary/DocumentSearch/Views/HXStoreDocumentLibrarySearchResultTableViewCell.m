//
//  HXStoreDocumentLibrarySearchResultTableViewCell.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/7.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibrarySearchResultTableViewCell.h"
#import "HXStoreDocumentSearchViewModel.h"

@interface HXStoreDocumentLibrarySearchResultTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;

@end

@implementation HXStoreDocumentLibrarySearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init

- (void)initDocumentLibrarySearchResultTableViewCellWithType:(kDocumentSearchResultCellType)type
                                                    andTitle:(NSString *)titleStr
{
    HXStoreDocumentSearchViewModel *model = [[HXStoreDocumentSearchViewModel alloc]init];
    
    switch (type) {
        case kDocumentSearchResultCellTypeHistory: {
            
            [_iconImageView setHidden:NO];
            [_iconImageView setImage:[model imageFromNewName:@"ic_schedule"]];
            [_titleLabel setText:titleStr == nil ? @"" : titleStr];
            
            break;
        }
        case kDocumentSearchResultCellTypeRecommend: {
            
            [_iconImageView setHidden:NO];
            [_iconImageView setImage:[model imageFromNewName:@"ic_access_tuijian"]];
            [_titleLabel setText:titleStr == nil ? @"" : titleStr];
            
            break;
        }
        case kDocumentSearchResultCellTypeMain: {
            
            [_iconImageView setHidden:YES];
            [_titleLabel setText:titleStr == nil ? @"" : titleStr];
            
            break;
        }
    }
}


@end
