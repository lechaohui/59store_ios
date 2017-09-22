//
//  HXSPhoneRegisterViewController.m
//  store
//
//  Created by chsasaw on 15/4/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPhoneRegisterViewController.h"

#import "HXSRegisterVerifyButton.h"
#import "HXStoreLogin.h"


#define PHONE_MAX_LENGTH         11
#define VERIFIED_CODE_MAX_LENGTH 6

@interface HXSPhoneRegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet HXSRegisterVerifyButton *verifyBtn;
@property (nonatomic, assign) IBOutlet HXSRoundedButton *sighBtn;
@property (nonatomic, assign) IBOutlet UITextField *phoneTextField;
@property (nonatomic, assign) IBOutlet UITextField *verifyTextField;
@property(nonatomic,strong)UITextField *psdWordField;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation HXSPhoneRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    self.phoneTextField.delegate = self;
    self.phoneTextField.returnKeyType = UIReturnKeyNext;
    self.phoneTextField.tintColor = HXS_TEXT_COLOR;
    [self.phoneTextField addTarget:self action:@selector(checkPhoneAndVerifyCodeInfoValidation) forControlEvents:UIControlEventEditingChanged];
    
    self.verifyTextField.layer.masksToBounds = YES;
    self.verifyTextField.delegate = self;
    self.verifyTextField.returnKeyType = UIReturnKeyNext;
    self.verifyTextField.tintColor = HXS_TEXT_COLOR;
    [self.verifyTextField addTarget:self action:@selector(checkPhoneAndVerifyCodeInfoValidation) forControlEvents:UIControlEventEditingChanged];
    
    self.sighBtn.enabled = NO;
    self.verifyBtn.enabled = NO;

    self.psdWordField = [[UITextField alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(self.bgView.frame)-15, SCREEN_WIDTH-80, 40)];
    self.psdWordField.backgroundColor = [UIColor whiteColor];
    self.psdWordField.placeholder = @"输入密码(不少于6位)";
    self.psdWordField.delegate = self;
    self.psdWordField.returnKeyType = UIReturnKeyNext;
    self.psdWordField.font = [UIFont systemFontOfSize:15];
    self.psdWordField.tintColor = HXS_TEXT_COLOR;
    self.psdWordField.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.psdWordField];
    [self.psdWordField addTarget:self action:@selector(checkPhoneAndVerifyCodeInfoValidation) forControlEvents:UIControlEventEditingChanged];
    //line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.psdWordField.frame)-1, SCREEN_WIDTH-20, 0.5)];
    line.backgroundColor = HXS_BORDER_COLOR;
    [self.view addSubview:line];
    
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginCompleted object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.verifyTextField.delegate = nil;
}


#pragma mark - Action Methods

- (void)checkPhoneAndVerifyCodeInfoValidation
{
    _sighBtn.enabled = ((_phoneTextField.text.length == 11) && (_verifyTextField.text.length == 6)&&(_psdWordField.text.length>0));
    if (!_verifyBtn.isCounting) {
        
        _verifyBtn.enabled = (_phoneTextField.text.length == 11);
        
    }
}

- (IBAction)leftButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickGetVerifyCode:(id)sender
{
    [self.phoneTextField resignFirstResponder];
    
    [self.verifyBtn countingSeconds:MESSAGE_CODE_WAITING_TIME];
    if(self.phoneTextField.text.length > 0) {
        [HXSPersonalInfoModel sendAuthCodeWithPhone:self.phoneTextField.text verifyType:HXSVerifyAppRegister complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
            if(code == kHXSNoError) {
                self.phoneTextField.enabled = NO;
            }else {
                [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2.0];
            }
        }];
    }
    
    // update phone text field status
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(updatePhoneTextFieldStatusToEnable)
                                               object:nil];
    [self performSelector:@selector(updatePhoneTextFieldStatusToEnable)
               withObject:nil
               afterDelay:MESSAGE_CODE_WAITING_TIME];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.phoneTextField) {
        [self.phoneTextField resignFirstResponder];
        [self.verifyTextField becomeFirstResponder];
    }else if(textField == self.verifyTextField) {
        
        [self.verifyTextField resignFirstResponder];
    }else if (textField==self.psdWordField){
    
        [self.psdWordField resignFirstResponder];
    
    }
    
    return YES;
}

-(void)hidenKeyboard
{
    [self.view endEditing:YES];
    [self.phoneTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
    [self.psdWordField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *resultMutableStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMutableStr replaceCharactersInRange:range withString:string];
    
    if (textField == self.phoneTextField) {
        if (PHONE_MAX_LENGTH < [resultMutableStr length]) {
            return NO;
        }
    } else if (textField == self.verifyTextField) {
        if (VERIFIED_CODE_MAX_LENGTH < [resultMutableStr length]) {
            return NO;
        }
    }
    else {
        // Do nothing
    }
    
    return YES;
}


#pragma mark - Target Methods

- (IBAction)onSignInClicked:(id)sender
{
    [self hidenKeyboard];
    
    [MBProgressHUD showInView:self.view];
    [HXSPersonalInfoModel verifAuthCodeWithPhone:self.phoneTextField.text
                                        code:self.verifyTextField.text
                                      verifyType:HXSVerifyAppRegister
                                    complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        if (kHXSNoError != code) {
                                            if ((nil == message)
                                                || (0 >= [message length])) {
                                                message = @"验证码输入错误";
                                            }
                                            
                                            [MBProgressHUD showInViewWithoutIndicator:self.view
                                                                               status:message
                                                                           afterDelay:2.0f];
                                            
                                            return ;
                                            
                                        }
    
                                        [self performSegueWithIdentifier:@"HXSRegisterSetPasswdSegue" sender:nil];
                                        
                                    }];

    
}


#pragma mark - Selector Of Phone Text Field

- (void)updatePhoneTextFieldStatusToEnable
{
    self.phoneTextField.enabled = YES;
}

@end
