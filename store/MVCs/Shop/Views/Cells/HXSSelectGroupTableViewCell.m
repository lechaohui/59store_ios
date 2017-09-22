//
//  HXSSelectGroupTableViewCell.m
//  store
//
//  Created by caixinye on 2017/9/1.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSSelectGroupTableViewCell.h"
// Model
#import "HXSStoreAppEntryEntity.h"

@interface HXSSelectGroupTableViewCell()

@property(nonatomic,strong)UIImageView *lftTopImgView;

@property(nonatomic,strong)UIImageView *lftButtomImgView;

@property(nonatomic,strong)UIImageView *rhtTopImgView;

@property(nonatomic,strong)UIImageView *rhtButomImgView;

@property (copy, nonatomic) NSString *linkURL;
@property (copy, nonatomic) NSArray *adModelArray;

@end

@implementation HXSSelectGroupTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{


    if(self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor colorWithHexString:@"eeeeee"];
        [self createUI];
    }
    return self;
    



}
-(void)createUI{

    CGFloat imgWidth = (CGRectGetWidth(self.frame)-9-9-3)/2.00;
    CGFloat imgHeight = (CGRectGetHeight(self.frame)-11-11-2)/2.00;
    self.lftTopImgView = [Maker makeImgView:CGRectMake(9, 11, imgWidth, imgHeight) img:@"img_kp_shouyejiazai_left"];
    self.lftButtomImgView = [Maker makeImgView:CGRectMake(9, CGRectGetMaxY(self.lftTopImgView.frame)+2, imgWidth, imgHeight) img:@"img_kp_shouyejiazai_left"];
    self.rhtTopImgView = [Maker makeImgView:CGRectMake(CGRectGetMaxX(self.lftTopImgView.frame)+3, 11, imgWidth, imgHeight) img:@"img_kp_shouyejiazai_right"];
    self.rhtButomImgView = [Maker makeImgView:CGRectMake(CGRectGetMinX(self.rhtTopImgView.frame), CGRectGetMinY(self.lftButtomImgView.frame), imgWidth, imgHeight) img:@"img_kp_shouyejiazai_right"];
    
    self.lftTopImgView.userInteractionEnabled = YES;
    self.lftButtomImgView.userInteractionEnabled = YES;
    self.rhtTopImgView.userInteractionEnabled = YES;
    self.rhtButomImgView.userInteractionEnabled = YES;
    
    self.lftTopImgView.tag = 1;
    self.lftButtomImgView.tag = 2;
    self.rhtTopImgView.tag = 3;
    self.rhtButomImgView.tag = 4;
    
    UITapGestureRecognizer *tapGestureRecognizerLefttop        = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTagAction:)];
    UITapGestureRecognizer *tapGestureRecognizerLeftbuto        = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTagAction:)];
    UITapGestureRecognizer *tapGestureRecognizerrhtop        = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTagAction:)];
    UITapGestureRecognizer *tapGestureRecognizerrhtbuto        = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTagAction:)];
    
    [self.lftTopImgView addGestureRecognizer:tapGestureRecognizerLefttop];
    [self.lftButtomImgView addGestureRecognizer:tapGestureRecognizerLeftbuto];
    [self.rhtTopImgView addGestureRecognizer:tapGestureRecognizerrhtop];
    [self.rhtButomImgView addGestureRecognizer:tapGestureRecognizerrhtbuto];
    
    
    [self.contentView addSubview:self.lftTopImgView];
    [self.contentView addSubview:self.lftButtomImgView];
    [self.contentView addSubview:self.rhtTopImgView];
    [self.contentView addSubview:self.rhtButomImgView];
    

    

}
- (void)imageViewTagAction:(UITapGestureRecognizer*)sender{


    UIImageView *imageView = (UIImageView *)[sender view];
    
    NSInteger tag = imageView.tag;
    HXSStoreAppEntryEntity *adModel = self.adModelArray[tag - 1];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectGroupTableViewCellImageTaped:)])
    {
        [self.delegate performSelector:@selector(SelectGroupTableViewCellImageTaped:) withObject:adModel.linkURLStr];
    }
    
    
    


}
- (void)setupItemImages:(NSArray<HXSStoreAppEntryEntity *> *)slideItemsArr{


    if (0 == slideItemsArr.count) {
        return;
    }
    _adModelArray = slideItemsArr;
    
    NSURL *url = nil;
    for (HXSStoreAppEntryEntity *model in slideItemsArr){

        NSInteger index = [slideItemsArr indexOfObject:model];
        url = [NSURL URLWithString:model.imageURLStr];
        if (0 == index){
        
            //左上
            
        
        }else if (1==index){
            //左下
        
        
        }else if (2==index){
            //右上
        
        
        }else{
        
            //右下
        
        
        }
        
        
    
    }



}
+ (CGFloat)getCellHeightWithObject:(HXSStoreAppEntryEntity *)storeAppEntryEntity{

    if (nil == storeAppEntryEntity) {
        return 0.1f;
    }
//    CGFloat scale = [storeAppEntryEntity.imageHeightIntNum floatValue]/[storeAppEntryEntity.imageWidthIntNum floatValue];
//    
//    if (isnan(scale)
//        || isinf(scale)) {
//        scale = 1.0;
//    }
//    
//    return SCREEN_WIDTH / 3 * scale + 30;
    
    return [storeAppEntryEntity.imageHeightIntNum floatValue]*2+22+2;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
