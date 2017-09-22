//
//  HXSOrderAppraiseViewController.m
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  商品评价页

#import "HXSOrderAppraiseViewController.h"

// Controllers
#import "HXSOrderAppraiseResultVC.h"
#import "TPKeyboardAvoidingScrollView.h"

// Views
#import "HXSStarView.h"

// Models
#import "HXSOrderViewModel.h"

static NSInteger const kMaxLengthCommentTextView = 90;
static NSString * const shitsStr                 = @"说说哪里不满意，帮店长改进";
static NSString * const praiseStr                = @"夸夸店长，给他更多动力";
static NSString * const placeholderStr           = @"请在这写下你的评价~";

@interface HXSOrderAppraiseViewController ()<UITextViewDelegate>

@property (nonatomic, strong) HXShopInfo *shopInfo;
@property (nonatomic, strong) NSString   *orderId;

@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *headImageView;    // 头像
@property (nonatomic, weak) IBOutlet UILabel     *shopNameLabel;    // 店铺名称
@property (nonatomic, weak) IBOutlet HXSStarView *starView;         // 星星评分
@property (nonatomic, weak) IBOutlet UIView      *commentContainer;
@property (nonatomic, weak) IBOutlet UITextView  *commentTextView;  // 评论输入
@property (nonatomic, weak) IBOutlet UILabel     *placeholderLabel;
@property (nonatomic, weak) IBOutlet UILabel     *wordCountLabel;   // 评论字数统计
@property (nonatomic, weak) IBOutlet UIButton    *submitButton;     // 评论提交按钮

@end

@implementation HXSOrderAppraiseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initScrollView];
    
    [self initialHeadImageView];
    
    [self showShopInfo];
    
    [self initialStarView];
    
    [self initialCommentContainer];
    
    [self initialCommentTextView];
    
    [self initialSubmitButton];
    
    [self registNoticies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UITextFieldTextDidChangeNotification
                                                 object:self.commentTextView];
}

+ (instancetype)controllerWithShopInfo:(HXShopInfo *)shopInfo
                               orderId:(NSString *)order_id
{
    HXSOrderAppraiseViewController *controller = [HXSOrderAppraiseViewController controllerFromXib];
    controller.shopInfo = shopInfo;
    controller.orderId  = order_id;
    
    return controller;
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"评价";
}

- (void)initScrollView
{
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 600)];
}

- (void)initialHeadImageView
{
    self.headImageView.layer.cornerRadius = 18;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)initialStarView
{
    self.starView.backgroundColor = [UIColor clearColor];
    [self.starView addTarget:self
                      action:@selector(starViewScoreChange)
            forControlEvents:UIControlEventValueChanged];
}

- (void)initialCommentContainer
{
    self.commentContainer.backgroundColor    = [UIColor whiteColor];
    self.commentContainer.layer.cornerRadius = 4;
    self.commentContainer.layer.borderColor  = HXS_COLOR_SEPARATION_STRONG.CGColor;
    self.commentContainer.layer.borderWidth  = 1;
}

- (void)initialCommentTextView
{
    self.commentTextView.backgroundColor = [UIColor clearColor];
    self.commentTextView.delegate        = self;
}

- (void)initialSubmitButton
{
    self.submitButton.layer.cornerRadius = 6;
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithR:255 G:255 B:255 A:0.4]
                            forState:UIControlStateDisabled];
    
    self.submitButton.enabled = NO;
    
    [self.submitButton addTarget:self
                          action:@selector(evaluateButtonClicked)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)registNoticies
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(commentTextViewValueChanged:)
                                                name:UITextViewTextDidChangeNotification
                                              object:self.commentTextView];
}


#pragma mark - Target/Action

- (void)starViewScoreChange
{
    if (0 == self.starView.currentScore) {
        self.placeholderLabel.text = placeholderStr;
    } else if (self.starView.currentScore <= 3) {
        self.placeholderLabel.text = shitsStr;
    } else {
        self.placeholderLabel.text = praiseStr;
    }
    
    [self updateSubmintButtonState];
}

- (void)commentTextViewValueChanged:(NSNotification *)obj
{
    NSString *toBeString = self.commentTextView.text;
    
    self.placeholderLabel.hidden = toBeString.length > 0 ? YES : NO;
    
    NSString *lang =  [self.commentTextView.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self.commentTextView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self.commentTextView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLengthCommentTextView) {
                self.commentTextView.text = [toBeString substringToIndex:kMaxLengthCommentTextView];
            }
        } else {  // 有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
    } else {  // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLengthCommentTextView) {
            self.commentTextView.text = [toBeString substringToIndex:kMaxLengthCommentTextView];
        }
    }
    self.wordCountLabel.text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)self.commentTextView.text.length,(long)kMaxLengthCommentTextView];
}

- (void)updateSubmintButtonState
{
    if (self.starView.currentScore > 0) {
        self.submitButton.enabled = YES;
    } else {
        self.submitButton.enabled = NO;
    }
}


#pragma mark - private mothed

- (void)showShopInfo
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.shopInfo.shopAvatarStr]placeholderImage:[UIImage imageNamed:@"ic_shop_logo"]];
    self.shopNameLabel.text = self.shopInfo.shopNameStr;
}

- (void)gotoAppraiseResultVC
{
    HXSOrderAppraiseResultVC *orderAppraiseResultVC = [HXSOrderAppraiseResultVC controllerFromXib];
    [self replaceCurrentViewControllerWith:orderAppraiseResultVC animated:YES];
}


#pragma mark - webservice

- (void)evaluateButtonClicked
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSOrderViewModel evaluateOrderWithOrderId:self.orderId
                                         itemId:nil
                                          score:self.starView.currentScore
                                        content:self. commentTextView.text complete:^(HXSErrorCode status, NSString *message, NSDictionary *dic) {
                                            
                                            [HXSLoadingView closeInView:weakSelf.view];
                                            
                                            if (kHXSNoError == status) {
                                                
                                                if ([self.delegate performSelector:@selector(appraiseSuccess) withObject:nil]) {
                                                    
                                                    [self.delegate appraiseSuccess];
                                                }
                                                
                                                [weakSelf gotoAppraiseResultVC];
                                            } else {
                                                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                            }
                                            
        
    }];
}



@end
