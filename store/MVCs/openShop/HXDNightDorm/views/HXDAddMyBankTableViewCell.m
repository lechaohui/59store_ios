//
//  HXDAddMyBankTableViewCell.m
//  59dorm
//
//  Created by J006 on 16/3/3.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDAddMyBankTableViewCell.h"
#import "NSString+Addition.h"
#import "NSString+Verification.h"

#define kNumbers     @"0123456789"

@interface HXDAddMyBankTableViewCell()<UITextFieldDelegate>

@property (nonatomic, readwrite) HXDMyBankAddType           currentType;
@property (nonatomic, strong)    HXDAddBankInforParamEntity *currentEntity;
@property (weak, nonatomic) IBOutlet UILabel                *titleLabel;

@end

@implementation HXDAddMyBankTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)initTheCellWithTitle:(NSString *)title
                 andWithType:(HXDMyBankAddType)type
               andWithEntity:(HXDAddBankInforParamEntity *)entity
{
    [_titleLabel setText:title];
    _currentType = type;
    _currentEntity = entity;
    switch (_currentType)
    {
        case kHXDMyBankEditTypeBankAddress:
            
            [_inputTextField setPlaceholder:@"如:杭州"];
            if(_currentEntity.openLocationStr)
               [_inputTextField setText:_currentEntity.openLocationStr];
            
            break;
            
        case kHXDMyBankEditTypeBankShop:
            
            [_inputTextField setPlaceholder:@"如:XXX支行"];
            if(_currentEntity.openAccountStr)
                [_inputTextField setText:_currentEntity.openAccountStr];
            
            break;
            
        case kHXDMyBankEditTypeBankNums:
            
            [_inputTextField setPlaceholder:@"请输入您的银行卡号"];
            _inputTextField.keyboardAppearance = UIKeyboardTypeNumbersAndPunctuation;
            _inputTextField.keyboardType = UIKeyboardTypeNumberPad;

            if(_currentEntity.cardNumberStr)
                [_inputTextField setText:_currentEntity.cardNumberStr];
            
            break;
        case kHXDMyBankEditTypeUserName:
        {
            [_inputTextField setPlaceholder:@"请填写真实姓名"];
            if(_currentEntity.cardHolderNameStr)
                [_inputTextField setText:_currentEntity.cardHolderNameStr];
            break;
        }
        default:
        {
            [_inputTextField setEnabled:NO];
            if(_currentEntity.bankNameStr)
                [_inputTextField setText:_currentEntity.bankNameStr];
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
            
            break;
    }
    [_inputTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    switch (_currentType)
    {
        case kHXDMyBankEditTypeBankAddress:
            
            _currentEntity.openLocationStr = text;
            
            break;
            
        case kHXDMyBankEditTypeBankShop:
            
            _currentEntity.openAccountStr = text;
            
            break;
            
        case kHXDMyBankEditTypeBankNums:
            
            _currentEntity.cardNumberStr = text;
            
            break;
        
        case kHXDMyBankEditTypeUserName:
        
            _currentEntity.cardHolderNameStr = text;
        
        case kHXDMyBankEditTypeBankType:
        break;
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    //删除时不判断
    if (string.length == 0 && range.length == 1)
    {
        return YES;
    }
    if(_currentType == kHXDMyBankEditTypeBankNums)
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    else if(_currentType == kHXDMyBankEditTypeBankAddress || _currentType == kHXDMyBankEditTypeBankShop)
    {
        return [string vaildChineseAndNumberAndABC];
    }
    return YES;
}



@end
