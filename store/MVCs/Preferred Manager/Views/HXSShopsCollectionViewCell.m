//
//  HXSShopsCollectionViewCell.m
//  store
//
//  Created by caixinye on 2017/9/4.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSShopsCollectionViewCell.h"
#import "HXSShopEntity.h"
#import <objc/runtime.h>

@interface HXSShopsCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLb;

@property (weak, nonatomic) IBOutlet UIButton *statusBut;
@property (weak, nonatomic) IBOutlet UIButton *dormBut;
@property (weak, nonatomic) IBOutlet UILabel *placeLb;

@property (weak, nonatomic) IBOutlet UILabel *priceLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;


@end
@implementation HXSShopsCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    //头像处理
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 20;
//    [self.nameLb sizeToFit];
//    [self.statusBut.titleLabel sizeToFit];
//    [self.dormBut.titleLabel sizeToFit];
//    [self.placeLb sizeToFit];
//    [self.priceLb sizeToFit];
//    [self.timeLb sizeToFit];
    
    
    
    
    
    

}
- (void)setSelected:(BOOL)selected{


    [super setSelected:selected];


}
#pragma mark - Public Methods
- (void)setupCellWithEntity:(HXSShopEntity *)entity{


    //icon
    [self.icon sd_setImageWithURL:[NSURL URLWithString:entity.shopLogoURLStr] placeholderImage:[UIImage imageNamed:@"ic_shop_logo"]];
    
    if (entity.shopNameStr) {
       
        //name
        self.nameLb.text = entity.shopNameStr;
        
        
    }
   
    
    //商品数量
    self.descriptionLb.text = [NSString stringWithFormat:@"共%ld种商品", (long)[entity.itemNumIntNum intValue]];
    
    // status label
    switch ([entity.statusIntNum integerValue]) {
        case 0: // 休息中
        
            [self.statusBut setTitle:@"休息中" forState:UIControlStateNormal];
            [self.statusBut setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
            [self.dormBut setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
        
            break;
            
        case 1: // 营业中
        [self.statusBut setTitle:@"营业中" forState:UIControlStateNormal];
            break;
            
        case 2: // 可预订
       [self.statusBut setTitle:@"可预订" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    //dorm
    switch ([entity.deliveryStatusIntNum integerValue]) {
        case 0:
        {
            
            [self.dormBut setTitle:@"送到寝室" forState:UIControlStateNormal];
        }
            break;
            
        case 1:
        {
            [self.dormBut setTitle:@"送到楼下" forState:UIControlStateNormal];
        }
            break;
            
        case 2:
        {
            [self.dormBut setTitle:@"只限自取" forState:UIControlStateNormal];
        }
            
        default:
            break;
    }
   
    
    //place
    self.placeLb.text = entity.shopAddressStr;
    //起送范围
    self.priceLb.text = [NSString stringWithFormat:@"￥%.f元起送", [entity.minAmountFloatNum floatValue]];
    if (entity.businesHoursStr) {
        
        //营业时间
        self.timeLb.text = [NSString stringWithFormat:@"营业时间: %@",entity.businesHoursStr];
        
    }else{
    
        //营业时间
        self.timeLb.text = [NSString stringWithFormat:@"营业时间: 无"];
    
    
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
