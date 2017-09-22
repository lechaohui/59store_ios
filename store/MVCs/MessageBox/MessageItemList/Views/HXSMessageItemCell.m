//
//  HXSMessageItemCell.m
//  store
//
//  Created by 格格 on 16/8/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMessageItemCell.h"


@interface HXSMessageItemCell()

@property (nonatomic, weak) IBOutlet UIView *containterView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *activityImageView;
@property (nonatomic, weak) IBOutlet UILabel *detialLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *detialHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageTop;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *detialTop;

@end

@implementation HXSMessageItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.containterView setBackgroundColor:[UIColor whiteColor]];
    self.containterView.layer.borderColor = HXS_COLOR_SEPARATION_STRONG.CGColor;
    self.containterView.layer.borderWidth = 1;
    self.containterView.layer.cornerRadius = 8;
    
    // 给cell添加长按手势，弹出复制和删除
    UILongPressGestureRecognizer *longPressGesture =  [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureTop:)];
    [self addGestureRecognizer:longPressGesture];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.messageItem.operationStr.intValue == HXSMessageCateOperationAvailable) {
        return (action == @selector(copyMessage:) || action == @selector(deleteMessage:));
    } else {
        return action == @selector(copyMessage:);
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)panGestureTop:(UILongPressGestureRecognizer *)longPress
{
    [self becomeFirstResponder];
    
    UIMenuItem * itemCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    UIMenuItem * itemDelegate = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    
    UIMenuController * menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems: @[itemCopy,itemDelegate]];
    
    // UIMenuController固定弹出位置：三分之二宽度的位置
    CGRect menuLocation = CGRectMake((SCREEN_WIDTH / 3) * 2, 15, 0, 0);
    
    [menuController setTargetRect:menuLocation inView:self];
    menuController.arrowDirection = UIMenuControllerArrowDown;
    [menuController setMenuVisible:YES animated:YES];
}

- (void)copyMessage:(id) sender
{
    if ([self.delegate respondsToSelector:@selector(messageItemCell:copyMessage:)]) {
        [self.delegate messageItemCell:self copyMessage:self.messageItem];
    }
}

- (void)deleteMessage:(id) sender
{
    if ([self.delegate respondsToSelector:@selector(messageItemCell:deleteMessage:)]) {
        [self.delegate messageItemCell:self deleteMessage:self.messageItem];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)refresh
{
    // 标题
    self.titleLabel.text = self.messageItem.titleStr;
    
    // 图片
    if(self.messageItem.imageStr) {
        [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:self.messageItem.imageStr]];
    } else {
        [self.activityImageView setImage:nil];
    }
    
    self.imageHeight.constant = self.messageItem.imageHeight;
    self.imageTop.constant = self.messageItem.imageHeight > 0 ? 10 : 0;
    
    // 详情
    if(self.messageItem.contentStr) {
        self.detialLabel.text = self.messageItem.contentStr;
    } else {
        self.detialLabel.text = @"";
    }
    
    self.detialHeight.constant = self.messageItem.contentTextHeight;
    self.detialTop.constant = self.messageItem.contentTextHeight > 0 ? 10 : 0;
    
    [self layoutIfNeeded];
}

- (void)setMessageItem:(HXSMessageItem *)messageItem
{
    _messageItem = messageItem;
    [self refresh];
}

@end
