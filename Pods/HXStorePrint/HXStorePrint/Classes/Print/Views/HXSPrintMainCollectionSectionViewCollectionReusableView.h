//
//  HXSPrintMainCollectionSectionViewCollectionReusableView.h
//  store
//
//  Created by J006 on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPrintDormShopEntity.h"

static CGFloat const TOTAL_HEIGHT = 231;

static CGFloat const NOSHOPPER_HEIGHT = 143;

static CGFloat const SINGLE_LABEL_HEIGHT = 50.0;

@interface HXSPrintMainCollectionSectionViewCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *jumpToShareButton;
@property (weak, nonatomic) IBOutlet UIButton *jumpToShopActionButton;

- (void)initPrintMainCollectionSectionViewCollectionReusableViewWithEntity:(HXSPrintDormShopEntity *)entity
                                                    andHasShowShopShareDoc:(BOOL)hasShopShareDoc;

@end
