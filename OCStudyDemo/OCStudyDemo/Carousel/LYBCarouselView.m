//
//  LYBcollectionView.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2020/2/20.
//  Copyright © 2020 Albin. All rights reserved.
//

#import "LYBCarouselView.h"
#import "LYBPageControl.h"
#import "NSTimer+LYBCategory.h"

@interface LYBCarouselView() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger currentIndex;//实际下标
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat midSpace;
@property (nonatomic, assign) CGFloat leftSpace;
@property (nonatomic, assign) CGFloat rightSpace;
@property (nonatomic, assign) CGFloat oneCarouselWidth;

@property (nonatomic, assign) NSInteger carouselNum;
@property (nonatomic,strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSInteger virtualIndex;//虚拟下标

@property (nonatomic,strong) LYBPageControl *pageControl;

@end

@implementation LYBCarouselView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LYBCarouselDelegate>)delegate datasource:(id<LYBCarouselDatasource>)datasource flowLayout:(LYBCarouselFlowLayout *)flowLayout {
    
    if(self = [super initWithFrame:frame]) {
        _flowLayout = flowLayout;
        _style = _flowLayout.style;
        self.delegate = delegate;
        self.datasource = datasource;
        self.loop = YES;
        _carouselNum = 1000;
        _pageControlNormalLocalImage = @"dyn_pageindicator_short";
        _pageControlHighlightedLocalImage = @"dyn_pageindicator_long";
        _pageSpace = 4;
        _pageBottom = 7;
        _pageHeight = 7;
        [self addSubview:self.collectionView];
//        [_collectionView dyn_configureLayoutWithBlock:^(dyn_YGLayout * _Nonnull layout) {
//            layout.isEnabled = YES;
//            layout.flexGrow = 1;
//        }];

        [self scrollToFirstItem];
    }
    return self;
}

- (void)updateFrame:(CGRect)frame {
    self.frame = frame;
    _collectionView.frame = self.bounds;
}

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (void)registerViewClass:(Class)viewClass identifier:(NSString *)identifier {
    [self.collectionView registerClass:viewClass forCellWithReuseIdentifier:identifier];
}

#pragma mark - collectionVIew DataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(numbersForCarousel)]) {
        _num = [self.datasource numbersForCarousel];
        _pageControl.numberOfPages = _num;
        if (_loop) {
            return _num * _carouselNum;
        }
        return _num;
    }
    return 0;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(carouselCollectionView:cellForItemAtIndexPath:)])
    {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row % _num inSection:0];
        UICollectionViewCell *cell = [self.datasource carouselCollectionView:collectionView cellForItemAtIndexPath:newIndexPath];
        if (_itemCornerRadius > 0) {
            cell.contentView.layer.masksToBounds = YES;
            cell.contentView.layer.cornerRadius = _itemCornerRadius;
        }
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.datasource && [self.datasource respondsToSelector:@selector(carouselViewItemSize)]) {
        CGSize itemSize = [self.datasource carouselViewItemSize];
        _itemWidth = itemSize.width;
        _flowLayout.itemSize = itemSize;
        return itemSize;
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.datasource && [self.datasource respondsToSelector:@selector(carouselViewItemMidSpace)]) {
        _midSpace = [self.datasource carouselViewItemMidSpace];
        return _midSpace;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.datasource && [self.datasource respondsToSelector:@selector(carouselViewEdgeInsets)]) {
        UIEdgeInsets edgeInsets = [self.datasource carouselViewEdgeInsets];
        _leftSpace = edgeInsets.left;
        _rightSpace = edgeInsets.right;
        _flowLayout.sectionInset = edgeInsets;
        return edgeInsets;
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - collectionVIew Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(carouselView:didSelectedAtIndex:)]) {
        [self.delegate carouselView:self didSelectedAtIndex:indexPath.row % _num];
    }
}

- (void)reloadView {
    [self.collectionView reloadData];
    [self scrollToFirstItem];
}


#pragma mark -- 无限轮播

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    if (animationDuration > 0.0 && !_animationTimer) {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:(_animationDuration = animationDuration)
                                                           target:self
                                                         selector:@selector(animationTimerDidFired:)
                                                         userInfo:nil
                                                          repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)setIsShowPageControl:(BOOL)isShowPageControl {
    _isShowPageControl = isShowPageControl;
    if (_isShowPageControl) {
        self.pageControl.numberOfPages = _num;
        [self addSubview:self.pageControl];
        _pageControl.frame = CGRectMake(self.height - self.pageHeight - self.pageBottom, (self.width - _pageControl.size.width) / 2.0, _pageControl.size.width, self.pageHeight);
//        [_pageControl dyn_configureLayoutWithBlock:^(dyn_YGLayout * _Nonnull layout) {
//            layout.isEnabled = YES;
//            layout.position = dyn_YGPositionTypeAbsolute;
//            layout.alignSelf = dyn_YGAlignCenter;
//            layout.bottom = dyn_YGPointValue(self.pageBottom);
//            layout.height = dyn_YGPointValue(self.pageHeight);
//        }];
    }
}

- (void)scrollToFirstItem {
    self.currentIndex = 0;
    [_collectionView layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(),^{
        //刷新完成，其他操作
        //默认滚动到第一张图片
        if (self.loop)
        {
            self.currentIndex = _num * (_carouselNum / 2.0);
            _oneCarouselWidth = (_itemWidth + _midSpace) * _num;
            if (_style == LYBCarouselStyle_normal) {
                [_collectionView setContentOffset:CGPointMake(self.currentIndex * (_itemWidth + _midSpace), 0)];
            } else {
                [_collectionView setContentOffset:CGPointMake(self.currentIndex * (_itemWidth + _midSpace) + _leftSpace - ((self.collectionView.frame.size.width - _flowLayout.itemSize.width) / 2.0), 0)];
            }
            
        }
    });
    
}

#pragma mark - < Scroll Delegate >
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.loop)
    {
        CGFloat rightBounds = _leftSpace + _oneCarouselWidth * (_carouselNum - 3) + self.frame.size.width;
        if (scrollView.contentOffset.x <= _oneCarouselWidth * 3 - self.frame.size.width) {
            [_collectionView setContentOffset:CGPointMake(_oneCarouselWidth * (_carouselNum / 2) - self.frame.size.width, 0)];
            return;
        } else if (scrollView.contentOffset.x >= rightBounds) {
            [_collectionView setContentOffset:CGPointMake(_leftSpace + _oneCarouselWidth * (_carouselNum / 2) + self.frame.size.width, 0)];
            return;
        }
    }
    CGFloat contentX = 0;
    if (_style == LYBCarouselStyle_normal) {
        contentX = scrollView.contentOffset.x + _leftSpace;
    } else {
        contentX = scrollView.contentOffset.x + ((self.collectionView.frame.size.width - _flowLayout.itemSize.width) / 2.0) + _leftSpace;
    }
    NSInteger index = roundf(contentX / (_itemWidth + _midSpace));
    self.currentIndex = index;
    self.virtualIndex = labs(index % _num);
    _pageControl.currentPage = _virtualIndex;
    
}

- (void)setVirtualIndex:(NSInteger)virtualIndex {
    if (_virtualIndex != virtualIndex) {
        _virtualIndex = virtualIndex;
        if (_delegate && [_delegate respondsToSelector:@selector(carouselView:collectionView:scrollViewToIndex:)]) {
            [_delegate carouselView:self collectionView:_collectionView scrollViewToIndex:_virtualIndex];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(cv_collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row % _num inSection:0];
        [_delegate cv_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:newIndexPath];
    }
}

#pragma pageControl

- (LYBPageControl *)pageControl {
    if (!_pageControl) {
        //页面控制
        _pageControl = [[LYBPageControl alloc]init];
        _pageControl.imagePageStateHighlighted = [UIImage imageNamed:_pageControlHighlightedLocalImage];
        _pageControl.imagePageStateNormal = [UIImage imageNamed:_pageControlNormalLocalImage];
        _pageControl.pageSpace = _pageSpace;
    }
    return _pageControl;
}

- (void)pageControlClick:(UIPageControl *)sender {
    if (![sender isKindOfClass:[UIPageControl class]]) {
        return;
    }
    
    NSInteger page = sender.currentPage;
    
    self.currentIndex = page;
    [self scrollToItemIndex:page];
}

- (void)scrollToItemIndex:(NSInteger)index {
    if (_style == LYBCarouselStyle_normal) {
        [_collectionView setContentOffset:CGPointMake(index * (_itemWidth + _midSpace), 0) animated:YES];
    } else {
        [_collectionView setContentOffset:CGPointMake(index * (_itemWidth + _midSpace) + _leftSpace - ((self.collectionView.frame.size.width - _flowLayout.itemSize.width) / 2.0), 0) animated:YES];
    }
}


#pragma mark -- Timer
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        if (_animationTimer) {
            [_animationTimer invalidate];
            _animationTimer = nil;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_animationTimer pauseTimer];
    if ([_delegate respondsToSelector:@selector(carouselView:scrollViewWillBeginDragging:)]) {
        [_delegate carouselView:self scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_animationTimer resumeTimerAfterTimeInterval:_animationDuration];
}

- (void)animationTimerDidFired:(NSTimer *)timer
{
    if (_num>0) {
        self.currentIndex = (self.currentIndex + 1);
        [self scrollToItemIndex:self.currentIndex];
    }
}

- (void)pauseScroll;
{
    [_animationTimer pauseTimer];
}

- (void)resumeScrollAfterTimeInterval:(NSTimeInterval)interval{
    [_animationTimer resumeTimerAfterTimeInterval:interval];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
