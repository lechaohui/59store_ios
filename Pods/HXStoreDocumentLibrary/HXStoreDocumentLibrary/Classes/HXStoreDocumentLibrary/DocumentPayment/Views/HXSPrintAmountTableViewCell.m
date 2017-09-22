//
//  HXSAmountTableViewCell.m
//  store
//
//  Created by  黎明 on 16/5/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintAmountTableViewCell.h"

@interface HXSPrintAmountTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation HXSPrintAmountTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setAmountNum:(NSNumber *)amountNum
{
    if (amountNum)
    {
        self.amountLabel.text = [@"¥" stringByAppendingFormat:@"%.2f", amountNum.floatValue];
    }
    else
    {
        self.amountLabel.text = nil;
    }
}

@end
