//
//  HXSShopNameTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/1/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopNameTableViewCell.h"

#import "HXSShopEntity.h"
#import <objc/runtime.h>


// 0夜猫店  1饮品店  2打印店 3云超市 4水果店
typedef NS_ENUM(NSInteger, ShopType){
    kShopTypeDorm   = 0,
    kShopTypeDrink  = 1,
    kShopTypePrint  = 2,
    kShopTypeMarket = 3,
    kShopTypeFruit  = 4,
};

static NSInteger const kMaxPromotionImageNumber = 3;


@interface HXSShopNameTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView      *logoContainterView;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel     *shopNameLabel;
/**共x种商品*/
@property (weak, nonatomic) IBOutlet UILabel     *shopSKUAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel     *shopDeliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel     *shopAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel     *deliveryMinAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel     *shopNoticeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *restingLabel;
@property (weak, nonatomic) IBOutlet UILabel     *canBookLabel;

@property (weak, nonatomic) IBOutlet UIImageView *activeImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *activeImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *activeImageView3;

@end

@implementation HXSShopNameTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 添加头像描边
    self.logoContainterView.layer.borderWidth = 1;
    self.logoContainterView.layer.borderColor = [UIColor colorWithRGBHex:0xd8dcdf].CGColor;
    self.logoContainterView.layer.cornerRadius = 15;
    self.logoContainterView.layer.masksToBounds = YES;
    
    UIBezierPath *restingLabelMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.restingLabel.bounds
                                                               byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight |
                                                                                 UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                     cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *restingMaskLayer = [[CAShapeLayer alloc] init];
    restingMaskLayer.frame = self.restingLabel.bounds;
    restingMaskLayer.path = restingLabelMaskPath.CGPath;
    self.restingLabel.layer.mask = restingMaskLayer;
    
    UIBezierPath *canBookLabelMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.canBookLabel.bounds
                                                               byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                     cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *canBookMaskLayer = [[CAShapeLayer alloc] init];
    canBookMaskLayer.frame = self.canBookLabel.bounds;
    canBookMaskLayer.path = canBookLabelMaskPath.CGPath;
    self.canBookLabel.layer.mask = canBookMaskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark - Public Methods

- (void)setupCellWithEntity:(HXSShopEntity *)entity
{
    // shop image
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:entity.shopLogoURLStr]
                          placeholderImage:[UIImage imageNamed:@"ic_shop_logo"]];
    
    // shop type image
    UIImage *shopTypeImage = nil;
    switch ([entity.shopTypeIntNum integerValue]) {
        case kHXSShopTypeDorm:
        {
            shopTypeImage = entity.statusIntNum.intValue==0?[UIImage imageNamed:@"ic_nightshop_close"]:[UIImage imageNamed:@"ic_nightshop_open"];
        }
            break;
        case kHXSShopTypeDrink:
        {
        }
            break;
        case kHXSShopTypePrint:
        {
            shopTypeImage = entity.statusIntNum.intValue==0?[UIImage imageNamed:@"ic_printshop_close"]:[UIImage imageNamed:@"ic_printshop_open"];
        }
            break;
        default:
        {
        }
            break;
    }
    
    [self.shopTypeImageView setImage:nil];
    
    if(entity.shopTypeImageUrlStr.length > 0) {
        [self.shopTypeImageView sd_setImageWithURL:[NSURL URLWithString:entity.shopTypeImageUrlStr]
                              placeholderImage:nil];
    } else {
        [self.shopTypeImageView setImage:shopTypeImage];
    }
    
    // name
    self.shopNameLabel.text = entity.shopNameStr;

    // SKU
    if([entity.shopTypeIntNum integerValue] == kShopTypePrint) {
        [self.shopSKUAmountLabel setHidden:YES];
    } else {
        [self.shopSKUAmountLabel setHidden:NO];
        
        // sku amount
        self.shopSKUAmountLabel.text = [NSString stringWithFormat:@"共%ld种商品", (long)[entity.itemNumIntNum intValue]];
    }
    
    // status label
    switch ([entity.statusIntNum integerValue]) {
        case 0: // 休息中
        {
            self.restingLabel.hidden = NO;
            self.canBookLabel.hidden = YES;
        }
            break;
            
        case 1: // 营业中
        {
            self.restingLabel.hidden = YES;
            self.canBookLabel.hidden = YES;
        }
            break;
            
        case 2: // 可预订
        {
            self.restingLabel.hidden = YES;
            self.canBookLabel.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    // delivery min
    if([entity.shopTypeIntNum integerValue] == kShopTypePrint) {
        self.deliveryMinAmountLabel.text = [NSString stringWithFormat:@"￥%@配送", [self convertStringFromFloatNum:entity.deliveryFeeFloatNum]];
    } else {
        self.deliveryMinAmountLabel.text = [NSString stringWithFormat:@"￥%@起送", [self convertStringFromFloatNum:entity.minAmountFloatNum]];
    }
    
    
    // delivery
    if([entity.shopTypeIntNum integerValue] == kShopTypePrint) {
        if (2 == [entity.deliveryStatusIntNum integerValue]) {
            self.shopDeliveryLabel.text = @"仅限上门自取";
            
            [self.deliveryMinAmountLabel setHidden:YES];
        } else {
            self.shopDeliveryLabel.text = [NSString stringWithFormat:@"满￥%.f免配送费", [entity.freeDeliveryAmountFloatNum floatValue]];
            
            [self.deliveryMinAmountLabel setHidden:NO];
        }
    } else {
        switch ([entity.deliveryStatusIntNum integerValue]) {
            case 0:
            {
                self.shopDeliveryLabel.text = @"送到寝室";
            }
                break;
                
            case 1:
            {
                self.shopDeliveryLabel.text = @"送到楼下";
            }
                break;
                
            case 2:
            {
                self.shopDeliveryLabel.text = @"只限自取";
            }
                
            default:
                break;
        }
    }
    
    // address
    self.shopAddressLabel.text = entity.shopAddressStr;

    // promotion
    int imageViewIndex = kMaxPromotionImageNumber;
    
    if(entity.promotionsArr.count > 0) {
        for (int i = 0; i < [entity.promotionsArr count]; i++) {
            //最多只有3个活动  产品已经确认
            if (i < imageViewIndex) {
                HXSPromotionsEntity *activityEntity = entity.promotionsArr[i];
                NSString *imageViewStr = [NSString stringWithFormat:@"_activeImageView%d", imageViewIndex];
                Ivar ivar = class_getInstanceVariable([self class], [imageViewStr UTF8String]);
                id imageViewObj = object_getIvar(self, ivar);
                UIImageView *imageView = (UIImageView *)imageViewObj;
                [imageView sd_setImageWithURL:[NSURL URLWithString:activityEntity.promotionImageStr]];
                imageViewIndex -- ;
            }
        }
    } else {
        self.activeImageView1.image = nil;
        self.activeImageView2.image = nil;
        self.activeImageView3.image = nil;
    
    }
    
    // notice
    if (entity.statusIntNum.integerValue == kHXSShopStatusClosed
        && entity.shopTypeIntNum.integerValue == kHXSShopTypeStore) {
        self.shopNoticeLabel.text = [NSString stringWithFormat:@"同学很抱歉,该店铺已经打烊了,营业时间: %@", entity.businesHoursStr];
    } else {
        self.shopNoticeLabel.text = entity.noticeStr;
    }
}

#pragma mark - Private Methods

- (NSString *)convertStringFromFloatNum:(NSNumber *)floatNum
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.00"];
    NSString *tempFloatStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:([floatNum floatValue] * 100)]];  // yuan to fen
    
    NSInteger tempInt = [tempFloatStr integerValue];
    
    NSInteger result = tempInt % 100;
    if (0 == result) {
        NSString *str = [NSString stringWithFormat:@"%zd", tempInt/100];
        
        return str;
    }
    
    result = tempInt % 10;
    if (0 == result) {
        NSString *str = [NSString stringWithFormat:@"%zd.%zd", tempInt/100, (tempInt % 100)/10];
        
        return str;
    }
    
    NSString *str = [NSString stringWithFormat:@"%zd.%zd%zd", tempInt/100, (tempInt % 100)/10, (tempInt % 100)%10];
    
    return str;
}

@end
