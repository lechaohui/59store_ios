//
//  SegmentControl.m
//  store
//
//  Created by caixinye on 2017/8/27.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "SegmentControl.h"

@interface SegmentControl() <UIScrollViewDelegate>
@property(nonatomic, strong) NSMutableArray<UIButton *> *titleButtons;

@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, strong) UIView *bottomSlideView; // 底部滑块
@property(nonatomic, weak) UIButton *selectedButton;
@property(nonatomic, weak) MASConstraint *blockLeftConstraint;
@property(nonatomic, assign) NSInteger previousIndex;
@property (nonatomic, strong) UIView *bottomLineView; // 底部line

@end
@implementation SegmentControl

#pragma mark - initial

- (instancetype)initWithTitles:(NSArray *)titles {
    
    if (self = [self init]) {
        _titles = titles;
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Getter & Setter
- (void)setBlockX:(CGFloat)blockX {
    _blockX = blockX;
    _blockLeftConstraint.offset = blockX;
    NSInteger index = blockX / self.bottomSlideView.width + 0.5;
    _currentIndex = index;
    UIButton *currentButton = _titleButtons[index];
    self.selectedButton.selected = NO;
    currentButton.selected = YES;
    self.selectedButton = currentButton;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    scrollView.delegate = self;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    for (UIButton *titleButton in _titleButtons) {
        [titleButton setTitleColor:titleColor forState:UIControlStateNormal];
        [titleButton setTitleColor:titleColor forState:UIControlStateHighlighted];
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    for (UIButton *titleButton in _titleButtons) {
        [titleButton setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
}

- (void)setBottomSlideViewColor:(UIColor *)bottomSlideViewColor {
    self.bottomSlideView.backgroundColor = bottomSlideViewColor;
}

- (UIView *)bottomLineView {
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithRGBHex:0xe1e2e3];
    }
    return _bottomLineView;
}


#pragma mark - Setup
- (void)setupSubViews {
    self.titleButtons = [NSMutableArray arrayWithCapacity:_titles.count];
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *titleButton = [[UIButton alloc] init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleBtnOnClick:animated:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitle:self.titles[i] forState:UIControlStateNormal];
        
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        if (i == 0) {
            titleButton.selected = YES;
            self.selectedButton = titleButton;
            self.previousIndex = 0;
        }
        
        [self addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
    }
    
    [self addSubview:self.bottomLineView];
    
    self.bottomSlideView = [[UIView alloc] init];
    [self addSubview:self.bottomSlideView];
    
}


- (void)updateConstraints {
    
    if (!_didSetupConstraint) {
        
        UIButton *lastButton;
        for (int i = 0; i < _titleButtons.count; i++) {
            UIButton *titleButton = _titleButtons[i];
            [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.height.equalTo(self.mas_height);
                make.left.equalTo(lastButton?lastButton.mas_right:self.mas_left);
                make.width.equalTo(self.mas_width).multipliedBy(1.0 / self.titleButtons.count);
            }];
            lastButton = titleButton;
        }
        
        [self.bottomSlideView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.blockLeftConstraint = make.left.equalTo(self);
            make.width.equalTo(self.mas_width).multipliedBy(1.0 / self.titleButtons.count);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(3);
        }];
        
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
        }];
        
        _didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Action Methods
- (void)titleBtnOnClick:(UIButton *)button animated:(BOOL)animated{
    if ([self.delegate respondsToSelector:@selector(selectedIndexWillChange)]) {
        [self.delegate selectedIndexWillChange];
    }
    if (self.currentIndex == button.tag) {
        if ([self.delegate respondsToSelector:@selector(selectedCurrentTitleButton)]) {
            [self.delegate selectedCurrentTitleButton] ;
        }
        return ;
    };
    if (self.scrollView) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * button.tag, 0) animated:animated];
        if (!animated) {
            [self scrollViewDidEndScrollingAnimation:self.scrollView];
        }
    } else {
        NSAssert(self.scrollView == nil, @"scrollView must not nil");
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.blockX = scrollView.contentOffset.x / self.titles.count;
}

// 点击按钮滚动停止时触发
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.selectedButton.tag == self.previousIndex) return;
    self.previousIndex = self.selectedButton.tag;
    if ([self.delegate respondsToSelector:@selector(selectedChanged:)]) {
        [self.delegate selectedChanged:_currentIndex];
    }
}

// 手动滚动停止时触发
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_selectedButton.tag == self.previousIndex) return;
    self.previousIndex = self.selectedButton.tag;
    if ([self.delegate respondsToSelector:@selector(selectedChanged:)]) {
        [self.delegate selectedChanged:self.currentIndex];
    }
}
// 手动滚动抬起手指时停止时触发
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if ([self.delegate respondsToSelector:@selector(selectedChanged:)]) {
            [self.delegate selectedChanged:self.currentIndex];
        }
    }
}

#pragma mark - public method

- (void)setNoticeCount:(NSNumber *)noticeCount messageCount:(NSNumber *)messageCount {
    UIButton *noticeBtn = self.titleButtons.firstObject;
    UIButton *messageBtn = self.titleButtons.lastObject;
    if (noticeCount.integerValue > 0) {
        [noticeBtn setTitle:[NSString stringWithFormat:@"公告（%zd）",noticeCount.integerValue] forState:UIControlStateNormal];
    } else {
        [noticeBtn setTitle:@"公告" forState:UIControlStateNormal];
    }
    if (messageCount.integerValue > 0) {
        [messageBtn setTitle:[NSString stringWithFormat:@"消息（%zd）",messageCount.integerValue] forState:UIControlStateNormal];
    } else {
        [messageBtn setTitle:@"消息" forState:UIControlStateNormal];
    }
    
}




@end
