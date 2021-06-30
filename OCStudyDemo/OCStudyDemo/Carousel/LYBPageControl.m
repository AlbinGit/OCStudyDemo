//
//  LYBPageControl.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2021/6/30.
//  Copyright © 2021 Albin. All rights reserved.
//

#import "LYBPageControl.h"

@interface LYBPageControl (){
    NSMutableArray * _dots;
    CGRect _frameRect;
    CGSize _currentImageSize;
    CGSize _nomalImageSize;
}
@property (nonatomic ,strong) UIImageView * currentImageView;
@end

@implementation LYBPageControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置frame
        _frameRect = frame;
        // 初始化
        self.backgroundColor = [UIColor clearColor];
        _dots = [NSMutableArray array];
        self.currentPage = 0;
    }
    return self;
}
- (void)setImagePageStateNormal:(UIImage *)imagePageStateNormal{
    _imagePageStateNormal = imagePageStateNormal;
    _nomalImageSize = imagePageStateNormal.size;
}
- (void)setImagePageStateHighlighted:(UIImage *)imagePageStateHighlighted{
    _imagePageStateHighlighted = imagePageStateHighlighted;
    _currentImageSize = imagePageStateHighlighted.size;
}
- (void)setCurrentPage:(NSInteger)currentPage{
    if (currentPage == _currentPage || currentPage < 0 || currentPage >= _dots.count) {
        return;
    }

    UIView * currentDot = self.currentImageView;
    UIView * exchangeDot = [_dots objectAtIndex:currentPage];
    if (currentPage > _currentPage) {
        currentDot.left = exchangeDot.left-(currentDot.width-exchangeDot.width);
        for (NSInteger i = _currentPage + 1; i <= currentPage; i ++) {
            UIView * dot = [_dots objectAtIndex:i];
            dot.left = dot.left-(currentDot.width+self.pageSpace);
        }
    }
    else{
        currentDot.left = exchangeDot.left;
        for (NSInteger i = currentPage; i < _currentPage; i ++) {
            UIView * dot = [_dots objectAtIndex:i];
            dot.left = dot.left+(currentDot.width+self.pageSpace);
        }
    }

    [_dots removeObjectAtIndex:_currentPage];
    [_dots insertObject:self.currentImageView atIndex:currentPage];
    _currentPage = currentPage;
}
- (void)setNumberOfPages:(NSInteger)numberOfPages{
    if (numberOfPages <= 1) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    if (_numberOfPages != numberOfPages) {
        _numberOfPages = numberOfPages;
        _frameRect.size = CGSizeMake(ceil(_currentImageSize.width+_nomalImageSize.width*(numberOfPages-1)+(self.pageSpace*(numberOfPages-1))), 10);
        self.size  = _frameRect.size;
        self.centerX =(int) SCREEN_WIDTH/2;
        [self layoutUI];
    }
}

- (void)layoutUI{
    [self removeAllSubViews];
    [_dots removeAllObjects];
    // 添加选中的Dot
    [_dots addObject:self.currentImageView];
    [self addSubview:self.currentImageView];
    
    // 创建普通Dot
    for (int i = 0; i < self.numberOfPages - 1; i ++) {
        CGFloat X = _currentImageSize.width+self.pageSpace+(self.pageSpace+_nomalImageSize.width)*i;
        //Dots
        UIImageView * nomalImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        nomalImageView.width = _nomalImageSize.width;
        nomalImageView.height = _nomalImageSize.height;
        nomalImageView.image = self.imagePageStateNormal;
        nomalImageView.left = X;
        nomalImageView.bottom = self.height-2;
        [self addSubview:nomalImageView];
        [_dots addObject:nomalImageView];
    }
}

- (UIView *)currentImageView{
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _currentImageView.width = _currentImageSize.width;
        _currentImageView.height = _currentImageSize.height;
        _currentImageView.image = self.imagePageStateHighlighted;
        _currentImageView.bottom = self.height-2;
    }
    return _currentImageView;
}

- (void)removeAllSubViews {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}



@end
