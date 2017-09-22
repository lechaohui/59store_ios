//
//  HXStoreDocumentLibraryBuyedTableViewCell.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/26.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryBuyedTableViewCell.h"
#import "HXStoreDocumentLibraryViewModel.h"

//others
#import "NSDecimalNumber+StringTools.h"

@interface HXStoreDocumentLibraryBuyedTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView    *docIconImageView;
@property (weak, nonatomic) IBOutlet UILabel        *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel        *docNameLabel;

@end

@implementation HXStoreDocumentLibraryBuyedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init

- (void)initDocumentLibraryBuyedCellWithDocModel:(HXStoreDocumentLibraryDocumentBuyedModel *)docModel
{
    [self matchingImageViewWithModel:docModel];
    
    [_docNameLabel setText:docModel.docTitleStr == nil ? @"" : docModel.docTitleStr];
    
    [self settingPriceLabel:docModel];
}

- (void)settingPriceLabel:(HXStoreDocumentLibraryDocumentBuyedModel *)docModel
{
    _priceLabel.layer.cornerRadius = 3;
    _priceLabel.layer.borderColor = [UIColor colorWithRGBHex:0xF9A502].CGColor;
    _priceLabel.layer.borderWidth = 0.5;
    [_priceLabel.layer setMasksToBounds:YES];
    NSDecimalNumber *priceNum = [docModel.priceDecNum twoDecimalPlacesDecimalNumber];
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",priceNum.stringValue];
    
    [_priceLabel setText:priceStr];
    [_priceLabel setBackgroundColor:[UIColor colorWithRGBHex:0xfff1d6]];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(0, [attributeString length])];
    [_priceLabel setAttributedText:attributeString];
}

/**
 *  根据文档原始格式匹配图片icon
 *
 *  @param docModel
 */
- (void)matchingImageViewWithModel:(HXStoreDocumentLibraryDocumentBuyedModel *)docModel
{
    HXStoreDocumentLibraryViewModel *viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    
    if([docModel.docSuffixStr hasSuffix:@"doc"]
       || [docModel.docSuffixStr hasSuffix:@"docx"]) {
        [_docIconImageView setImage:[viewModel imageFromNewName:@"img_print_word_small"]];
    } else if([docModel.docSuffixStr hasSuffix:@"pdf"]) {
        [_docIconImageView setImage:[viewModel imageFromNewName:@"img_print_pdf_small"]];
    } else if([docModel.docSuffixStr hasSuffix:@"ppt"]
              || [docModel.docSuffixStr hasSuffix:@"pptx"]) {
        [_docIconImageView setImage:[viewModel imageFromNewName:@"img_print_ppt_small"]];
    } else {
        [_docIconImageView setImage:[viewModel imageFromNewName:@"img_print_pdf_small"]];
    }
}

@end
