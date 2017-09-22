//
//  HXStoreDocumentLibraryModel.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/7.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

//view
#import "HXSShareView.h"

#import "HXStoreDocumentLibraryViewModel.h"
#import "HXStoreDocumentSearchViewModel.h"
#import "HXStoreDocumentLibraryImport.h"
#import "HXStoreDocumentLibraryPersistencyManger.h"

@implementation HXStoreDocumentLibraryViewModel

#pragma mark - networking

- (void)fetchDocumentCategoryListWithOffset:(NSNumber *)offset
                                   andLimit:(NSNumber *)limit
                                   Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryCategoryListModel *> *modelList))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              limit,             @"limit",
                              offset,            @"offset",
                              nil];
    
    [HXStoreWebService getRequest:HXS_DOCUMENT_LIBRARY_CATEGORY
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              NSMutableArray *resultArr = [NSMutableArray new];
                              
                              if (DIC_HAS_ARRAY(data, @"category")) {
                                  NSArray *entriesArr = [data objectForKey:@"category"];
                                  
                                  for (NSDictionary *dic in entriesArr) {
                                      HXStoreDocumentLibraryCategoryListModel *model = [HXStoreDocumentLibraryCategoryListModel objectFromJSONObject:dic];
                                      
                                      [resultArr addObject:model];
                                  }
                                  block(status, msg, resultArr);
                                  return;
                              }
                              block(status, msg, nil);
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

- (void)fetchDocumentListWithParamModel:(HXStoreDocumentLibraryDocListParamModel *)paramModel
                               Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                paramModel.secondCategoryIdStr,  @"second_category_id",
                              paramModel.docIdStr == nil ? @"" : paramModel.docIdStr,             @"doc_id",
                                paramModel.offsetNum,            @"offset",
                                paramModel.limitNum,             @"limit",
                                paramModel.sortNum,              @"sort",
                                nil];
    
    [HXStoreWebService getRequest:HXS_DOCUMENT_LIBRARY_DOCLIST
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              NSMutableArray *resultArr = [NSMutableArray new];
                              
                              if (DIC_HAS_ARRAY(data, @"doc")) {
                                  NSArray *entriesArr = [data objectForKey:@"doc"];
                                  
                                  for (NSDictionary *dic in entriesArr) {
                                      HXStoreDocumentLibraryDocumentModel *model = [HXStoreDocumentLibraryDocumentModel objectFromJSONObject:dic];
                                      
                                      [resultArr addObject:model];
                                  }
                                  block(status, msg, resultArr);
                                  return;
                              }
                              block(status, msg, nil);
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

- (void)fetchDocumentModelWithDocId:(NSString *)docIdStr
                           Complete:(void (^)(HXSErrorCode code, NSString *message, HXStoreDocumentLibraryDocumentModel *docModel))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              docIdStr,             @"doc_id",
                              nil];
    
    [HXStoreWebService getRequest:HXS_DOCUMENT_LIBRARY_FETCH_DOCMODEL
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              if (data) {
                                  HXStoreDocumentLibraryDocumentModel *model = [HXStoreDocumentLibraryDocumentModel objectFromJSONObject:data];
                                  
                                  HXStoreDocumentSearchViewModel *searchViewModel = [[HXStoreDocumentSearchViewModel alloc]init];
                                  NSString *newfileName = [NSString stringWithFormat:@"%@.pdf",[searchViewModel createPDFNameFromSourceName:model.docTitleStr]];
                                  model.pdfNameStr = newfileName;
                                  block(status, msg, model);
                                  return;
                              }
                              block(status, msg, nil);
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

- (void)updateDocumentStarWithDocId:(NSString *)docIdStr
                            andtype:(NSNumber *)starType
                           Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL success))block;

{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              docIdStr,             @"doc_id",
                              starType,             @"type",
                              nil];
    
    [HXStoreWebService getRequest:HXS_DOCUMENT_LIBRARY_DOCSTAR
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError == status) {
                                  block(status, msg, YES);
                                  return ;
                              }
                              block(status, msg, NO);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, NO);
                          }];

}

- (void)fetchStarDocumentListWithOffset:(NSNumber *)offset
                               andLimit:(NSNumber *)limit
                               Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              limit,             @"limit",
                              offset,            @"offset",
                              nil];
    
    [HXStoreWebService getRequest:HXS_DOCUMENT_LIBRARY_FETCH_STARDOC
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              NSMutableArray *resultArr = [NSMutableArray new];
                              
                              if (DIC_HAS_ARRAY(data, @"doc")) {
                                  NSArray *entriesArr = [data objectForKey:@"doc"];
                                  
                                  for (NSDictionary *dic in entriesArr) {
                                      HXStoreDocumentLibraryDocumentModel *model = [HXStoreDocumentLibraryDocumentModel objectFromJSONObject:dic];
                                      
                                      [resultArr addObject:model];
                                  }
                                  block(status, msg, resultArr);
                                  return;
                              }
                              block(status, msg, nil);
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];

}

- (void)fetchFindingDocumentListComplete:(void (^)(HXSErrorCode code, NSString *message, NSMutableDictionary *modelList, NSMutableArray<NSString *> *tagStrArray, NSMutableArray<NSNumber *> *offsetNumsArray))block
{
    [HXStoreWebService getRequest:HXS_DOCUMENT_LIBRARY_FINDINGS_LIST
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil, nil, nil);
                                  return ;
                              }
                              
                              NSMutableArray *supposeArr = [NSMutableArray new];
                              NSMutableArray *nearbyArr = [NSMutableArray new];
                              NSMutableArray *recommendArr = [NSMutableArray new];
                              if (DIC_HAS_ARRAY(data, @"suppose")) {
                                  
                                  NSArray *entriesArr = [data objectForKey:@"suppose"];
                                  for (NSDictionary *dic in entriesArr) {
                                      HXStoreDocumentLibraryDocumentModel *model = [HXStoreDocumentLibraryDocumentModel objectFromJSONObject:dic];
                                      [supposeArr addObject:model];
                                  }
                              }
                              
                              if (DIC_HAS_ARRAY(data, @"recommend")) {
                                  
                                  NSArray *entriesArr = [data objectForKey:@"recommend"];
                                  for (NSDictionary *dic in entriesArr) {
                                      HXStoreDocumentLibraryDocumentModel *model = [HXStoreDocumentLibraryDocumentModel objectFromJSONObject:dic];
                                      [recommendArr addObject:model];
                                  }
                              }
                              
                              if (DIC_HAS_ARRAY(data, @"nearby")) {
                                  
                                  NSArray *entriesArr = [data objectForKey:@"nearby"];
                                  for (NSDictionary *dic in entriesArr) {
                                      HXStoreDocumentLibraryDocumentModel *model = [HXStoreDocumentLibraryDocumentModel objectFromJSONObject:dic];
                                      [nearbyArr addObject:model];
                                  }
                              }
                              
                              NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                        supposeArr,             @"猜你喜欢",
                                                        recommendArr,           @"编辑推荐",
                                                        nearbyArr,              @"附近的人在看",
                                                        nil];
                              NSMutableArray *tagStrArray = [NSMutableArray array];
                              [tagStrArray addObject:@"猜你喜欢"];
                              [tagStrArray addObject:@"编辑推荐"];
                              [tagStrArray addObject:@"附近的人在看"];
                              
                              NSMutableArray<NSNumber *> *offsetNumsArray = [NSMutableArray array];
                              [offsetNumsArray addObject:[NSNumber numberWithInteger:supposeArr.count]];
                              [offsetNumsArray addObject:[NSNumber numberWithInteger:recommendArr.count]];
                              [offsetNumsArray addObject:[NSNumber numberWithInteger:nearbyArr.count]];
                              
                              block(status, msg, paramDic, tagStrArray, offsetNumsArray);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil, nil, nil);
                          }];
}

- (void)fetchFindingExchangeDocumentListWithType:(NSNumber *)type
                                       andOffser:(NSNumber *)offSet
                                       andLimits:(NSNumber *)limitsNum
                                        Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              type,             @"type",
                              offSet,           @"offset",
                              limitsNum,        @"limit",
                              nil];
    
    [HXStoreWebService getRequest:HXS_DOCUMENT_LIBRARY_EXCHANGE_LIST
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              NSMutableArray *resultArr = [NSMutableArray new];
                              
                              if (DIC_HAS_ARRAY(data, @"doc")) {
                                  NSArray *entriesArr = [data objectForKey:@"doc"];
                                  
                                  for (NSDictionary *dic in entriesArr) {
                                      HXStoreDocumentLibraryDocumentModel *model = [HXStoreDocumentLibraryDocumentModel objectFromJSONObject:dic];
                                      
                                      [resultArr addObject:model];
                                  }
                                  block(status, msg, resultArr);
                                  return;
                              }
                              block(status, msg, nil);
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

- (void)fetchSearchHotwordsComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray<NSString *> *hotWordsArray))block
{
    [HXStoreWebService getRequest:HXS_DOCUMENT_LIBRARY_SEARCH_HOTWORDS
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              NSMutableArray<NSString *> *resultArr = [NSMutableArray<NSString *> new];
                              
                              if (DIC_HAS_ARRAY(data, @"hotwords")) {
                                  NSArray *entriesArr = [data objectForKey:@"hotwords"];
                                  
                                  for (NSString *str in entriesArr) {
                                      [resultArr addObject:str];
                                  }
                                  block(status, msg, resultArr);
                                  return;
                              }
                              block(status, msg, nil);
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];

}

- (void)fetchSearchDocumentListWithParamModel:(HXStoreDocumentLibraryDocListParamModel *)paramModel
                                     Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              paramModel.keywordStr,           @"keyword",
                              paramModel.offsetNum,            @"offset",
                              paramModel.limitNum,             @"limit",
                              paramModel.sortNum,              @"sort",
                              nil];
    
    [HXStoreWebService getRequest:HXS_DOCUMENT_LIBRARY_SEARCH_LIST
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              NSMutableArray *resultArr = [NSMutableArray new];
                              
                              if (DIC_HAS_ARRAY(data, @"doc")) {
                                  NSArray *entriesArr = [data objectForKey:@"doc"];
                                  
                                  for (NSDictionary *dic in entriesArr) {
                                      HXStoreDocumentLibraryDocumentModel *model = [HXStoreDocumentLibraryDocumentModel objectFromJSONObject:dic];
                                      
                                      [resultArr addObject:model];
                                  }
                                  block(status, msg, resultArr);
                                  return;
                              }
                              block(status, msg, nil);
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

- (void)updateDocumentReadPagesWithPageNums:(NSNumber *)pageNums
                                   andDocId:(NSString *)docId
                                   Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              pageNums,           @"page",
                              docId,              @"doc_id",
                              nil];
    
    [HXStoreWebService getRequest:HXS_DOCUMENT_LIBRARY_STARREAD
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, NO);
                                  return ;
                              }
                              block(status, msg, YES);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, NO);
                          }];
}

#pragma mark - other

- (CGFloat)getCategoryCellHeight:(HXStoreDocumentLibraryCategoryListModel *)categoryListModel
                    andIsShowAll:(BOOL)isShowAll
{
    if(nil == categoryListModel) {
        return  0.0;
    }
    
    CGFloat cellHeight = 0.0;
    NSInteger countsCategory = [categoryListModel.categoryArray count];
    NSInteger totalRows = countsCategory / columnsLimitCategoryCell + (countsCategory % columnsLimitCategoryCell == 0 ? 0 : 1);
    
    if(totalRows > rowsLimitCategoryCell
       && !isShowAll) {
        totalRows = rowsLimitCategoryCell;
    }
    
    cellHeight = totalRows * rowsSingleHeightCell;
    
    return cellHeight;
}

- (UIImage *)imageFromNewName:(NSString *)nameStr
{
    UIImage *image = [UIImage imageNamed:nameStr];
    
    if(!image)
    {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
            if (bundlePath) {
                bundle = [NSBundle bundleWithPath:bundlePath];
            }
            UIImage *imageNew = [UIImage imageNamed:nameStr
                                           inBundle:bundle
                      compatibleWithTraitCollection:nil];
            
            return imageNew;
        }
    }
    
    return image;
}

- (NSString *)saveLocalDocPathURLWithURL:(HXStoreDocumentLibraryDocumentModel *)docModel;
{
    NSString *shortenedURL;
    
    if ([[docModel.archiveDocPathURL absoluteString] hasPrefix:@"file://"]) {
        shortenedURL = [[[docModel.archiveDocPathURL absoluteString] substringFromIndex:7]
                        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    shortenedURL = [shortenedURL stringByDeletingLastPathComponent];
    
    shortenedURL = [NSString stringWithFormat:@"%@/%@",shortenedURL,docModel.pdfNameStr];
    
    return shortenedURL;
}

- (void)updateDocmentStarWithDocModelAndSaveLocal:(HXStoreDocumentLibraryDocumentModel *)docModel
                                            andVC:(UIViewController *)vc
                                      andComplete:(void (^)(HXStoreDocumentLibraryDocumentModel *docModel))block
{
    if(!docModel) {
        return;
    }
    __weak typeof(vc) weakSelf = vc;
    [MBProgressHUD showInView:vc.view];
    [self updateDocumentStarWithDocId:docModel.docIdStr
                              andtype:@(![docModel.isFavorNum boolValue])
                             Complete:^(HXSErrorCode code, NSString *message, BOOL success)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         if(kHXSNoError == code
            && success) {
             docModel.isFavorNum = @(![docModel.isFavorNum boolValue]);
             
             NSString *starStr;
             
             if([docModel.isFavorNum boolValue]) {
                 starStr = @"收藏成功";
             } else {
                 starStr = @"已取消收藏";
             }
             
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:starStr
                                            afterDelay:1.5];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kDocumentModelUpdated
                                                                 object:nil
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:docModel, @"DocModel", nil]];
             
             block(docModel);
         } else {
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:message
                                            afterDelay:1.5];
         }
     }];
}

- (void)createShareViewAndShowIn:(UIViewController *)vc
                    withDocModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    if(!docModel) {
        return;
    }
    __weak typeof(vc) weakSelf = vc;
    HXSShareParameter *parameter = [[HXSShareParameter alloc] init];
    parameter.shareTypeArr = @[@(kHXSShareTypeQQMoments), @(kHXSShareTypeWechatFriends),
                               @(kHXSShareTypeQQFriends), @(kHXSShareTypeWechatMoments),@(kHXSShareTypeCopyLink)];
    
    HXSShareView *shareView = [[HXSShareView alloc] initShareViewWithParameter:parameter
                                                                      callBack:^(HXSShareResult shareResult, NSString *msg)
    {
        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                           status:msg
                                       afterDelay:1.5];
    }];
    
    shareView.shareParameter.titleStr    = docModel.docTitleStr;
    shareView.shareParameter.textStr     = @"我在59文库发现了一份不错的文档，你也来看看吧~";
    shareView.shareParameter.imageURLStr = @"http://print-identification.oss-cn-hangzhou.aliyuncs.com/78d4f277589f3e9807321fe3db6380221474465479036.png";
    shareView.shareParameter.shareURLStr = docModel.urlStr;
    [shareView show];
}

- (void)setImageForIconImageView:(UIImageView *)imageView
                       withModel:(HXStoreDocumentLibraryDocumentModel *)docModel

{
    if([docModel.docSuffixStr hasSuffix:@"doc"]
       || [docModel.docSuffixStr hasSuffix:@"docx"]) {
        [imageView setImage:[self imageFromNewName:@"img_print_word_small"]];
    } else if([docModel.docSuffixStr hasSuffix:@"pdf"]) {
        [imageView setImage:[self imageFromNewName:@"img_print_pdf_small"]];
    } else if([docModel.docSuffixStr hasSuffix:@"ppt"]
              || [docModel.docSuffixStr hasSuffix:@"pptx"]) {
        [imageView setImage:[self imageFromNewName:@"img_print_ppt_small"]];
    } else {
        [imageView setImage:[self imageFromNewName:@"img_print_pdf_small"]];
    }
}

- (NSString *)createUploadTimeYearMonthDayWithTimeStamp:(NSString *)timeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *mydate = [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:mydate] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:mydate]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:mydate] integerValue];
    
    NSString *timeDateStr = [NSString stringWithFormat:@"%zd年%zd月%zd日上传",currentYear,currentMonth,currentDay];
    
    return timeDateStr;
}

- (NSMutableArray<NSString *> *)createTagsArrayForTagsStr:(NSString *)tagsStr
{
    if(!tagsStr
       || [[tagsStr trim] isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableArray<NSString *> *array = [[tagsStr componentsSeparatedByString:@","] mutableCopy];
    
    return array;
}

- (NSString *)createTagsStrWithTagsArray:(NSMutableArray<NSString *> *)tagsArray
{
    if(!tagsArray
       || tagsArray.count == 0) {
        return nil;
    }
    NSMutableString *tagMutableString = [[NSMutableString alloc] initWithString:@""];
    for (NSString *tagStr in tagsArray) {
        if([[tagStr trim] isEqualToString:@""]) {
            if([tagsArray indexOfObject:tagStr] == tagsArray.count - 1
               && [tagsArray indexOfObject:tagStr] > 0) {
                tagMutableString = [tagMutableString substringWithRange:NSMakeRange(0, tagMutableString.length - 1)];
            }
            continue;
        }
        [tagMutableString appendString:tagStr];
        if(![[tagsArray lastObject] isEqualToString:tagStr]) {
            [tagMutableString appendString:@","];
        }
    }
    return tagMutableString;
}

- (void)checkTheTextFieldTextIsMoreThanMax:(UITextField *)textField
                           andMaxInputNums:(NSInteger)maxInputNums
{
    NSString *inputStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lang =  [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (inputStr.length > maxInputNums)
            {
                textField.text = [inputStr substringToIndex:maxInputNums];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else
        {
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (inputStr.length > maxInputNums)
        {
            textField.text = [inputStr substringToIndex:maxInputNums];
        }
    }
}

- (void)fetchPrintDormShopShareDocWithShopId:(NSNumber *)shopIdIntNum
                           andParamListModel:(HXSPrintListParamModel *)paramListModel
                                    complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *array))block
{
    NSDictionary *paramsDic = @{
                                @"offset":          paramListModel.offset,
                                @"limit":           paramListModel.limit,
                                @"sort":            paramListModel.sort,
                                @"shop_id":         shopIdIntNum
                                };
    
    
    [HXStoreWebService getRequest:HXS_PRINT_DOCUMENT_LIBRARY_SHARED
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              if (DIC_HAS_ARRAY(data, @"doc")) {
                                  NSArray *docArr = [data objectForKey:@"doc"];
                                  
                                  NSMutableArray *array = [[NSMutableArray alloc] init];
                                  
                                  for (NSDictionary *dic in docArr) {
                                      
                                      HXStoreDocumentLibraryDocumentModel *model = [HXStoreDocumentLibraryDocumentModel objectFromJSONObject:dic];
                                      
                                      [array addObject:model];
                                  }
                                  
                                  block(status, msg, array);
                              } else {
                                  block(status, msg, nil);
                              }
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

- (void)fetchPrintDormShopShareDocTotalNumsWithShopId:(NSNumber *)shopIdIntNum
                                             Complete:(void (^)(HXSErrorCode code, NSString *message, NSNumber *totalNums))block;
{
    HXSPrintListParamModel *paramListModel = [HXSPrintListParamModel createDeafultParamModel];
    NSDictionary *paramsDic = @{
                                @"offset":          paramListModel.offset,
                                @"limit":           paramListModel.limit,
                                @"sort":            paramListModel.sort,
                                @"shop_id":         shopIdIntNum
                                };
    
    
    [HXStoreWebService getRequest:HXS_PRINT_DOCUMENT_LIBRARY_SHARED
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              NSNumber *totalNum = [data objectForKey:@"total"];
                              if(totalNum) {
                                  block(status, msg, totalNum);
                              } else {
                                  block(status, msg, nil);
                              }
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

- (void)fetchPrintBuyedDocsListWithParamListModel:(HXSPrintListParamModel *)paramListModel
                                         Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentBuyedModel *> *array))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              paramListModel.offset,           @"offset",
                              paramListModel.limit,            @"limit",
                              nil];
    
    [HXStoreWebService getRequest:HXS_PRINT_DOCUMENT_LIBRARY_BUYED
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              if (DIC_HAS_ARRAY(data, @"doc_list")) {
                                  NSArray *docArr = [data objectForKey:@"doc_list"];
                                  
                                  NSMutableArray *array = [[NSMutableArray alloc] init];
                                  
                                  for (NSDictionary *dic in docArr) {
                                      
                                      HXStoreDocumentLibraryDocumentBuyedModel *model = [HXStoreDocumentLibraryDocumentBuyedModel objectFromJSONObject:dic];
                                      
                                      [array addObject:model];
                                  }
                                  
                                  block(status, msg, array);
                              } else {
                                  block(status, msg, nil);
                              }
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

- (void)upLoadDocumentShareWithIsAnonymous:(NSNumber *)isAnonymous
                           andDocListArray:(NSMutableArray<HXStoreDocumentLibraryUploadDocShareParamModel *> *)docListArray
                                  Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL success))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              isAnonymous,                                              @"anonymous",
                              [self upLoadShareDocDictionaryWithDocArray:docListArray], @"doc_list_details",
                              nil];
    
    [HXStoreWebService postRequest:HXS_PRINT_DOCUMENT_LIBRARY_UPLOADSAHRE
                        parameters:paramDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError != status) {
                                   block(status, msg, NO);
                                   return ;
                               }
                               
                               block(status, msg, YES);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, NO);
                          }];

}

- (void)cancelDocumentShareWithDocId:(NSString *)docIdStr
                            Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL success))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              docIdStr,  @"doc_id",
                              nil];
    
    [HXStoreWebService postRequest:HXS_PRINT_DOCUMENT_LIBRARY_CANCELUPLOADSAHRE
                        parameters:paramDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError != status) {
                                   block(status, msg, NO);
                                   return ;
                               }
                               
                               block(status, msg, YES);
                               
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status, msg, NO);
                           }];
}

- (void)createDocumentOrderInfoWithDocId:(NSString *)docIdStr
                                Complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintDocumentOrderInfo *docOrderInfo))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              docIdStr,  @"doc_id",
                              nil];
    
    [HXStoreWebService postRequest:HXS_PRINT_DOCUMENT_LIBRARY_DOCBUY
                        parameters:paramDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError != status) {
                                   block(status, msg, nil);
                                   return ;
                               }
                               if (data) {
                                   HXSPrintDocumentOrderInfo *docOrderInfo = [HXSPrintDocumentOrderInfo objectFromJSONObject:data];
                                   block(status, msg, docOrderInfo);
                                   return;
                               }
                               block(status, msg, nil);
                               
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status, msg, nil);
                           }];
}

- (NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *)convertOrderItemArrayToDocLibArray:(NSMutableArray<HXSMyPrintOrderItem> *)cartArray
{
    if(!cartArray
       || cartArray.count == 0) {
        return nil;
    }
    
    NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *array = [[NSMutableArray alloc]init];
    
    for (HXSMyPrintOrderItem *orderItem in cartArray) {
        HXStoreDocumentLibraryDocumentModel *docModel = [[HXStoreDocumentLibraryDocumentModel alloc]init];
        docModel.typeNum           = @(1);//普通文档
        docModel.docTitleStr       = orderItem.fileNameStr;
        docModel.archiveDocPathStr = orderItem.originPathStr;
        docModel.sourceMd5Str      = orderItem.originMd5Str;
        docModel.pdfMd5Str         = orderItem.pdfMd5Str;
        docModel.docSuffixStr      = [self createSuffixDocFromOrderItemType:orderItem.archiveDocTypeNum];
        
        [array addObject:docModel];
    }
    
    return array;
}

- (NSMutableArray<HXStoreDocumentLibraryUploadDocShareParamModel *> *)convertNormalDocModelArrayToParamModelArray:(NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *)docModelArray
{
    if(!docModelArray
       || docModelArray.count == 0) {
        return nil;
    }
    
    NSMutableArray<HXStoreDocumentLibraryUploadDocShareParamModel *> *array = [[NSMutableArray alloc]init];
    
    for (HXStoreDocumentLibraryDocumentModel *docModel in docModelArray) {
        if(!docModel.isShowTagsAndPrice) {//未被选中分享
            continue;
        }
        HXStoreDocumentLibraryUploadDocShareParamModel *paramModel = [[HXStoreDocumentLibraryUploadDocShareParamModel alloc]init];
        paramModel.docTypeNum        = docModel.typeNum;
        paramModel.docTitleStr       = docModel.docTitleStr;
        paramModel.docUrlStr         = docModel.archiveDocPathStr;
        paramModel.docMd5Str         = docModel.pdfMd5Str;
        paramModel.priceDecNum       = docModel.priceDecNum;
        paramModel.tagsStr           = docModel.tagsStr;
        
        [array addObject:paramModel];
    }
    
    return array;
}

#pragma mark - private methods

- (NSString *)upLoadShareDocDictionaryWithDocArray:(NSMutableArray<HXStoreDocumentLibraryUploadDocShareParamModel *> *)shareDocModelArray
{
    if(!shareDocModelArray
       || shareDocModelArray.count == 0) {
        return @"";
    }
    NSMutableArray *itemsArray = [NSMutableArray array];
    for(HXStoreDocumentLibraryUploadDocShareParamModel *temp in shareDocModelArray){
        [itemsArray addObject:[temp itemDictionary]];
    }
    //转化json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:itemsArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

- (NSString *)createSuffixDocFromOrderItemType:(HXSDocumentType)type
{
    NSString *suffixDocStr;
    
    switch (type) {
        case HXSDocumentTypeDoc:
            
            suffixDocStr = @"doc";
            
            break;
            
        case HXSDocumentTypePPT:
            
            suffixDocStr = @"ppt";
            
            break;
            
        default:
            
            suffixDocStr = @"pdf";
            
            break;
    }
    
    return suffixDocStr;
}

@end
