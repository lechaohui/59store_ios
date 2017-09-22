//
//  HXStoreDocumentLibraryShareTableViewCell.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryShareTableViewCell.h"

#import "HXStoreDocumentLibraryViewModel.h"

@interface HXStoreDocumentLibraryShareTableViewCell()

@property (nonatomic, strong) HXStoreDocumentLibraryViewModel   *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView                *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel                    *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView                *docIconImageView;
@property (nonatomic, strong) HXStoreDocumentLibraryDocumentModel   *docModel;

@end

@implementation HXStoreDocumentLibraryShareTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - init

- (void)initDocumentLibraryShareCellWithDocModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    _docModel = docModel;
    
    [self settingSelectImageViewWithModel:docModel];
    
    [self matchingImageViewWithModel:docModel];
    
    [_contentLabel setText:docModel.docTitleStr == nil ? @"" : docModel.docTitleStr];
}

/**
 *  根据文档原始格式匹配图片icon
 *
 *  @param docModel
 */
- (void)matchingImageViewWithModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    if([docModel.docSuffixStr hasSuffix:@"doc"]
       || [docModel.docSuffixStr hasSuffix:@"docx"]) {
        [_docIconImageView setImage:[self.viewModel imageFromNewName:@"img_print_word_small"]];
    } else if([docModel.docSuffixStr hasSuffix:@"pdf"]) {
        [_docIconImageView setImage:[self.viewModel imageFromNewName:@"img_print_pdf_small"]];;
    } else if([docModel.docSuffixStr hasSuffix:@"ppt"]
              || [docModel.docSuffixStr hasSuffix:@"pptx"]) {
        [_docIconImageView setImage:[self.viewModel imageFromNewName:@"img_print_ppt_small"]];
    } else {
        [_docIconImageView setImage:[self.viewModel imageFromNewName:@"img_print_pdf_small"]];
    }
}

- (void)settingSelectImageViewWithModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    if (docModel.isShowTagsAndPrice) {
        self.checkImageView.image = [self.viewModel imageFromNewName:@"ic_choose_selected"];
    } else {
        self.checkImageView.image = [self.viewModel imageFromNewName:@"ic_choose_normal"];
    }
}

#pragma mark - Getter

- (HXStoreDocumentLibraryViewModel *)viewModel
{
    if(nil == _viewModel) {
        _viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _viewModel;
}

@end
