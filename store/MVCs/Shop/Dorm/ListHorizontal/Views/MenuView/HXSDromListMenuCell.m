//
//  HXSHXSDromListMenuCell.m
//  store
//
//  Created by  黎明 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDromListMenuCell.h"

#define NOMAL_BG_COLOR [UIColor colorWithRed:0.957 green:0.961 blue:0.965 alpha:1.000]
#define SELECTED_BG_COLOR [UIColor whiteColor]

#define NOMAL_TEXT_COLOR [UIColor colorWithWhite:0.400 alpha:1.000]
#define SELECTED_TEXT_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.000]



@implementation HXSDromListMenuCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor = NOMAL_BG_COLOR;
    self.titleLabel.textColor = NOMAL_TEXT_COLOR;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.selectedView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected) {
        [UIView animateWithDuration:0.1 animations:^{
            self.selectedView.hidden = NO;
            self.titleLabel.textColor = SELECTED_TEXT_COLOR;
            self.contentView.backgroundColor = SELECTED_BG_COLOR;
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            self.selectedView.hidden = YES;
            self.titleLabel.textColor = NOMAL_TEXT_COLOR;
            self.contentView.backgroundColor = NOMAL_BG_COLOR;
        }];
    }
}

@end
