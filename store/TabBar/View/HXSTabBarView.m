//
//  HXSTabBarView.m
//  store
//
//  Created by ArthurWang on 2016/10/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTabBarView.h"

#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"


static NSInteger TAG_BASIC = 1000;
static NSInteger kPadding  = 10;


@interface HXSTabBarView ()

@property (nonatomic, weak) UIButton *selectedBtn;

@property (nonatomic, strong) NSMutableArray *barItemMArr;
@property (nonatomic, strong) NSMutableArray *gifDataMArr;

@property (nonatomic, strong) FLAnimatedImageView *imageView;





@end

@implementation HXSTabBarView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        //[self creatUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.barItemMArr.count;
    
    for (int i = 0; i < self.barItemMArr.count; i++) {
        
        UIButton *button = self.barItemMArr[i];
        
        button.tag = i + TAG_BASIC;
        
        CGFloat x = i * self.bounds.size.width / count;
        CGFloat y = 0;
        CGFloat width = self.bounds.size.width / count;
        CGFloat height = self.bounds.size.height;
        
        button.frame = CGRectMake(x, y, width, height);
        
    }

//    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.centerButton addTarget:self action:@selector(centerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.centerButton setImage:[UIImage imageNamed:@"btn_release.png"] forState:UIControlStateNormal];
//    [self addSubview:self.centerButton];
//    
//    
//    NSUInteger count = self.barItemMArr.count%2 == 0 ? self.barItemMArr.count:self.barItemMArr.count+1;
//    
//    /***中间按钮的宽高 */
//    CGFloat centerButtonWH = 60;
//    /** 普通按钮的高度 */
//    CGFloat buttonHeight = 48.5;
//    /** 普通按钮的宽度 */
//    CGFloat buttonWidth =(self.frame.size.width- centerButtonWH - 20)/count;
//    CGFloat centerButtonX = (self.frame.size.width - centerButtonWH)*0.5;
//    self.centerButton.frame = CGRectMake(centerButtonX, self.frame.size.height - centerButtonWH-7.5, centerButtonWH, 70);
//    //buttonWidth = (self.frame.size.width- centerButtonWH - 20)/count;
//    
//    CGFloat buttonX = 0;
//    for (int i = 0; i < self.barItemMArr.count;i ++) {
//        
//        UIButton * button = self.barItemMArr[i];
//        button.tag = i + TAG_BASIC;
//        if ( (button.tag-TAG_BASIC) == count/2) {
//            
//            buttonX += centerButtonWH + 20;
//            
//        }
//        button.frame = CGRectMake(buttonX, 0.5, buttonWidth, buttonHeight);
//        buttonX += buttonWidth;
//    
//    }
    
}


#pragma mark - Public Methods
- (void)addButtonWithImage:(UIImage *)image selectdImage:(UIImage *)selectedImage gif:(NSData *)gifData
{
    // Gif
    [self.gifDataMArr addObject:gifData];
    
    // Buttons
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[self changeScaleFromImage:image] forState:UIControlStateNormal];
    [button setImage:[self changeScaleFromImage:image] forState:UIControlStateHighlighted];
    [button setImage:[self changeScaleFromImage:selectedImage] forState:UIControlStateSelected];
    [button setImageEdgeInsets:UIEdgeInsetsMake(-kPadding, 0, 0, 0)];
    
    [button addTarget:self
               action:@selector(onClickBtn:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.barItemMArr addObject:button];

    [self addSubview:button];
    
    if (1 == [self.subviews count]) {
        self.selectedBtn = button;
        self.selectedBtn.selected = YES;
        
        [self onClickBtn:button];

    }

}

- (void)clearUpImageAndGif
{
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    [self.gifDataMArr removeAllObjects];
    
    [self.barItemMArr removeAllObjects];

}

- (void)selectedFrom:(NSInteger)from to:(NSInteger)to
{
    UIButton *fromButton = [self.barItemMArr objectAtIndex:from];
    UIButton *toButton   = [self.barItemMArr objectAtIndex:to];
    
    fromButton.selected = NO;
    toButton.selected = YES;
    
    self.selectedBtn = toButton;
}

#pragma mark - Target Methods
- (void)centerButtonClick:(UIButton *)sender{


    [self.delegate tabBarViewCenterItemClick:sender];
    

}
- (void)onClickBtn:(UIButton *)btn
{
    if (self.imageView.isAnimating) {
        return;
    }
    
    BOOL canSelected = NO;
    
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)]) {
        canSelected = [self.delegate tabBar:self
                               selectedFrom:(self.selectedBtn.tag - TAG_BASIC)
                                         to:(btn.tag - TAG_BASIC)];
    }
    
    if (!canSelected) {
        // Do not jump to the selected item
        return;
    }
    
    
    BOOL differentBtn = self.selectedBtn.tag != btn.tag;
    
    if (differentBtn) {
        self.selectedBtn.selected = NO;
        self.selectedBtn = btn;
        
        [self showGifAtBtn:btn];
    }
}

- (void)showGifAtBtn:(UIButton *)btn
{
    if (0.00 >= btn.center.x) {
        [self disappearGif];
        
        return;
    }
    
    NSData *data         = [self.gifDataMArr objectAtIndex:btn.tag - TAG_BASIC];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    
    if (nil == image) {
        [self disappearGif];
        
        return;
    }
    
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(0, 0, btn.imageView.image.size.width, btn.imageView.image.size.height);
    imageView.center = btn.center;
    CGRect frame = imageView.frame;
    frame.origin.y -= (kPadding / 2.0);
    imageView.frame = frame;
    imageView.userInteractionEnabled = NO;
    
    [self addSubview:imageView];
    
    imageView.animationRepeatCount = 1;
    [imageView startAnimating];
    
    self.imageView = imageView;
    
    [self.imageView addObserver:self
                     forKeyPath:@"currentFrameIndex"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
}

- (void)disappearGif
{
    [self.imageView stopAnimating];
    [self.imageView removeFromSuperview];
    
    [self.selectedBtn setSelected:YES];
    
    [self.imageView removeObserver:self
                        forKeyPath:@"currentFrameIndex"];
}


#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    FLAnimatedImageView *imageView = object;
    
    if ([[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue] == imageView.animatedImage.frameCount) {
       
        
        [self disappearGif];
    }
}


#pragma mark - UIImage Change Scale

- (UIImage *)changeScaleFromImage:(UIImage *)image
{
    NSData *data = UIImagePNGRepresentation(image);
    
    NSInteger standardWidth = 24;
    CGFloat scale = image.size.width / standardWidth;
    if (1.0 < scale) {
        
        image = [[UIImage alloc] initWithData:data scale:scale];
        
    }
    
    return image;
}

#pragma mark - Getter Methods

- (NSMutableArray *)barItemMArr
{
    if (nil == _barItemMArr) {
        
        _barItemMArr = [[NSMutableArray alloc] initWithCapacity:5];
        
    }
    
    return _barItemMArr;
    
}

- (NSMutableArray *)gifDataMArr
{
    
    if (nil == _gifDataMArr) {
        _gifDataMArr = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _gifDataMArr;
}

@end
