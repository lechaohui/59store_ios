//
//  HXStoreDocumentLibraryPageTableViewCell.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryPageTableViewCell.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//others
#import "NSDate+Extension.h"
#import "UIButton+HXSUIButoonHitExtensions.h"
#import "NSDecimalNumber+StringTools.h"

@interface HXStoreDocumentLibraryPageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView    *docIconImageView;
@property (weak, nonatomic) IBOutlet UILabel        *docNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *docProvisionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel        *readCountsLabel;
@property (weak, nonatomic) IBOutlet UILabel        *scoreAverageLabel;
@property (weak, nonatomic) IBOutlet UILabel        *priceLabel;

@end

@implementation HXStoreDocumentLibraryPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init

- (void)initPageTableViewCellWithMode:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    [self matchingImageViewWithModel:docModel];
    
    [_docNameLabel setText:docModel.docTitleStr == nil ? @"" : docModel.docTitleStr];
    
    [_docProvisionNameLabel setText:docModel.docProvisionNameStr == nil ? @"" : docModel.docProvisionNameStr];
    
    [self settingTimeLabel:docModel];
    
    [_readCountsLabel setText:[NSString stringWithFormat:@"%zd次浏览",docModel.readCountNum == nil ? 0 : [docModel.readCountNum integerValue]]];
    
    [_scoreAverageLabel setText:[NSString stringWithFormat:@"%@分",docModel.scoreAverageNum == nil ? @"0" : [docModel.scoreAverageNum stringValue]]];
    
    [self settingStarImageView:docModel];
    [_starButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];//增加触摸热点范围
    
    [self settingPriceLabel:docModel];
}

/**
 *  设置时间
 *
 *  @param docModel
 */
- (void)settingTimeLabel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *mydate = [NSDate dateWithTimeIntervalSince1970:[docModel.createTimestampStr integerValue]];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:mydate] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:mydate]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:mydate] integerValue];
    
    NSString *timeDateStr = [NSString stringWithFormat:@"%zd年%zd月%zd日",currentYear,currentMonth,currentDay];
    
    [_createTimeLabel setText:docModel.createTimestampStr == nil ? @"" : timeDateStr];
}

- (void)settingPriceLabel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    if([docModel.typeNum isEqualToNumber:@(HXSLibraryDocumentTypeBuy)]
       && docModel.priceDecNum) {
        [_priceLabel setHidden:NO];
        NSDecimalNumber *priceNum = [docModel.priceDecNum twoDecimalPlacesDecimalNumber];
        [_priceLabel setText:[NSString stringWithFormat:@"¥%@",priceNum.stringValue]];
    } else {
        [_priceLabel setHidden:YES];
    }
}

/**
 *  设置收藏按钮
 *
 *  @param docModel
 */
- (void)settingStarImageView:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    HXStoreDocumentLibraryViewModel *viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    
    if([docModel.isFavorNum boolValue]) {
        [_starButton setImage:[viewModel imageFromNewName:@"ic_star_big"]
                     forState:UIControlStateNormal];
    } else {
        [_starButton setImage:[viewModel imageFromNewName:@"ic_star_big_outline"]
                     forState:UIControlStateNormal];
    }
}

/**
 *  根据文档原始格式匹配图片icon
 *
 *  @param docModel
 */
- (void)matchingImageViewWithModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    HXStoreDocumentLibraryViewModel *viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    
    [viewModel setImageForIconImageView:_docIconImageView withModel:docModel];
}

@end
