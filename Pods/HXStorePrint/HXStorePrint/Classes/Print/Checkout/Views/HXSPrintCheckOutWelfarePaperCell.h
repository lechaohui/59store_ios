//
//  HXSPrintCheckOutWelfarePaperCell.h
//  store
//
//  Created by J.006 on 16/9/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPrintCartEntity.h"

@protocol HXSPrintCheckOutWelfarePaperCellDelegate <NSObject>

@optional

- (void)welfarePaperSwitchChange:(UISwitch *)sender;

@end

@interface HXSPrintCheckOutWelfarePaperCell : UITableViewCell

@property (nonatomic, weak) id<HXSPrintCheckOutWelfarePaperCellDelegate> delegate;

- (void)initPrintCheckOutWelfarePaperCellWithPrintCartEntity:(HXSPrintCartEntity *)cartEntity
                                        andIfUseWelfarePaper:(BOOL)ifUseWelfarePaper;

@end
