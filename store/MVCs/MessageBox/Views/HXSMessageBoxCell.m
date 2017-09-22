//
//  HXSMessageBoxCell.m
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMessageBoxCell.h"
#import "HXSImageViewWithPoint.h"

@interface HXSMessageBoxCell ()

@property (nonatomic, weak) IBOutlet HXSImageViewWithPoint *imageViewWithPoint;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *detialLabel;

@end

@implementation HXSMessageBoxCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.imageViewWithPoint setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)refresh
{
    // 图片
    [self.imageViewWithPoint.imageView sd_setImageWithURL:[NSURL URLWithString:self.messageCate.iconStr] ];
    self.imageViewWithPoint.imageViewCornerRadius = 4;
    
    if (self.messageCate.messageItem == nil || self.messageCate.messageItem.statusStr.integerValue == HXSMessageItemStatusReaded) {
        self.imageViewWithPoint.showPint = NO;
    } else {
        self.imageViewWithPoint.showPint = YES;
    }
    
    // 标题
    self.titleLabel.text = self.messageCate.cateNameStr;
    
    // 消息详情
    if(nil != self.messageCate.messageItem) {
        self.detialLabel.text = self.messageCate.messageItem.contentStr;
        
        if (0 >= self.self.messageCate.messageItem.createTimeStr.longLongValue) {
            self.timeLabel.text = @"";
        } else {
            self.timeLabel.text = [NSDate stringFromSecondsSince1970:[self.messageCate.messageItem.createTimeStr longLongValue] format:@"YYYY-MM-dd HH:mm"];
        }

    } else {
        self.detialLabel.text = @"暂无消息";
        self.timeLabel.text = @"";
    }
}

- (void)setMessageCate:(HXSMessageCate *)messageCate
{
    _messageCate = messageCate;
    [self refresh];
}

@end
