//
//  HXSDoodsCollectionViewCell.h
//  store
//
//  Created by caixinye on 2017/9/2.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSStoreAppEntryEntity.h"

/**商品item*/

@class HXSDoodsCollectionViewCell;


@protocol goodsCollectioncellDelegate <NSObject>

- (void)onCartButtonClick:(HXSDoodsCollectionViewCell *)cell;


@end



@interface HXSDoodsCollectionViewCell : UICollectionViewCell

//传索引过来
@property (nonatomic) NSIndexPath *indexPath;

@property(nonatomic,strong)HXSStoreAppEntryEntity *model;

@property(nonatomic,weak)id<goodsCollectioncellDelegate>delegate;




@end
