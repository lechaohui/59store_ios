//
//  HXSOrderCountdownCell.m
//  store
//
//  Created by 格格 on 16/9/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  倒计时

#import "HXSOrderCountdownCell.h"

@interface HXSOrderCountdownCell ()

@property (nonatomic, strong) IBOutlet UILabel *showLabel;

// 过期时间
@property (nonatomic, strong) NSString *invalidTimeStr;
@property (nonatomic, strong) NSString *currentTimeStr;
@property (nonatomic, strong) NSTimer  *timer;

@property (nonatomic, assign) long long leaveTime;

@end

@implementation HXSOrderCountdownCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
    }

}

+ (instancetype)orderCountdownCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSOrderCountdownCell class])
                                         owner:nil options:nil].firstObject;
}

- (void)refresh
{
    if(self.timer) {
        [self.timer invalidate];
    }
    
    // 过期时间（秒）
    long long invalidTime = self.invalidTimeStr.longLongValue / 1000;
    // 当前距离1970-01-01 00:00:00 秒数
    long long spaceFromNow = self.currentTimeStr.longLongValue / 1000;
    // 计算剩下时间（秒）
    self.leaveTime = invalidTime - spaceFromNow + 3; // 这里添加3，是让后台有足够的时候取消订单
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(show) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

- (void)show
{
    // 剩余时间（分部分）
    long long leaveMin;
    // 剩余时间（秒部分）
    long long leaveSec;
    
    if(self.leaveTime > 0) {
        
         leaveMin = self.leaveTime / 60;
         leaveSec = self.leaveTime % 60;
        
        self.leaveTime -- ;
    }  else {
        
        // 倒计时到0，销毁计时器
        if (self.timer) {
            [self.timer invalidate];
        }
        
        leaveMin = 0;
        leaveSec = 0;
        
        if ([self.delegate respondsToSelector:@selector(orderCountdownCellCountdownOver)]) {
            [self.delegate orderCountdownCellCountdownOver];
        }
    }
    
    NSString *showStr = [NSString stringWithFormat:@"还剩 %ld 分 %ld 秒    订单将自动关闭",(long)leaveMin,(long)leaveSec];
    
    // 用下面的写法是为了保证分数和秒数一样的时候出现bug
    NSRange minRange = [showStr rangeOfString:[NSString stringWithFormat:@"%ld 分",(long)leaveMin]];
    minRange = NSMakeRange(minRange.location, minRange.length - 2);
    
    NSRange secRange = [showStr rangeOfString:[NSString stringWithFormat:@"%ld 秒",(long)leaveSec]];
    secRange = NSMakeRange(secRange.location, secRange.length - 2);
    
    NSDictionary *dia = @{
                          NSForegroundColorAttributeName:HXS_COLOR_MASTER,
                          NSFontAttributeName:[UIFont systemFontOfSize:18]
                          };
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:showStr ];
    
    [attStr addAttributes:dia range:minRange];
    [attStr addAttributes:dia range:secRange];
    
    self.showLabel.attributedText = attStr;

}

- (void)initialInvalidTimeStr:(NSString *)invalidTimeStr
               currentTimeStr:(NSString *)currentTimeStr
{
    self.currentTimeStr = currentTimeStr;
    self.invalidTimeStr = invalidTimeStr;
    
    [self refresh];
}

@end
