//
//  HXSPrintCheckOutWelfarePaperCell.m
//  store
//
//  Created by J.006 on 16/9/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintCheckOutWelfarePaperCell.h"
#import "HXMacrosDefault.h"
#import "HXSCustomAlertView.h"

@interface HXSPrintCheckOutWelfarePaperCell()

@property (weak, nonatomic) IBOutlet UISwitch   *welfarePaperSwitch;
@property (weak, nonatomic) IBOutlet UILabel    *freePaperDetialLabel;
@property (weak, nonatomic) IBOutlet UILabel    *noWelfarePaperLabel;//暂无免费资源
@property (nonatomic, strong) HXSCustomAlertView    *alertView;


@end

@implementation HXSPrintCheckOutWelfarePaperCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - init

- (void)initPrintCheckOutWelfarePaperCellWithPrintCartEntity:(HXSPrintCartEntity *)cartEntity
                                        andIfUseWelfarePaper:(BOOL)ifUseWelfarePaper;
{
    _welfarePaperSwitch.on = ifUseWelfarePaper;
    
    [self setttingCompentShowWithAdPageNum:cartEntity.adPageNumIntNum];
    
    if (ifUseWelfarePaper) {
        [_freePaperDetialLabel setHidden:NO];
        NSString *freePaperStr = [NSString stringWithFormat:@"%zd张，-￥%0.2f", [cartEntity.adPageNumIntNum integerValue], [cartEntity.freeAmountDoubleNum doubleValue]];
       _freePaperDetialLabel.text = freePaperStr;
    } else {
        [_freePaperDetialLabel setHidden:YES];
    }
}

- (void)setttingCompentShowWithAdPageNum:(NSNumber *)adPageNumIntNum
{
    if(!adPageNumIntNum || [adPageNumIntNum integerValue] == 0){
        [_freePaperDetialLabel setHidden:YES];
        [_welfarePaperSwitch setHidden:YES];
        [_noWelfarePaperLabel setHidden:NO];
    } else if([adPageNumIntNum integerValue] > 0){
        [_welfarePaperSwitch setHidden:NO];
        [_noWelfarePaperLabel setHidden:YES];
    }
}

- (IBAction)switchChange:(id)sender
{
    //NSNumber *welfarePaperNum = [[NSUserDefaults standardUserDefaults]objectForKey:PrintIfUseWelfarePage];
    
    if([sender isOn]) {
        //[[NSUserDefaults standardUserDefaults]setObject:@(1) forKey:PrintIfUseWelfarePage];
        [self.alertView show];
    }
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(welfarePaperSwitchChange:)]) {
        [self.delegate welfarePaperSwitchChange:sender];
    }
}

#pragma mark - getter

- (HXSCustomAlertView *)alertView
{
    if(nil == _alertView) {
        NSString *welfarePaperStr = @"勾选免费打印后，会在相应页面的\n页脚添加一则广告";
        _alertView = [[HXSCustomAlertView alloc]initWithTitle:@"提醒"
                                                      message:welfarePaperStr
                                              leftButtonTitle:@"确定"
                                            rightButtonTitles:nil];
    }
    
    return _alertView;
}

@end
