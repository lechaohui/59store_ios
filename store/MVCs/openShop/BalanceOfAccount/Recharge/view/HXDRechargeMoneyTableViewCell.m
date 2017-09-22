//
//  HXDRechargeMoneyTableViewCell.m
//  59dorm
//
//  Created by wupei on 16/7/6.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDRechargeMoneyTableViewCell.h"
@interface HXDRechargeMoneyTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;

@end

@implementation HXDRechargeMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.moneyTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag = 0;
    
    const NSInteger limited = 2;//小数点后需要限制的个数
    
    for (NSInteger i = futureString.length - 1; i >= 0; i--) {
        
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                
                return NO;
                
            }
            break;
        }
        flag++;
    }
    return YES;
}

@end
