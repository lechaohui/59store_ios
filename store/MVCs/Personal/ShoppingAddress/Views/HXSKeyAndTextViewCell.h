//
//  HXSKeyAndTextViewCell.h
//  store
//
//  Created by 格格 on 16/9/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSKeyAndTextViewCellDelegate<NSObject>

- (void)valueTextFieldChange:(UITextField *)valueTextField;

@end

@interface HXSKeyAndTextViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *keyLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *valueTextField;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *valueTextFieldWidth;

@property (nonatomic, weak) id<HXSKeyAndTextViewCellDelegate> delegate;

+ (instancetype)keyAndTextViewCell;

@end
