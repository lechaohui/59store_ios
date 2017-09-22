//
//  HXSCheckoutAddrssTableViewCell.m
//  Pods
//
//  Created by J006 on 16/9/2.
//
//

#import "HXSPrintCheckoutAddrssTableViewCell.h"

@interface HXSPrintCheckoutAddrssTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *shoppingTitle;//"收货人"
@property (weak, nonatomic) IBOutlet UILabel *shoppingNameLabel;//收货人姓名
@property (weak, nonatomic) IBOutlet UILabel *shoppingPhone;//收获电话
@property (weak, nonatomic) IBOutlet UILabel *shoppingAddressContentLabel;//收货地址主要内容
@property (weak, nonatomic) IBOutlet UILabel *inforLabel;//请选择收货地址

@end

@implementation HXSPrintCheckoutAddrssTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - init

- (void)initCheckoutAddrssTableViewCellWithAdress:(HXSPrintShoppingAddress *)shoppingAddress
{
    if(!shoppingAddress) {
        [_shoppingTitle setHidden:YES];
        [_shoppingNameLabel setHidden:YES];
        [_shoppingPhone setHidden:YES];
        [_shoppingAddressContentLabel setHidden:YES];
        [_inforLabel setHidden:NO];
    } else {
        [_shoppingTitle setHidden:NO];
        [_shoppingNameLabel setHidden:NO];
        [_shoppingPhone setHidden:NO];
        [_shoppingAddressContentLabel setHidden:NO];
        [_inforLabel setHidden:YES];
        
        NSString *detailAddressStr = [NSString stringWithFormat:@"%@%@%@%@",
                                      shoppingAddress.siteNameStr,
                                      shoppingAddress.dormentryZoneNameStr,
                                      shoppingAddress.dormentryNameStr,
                                      shoppingAddress.detailAddressStr];
        [_shoppingNameLabel setText:shoppingAddress.contactNameStr];
        [_shoppingPhone setText:shoppingAddress.contactPhoneStr];
        [_shoppingAddressContentLabel setText:[NSString stringWithFormat:@"收货地址:%@",detailAddressStr]];
    }
}

@end
