//
//  HXSPrintMainCollectionSectionViewCollectionReusableView.m
//  store
//
//  Created by J006 on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintMainCollectionSectionViewCollectionReusableView.h"
#import "HXSPrintModel.h"
//others
#import "HXSPrintHeaderImport.h"

@interface HXSPrintMainCollectionSectionViewCollectionReusableView()

@property (weak, nonatomic) IBOutlet UILabel *firstPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTitleLabel;
@property (weak, nonatomic) IBOutlet UIView  *middleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewHeightConstriant;

@end

@implementation HXSPrintMainCollectionSectionViewCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
}


#pragma mark - init

- (void)initPrintMainCollectionSectionViewCollectionReusableViewWithEntity:(HXSPrintDormShopEntity *)entity
                                                    andHasShowShopShareDoc:(BOOL)hasShopShareDoc;
{
    if(entity.dormShopPricesArry)
    {
        [self settingPriceWithModel:entity.dormShopPricesArry];
    }
    
    if(!hasShopShareDoc) {
        _middleViewHeightConstriant.constant = 0;
        [_middleView setHidden:YES];
    } else {
        _middleViewHeightConstriant.constant = 44;
        [_middleView setHidden:NO];
    }
}

/**
 *  拼接价格
 *
 *  @param priceArray
 *
 *  @return 
 */
- (void)settingPriceWithModel:(NSArray<HXSPrintDormShopPriceEntity> *)priceArray
{
    
    if(priceArray.count > 0
       && priceArray[0]) {
        HXSPrintDormShopPriceEntity *entity = priceArray[0];
        [_firstPriceLabel setText:[NSString stringWithFormat:@"%.2f",[entity.unitPriceNum doubleValue]]];
        [_firstTitleLabel setText:entity.nameStr];
    } else {
        [_firstPriceLabel setText:@""];
        [_firstTitleLabel setText:@""];
    }
    
    if(priceArray.count > 1
       && priceArray[1]) {
        HXSPrintDormShopPriceEntity *entity = priceArray[1];
        [_secondPriceLabel setText:[NSString stringWithFormat:@"%.2f",[entity.unitPriceNum doubleValue]]];
        [_secondTitleLabel setText:entity.nameStr];
    } else {
        [_secondPriceLabel setText:@""];
        [_secondTitleLabel setText:@""];
    }
    
    if(priceArray.count > 2
       && priceArray[2]) {
        HXSPrintDormShopPriceEntity *entity = priceArray[2];
        [_thirdPriceLabel setText:[NSString stringWithFormat:@"%.2f",[entity.unitPriceNum doubleValue]]];
        [_thirdTitleLabel setText:entity.nameStr];
    } else {
        [_thirdPriceLabel setText:@""];
        [_thirdTitleLabel setText:@""];
    }
}

@end
