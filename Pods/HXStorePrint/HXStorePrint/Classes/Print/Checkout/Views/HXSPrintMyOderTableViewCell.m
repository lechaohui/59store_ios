//
//  HXSMyOderTableViewCell.m
//  store
//
//  Created by J.006 on 16/8/25.
//  Copyright (c) 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintMyOderTableViewCell.h"
#import "HXSMyPrintOrderItem.h"

//others
#import "HXSPrintHeaderImport.h"
#import "HXSPrintModel.h"

@interface HXSPrintMyOderTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView    *imageImageVeiw;
@property (nonatomic, weak) IBOutlet UILabel        *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel        *printSettingLabel;
@property (weak, nonatomic) IBOutlet UILabel        *singlePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel        *quantityLabel;

@end

@implementation HXSPrintMyOderTableViewCell


- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}


#pragma mark - Public Methods

-(void)setPrintItem:(HXSMyPrintOrderItem *)printItem
{
    _printItem = printItem;
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self matchingImageView];
    self.titleLabel.text = printItem.fileNameStr ? printItem.fileNameStr:@"";
    
    self.printSettingLabel.text = printItem.specificationsStr ? printItem.specificationsStr:@"";
    
    self.singlePriceLabel.text = [NSString stringWithFormat:@"￥%.2f",printItem.priceDoubleNum.doubleValue];
    
    self.quantityLabel.text = [NSString stringWithFormat:@"x%d",printItem.quantityIntNum.intValue];
}

-(void)matchingImageView
{
    if([_printItem.fileNameStr.lowercaseString hasSuffix:@".doc"]||[_printItem.fileNameStr.lowercaseString hasSuffix:@".docx"]) {
        [self.imageImageVeiw setImage:[HXSPrintModel imageFromNewName:@"img_print_word"]];
    } else if([_printItem.fileNameStr.lowercaseString hasSuffix:@".pdf"]) {
        [self.imageImageVeiw setImage:[HXSPrintModel imageFromNewName:@"img_print_pdf"]];
    } else if([_printItem.fileNameStr.lowercaseString hasSuffix:@".pdf"]) {
        [self.imageImageVeiw setImage:[HXSPrintModel imageFromNewName:@"img_print_pdf"]];
    } else if([_printItem.fileNameStr.lowercaseString hasSuffix:@".ppt"]||[_printItem.fileNameStr.lowercaseString hasSuffix:@".pptx"]) {
        [self.imageImageVeiw setImage:[HXSPrintModel imageFromNewName:@"img_print_ppt"]];
    } else if([_printItem.fileNameStr.lowercaseString hasSuffix:@".jpg"]
              || [_printItem.fileNameStr.lowercaseString hasSuffix:@".jpeg"]
              || [_printItem.fileNameStr.lowercaseString hasSuffix:@".png"]) {
        [self.imageImageVeiw sd_setImageWithURL:[NSURL URLWithString:_printItem.originPathStr]
                               placeholderImage:[HXSPrintModel imageFromNewName:@"img_print_picture"]];
    } else {
        [self.imageImageVeiw setImage:[HXSPrintModel imageFromNewName:@"img_print_default"]];
    }
}

@end
