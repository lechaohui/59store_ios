//
//  HXSSubscribeBankCardBottomCell.h
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat subscribeAuthorizeBottomCellHeight = 124;

@interface HXSSubscribeBankCardBottomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton           *agreementBtn;
/** 开通经营贷、59钱包协议 */
@property (weak, nonatomic) IBOutlet UIButton           *openLoanContractButton;
/** 正式提交开通申请 */
@property (weak, nonatomic) IBOutlet HXSRoundedButton  *submitButton;

@end
