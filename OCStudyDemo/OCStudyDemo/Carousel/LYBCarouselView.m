//
//  LYBcollectionView.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2020/2/20.
//  Copyright © 2020 Albin. All rights reserved.
//

#import "LYBCarouselView.h"
#import "LYBTimerClass.h"

@interface LYBCarouselView() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, LYBTimerClassDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat midSpace;
@property (nonatomic, assign) CGFloat leftSpace;
@property (nonatomic, assign) CGFloat rightSpace;
@property (nonatomic, assign) CGFloat oneCarouselWidth;
@property (nonatomic,strong) LYBTimerClass *timerClass;

@property (nonatomic, assign) NSInteger carouselNum;

@end

@implementation LYBCarouselView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LYBCarouselDelegate>)delegate datasource:(id<LYBCarouselDatasource>)datasource flowLayout:(LYBCarouselFlowLayout *)flowLayout {
    
    if(self = [super initWithFrame:frame]) {
        _flowLayout = flowLayout;
        _style = _flowLayout.style;
        self.delegate = delegate;
        self.datasource = datasource;
        self.isAuto = NO;
        self.autoTimInterval = 3;
        self.loop = YES;
        _carouselNum = 1000;
        [self addSubview:self.collectionView];
    }
    return self;
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

- (void)registerNibView:(NSString *)nibName identifier:(NSString *)identifier {
    [self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:identifier];
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
}


#pragma mark -- 无限轮播
- (void)layoutSubviews {
    [self scrollToFirstItem];
    if (_isShowPageControl) {
        [self addSubview:self.pageControl];
    }
}

- (void)scrollToFirstItem {
    [_collectionView layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(),^{
        //刷新完成，其他操作
        //默认滚动到第一张图片
        if (self.loop)
        {
            _oneCarouselWidth = _itemWidth * _num + _midSpace * (_num - 1);
            if (_style == LYBCarouselStyle_Normal) {
                [_collectionView setContentOffset:CGPointMake(_leftSpace + _oneCarouselWidth * (_carouselNum / 2.0) + _midSpace * ((_carouselNum / 2.0) - 1.0), 0)];
            } else {
                [_collectionView setContentOffset:CGPointMake( 2 * _leftSpace - ((self.collectionView.frame.size.width - _flowLayout.itemSize.width) / 2.0)  + _oneCarouselWidth * (_carouselNum / 2.0) + _midSpace * ((_carouselNum / 2.0) - 1.0), 0)];
            }
            self.currentIndex = 0;
        }
    });
    
}

#pragma mark - < Scroll Delegate >
/// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timerClass stopPolling];
}


/// 将要结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [_timerClass startPolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.loop)
    {
        CGFloat rightBounds = _leftSpace + _oneCarouselWidth * (_carouselNum - 3) + self.frame.size.width;
        if (scrollView.contentOffset.x <= _oneCarouselWidth * 3 - self.frame.size.width) {
            self.currentIndex = _num;
            [_collectionView setContentOffset:CGPointMake(_oneCarouselWidth * (_carouselNum / 2) - self.frame.size.width, 0)];
            NSLog(@"222");
            return;
        } else if (scrollView.contentOffset.x >= rightBounds) {
            self.currentIndex = 0;
            [_collectionView setContentOffset:CGPointMake(_leftSpace + _oneCarouselWidth * (_carouselNum / 2) + self.frame.size.width, 0)];
            NSLog(@"111");
            return;
        }
    }
    CGFloat contentX = scrollView.contentOffset.x - (_leftSpace + _oneCarouselWidth * (_carouselNum / 2));
    NSInteger index = roundf(contentX / (_itemWidth + _midSpace));
    self.currentIndex = index;
    _pageControl.currentPage = labs(index % _num);
    NSLog(@"index--->%ld",index);
    if (_delegate && [_delegate respondsToSelector:@selector(carouselView:scrollViewToIndex:)]) {
        if (_style == LYBCarouselStyle_Normal) {
            [_delegate carouselView:self scrollViewToIndex:labs(index % _num)];
        } else {
            [_delegate carouselView:self scrollViewToIndex:labs((index + 1) % _num)];
        }
    }
}

- (UIPageControl *)pageControl {
    if(!_pageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 20, 30)];
        CGPoint center = self.center;
        center.y = CGRectGetHeight(self.frame) - 30 * 0.5;
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.userInteractionEnabled = NO;
        [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventTouchUpInside];
        _pageControl.center = center;
    }
    return _pageControl;
}

#pragma mark - Setter
- (void)setCustomPageControl:(UIView<LYBCarouselPageControlProtocol> *)customPageControl {
    _customPageControl = customPageControl;
    if(_customPageControl && _customPageControl.superview == nil)
    {
        [self addSubview:_customPageControl];
        [self bringSubviewToFront:_customPageControl];
        if(self.pageControl.superview == _customPageControl.superview)
        {
            [self.pageControl removeFromSuperview];
        }
    }
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
    if (_style == LYBCarouselStyle_Normal) {
    [_collectionView setContentOffset:CGPointMake(_leftSpace + _oneCarouselWidth * (_carouselNum / 2.0) + _midSpace * ((_carouselNum / 2.0) - 1.0) + index * (_itemWidth + _midSpace), 0) animated:YES];
    } else {
//        [_collectionView setContentOffset:CGPointMake( 2 * _leftSpace - ((self.collectionView.frame.size.width - _flowLayout.itemSize.width) / 2.0)  + _oneCarouselWidth * (_carouselNum / 2.0) + _midSpace * ((_carouselNum / 2.0) - 1.0)  + index * (_itemWidth + _midSpace), 0) animated:YES];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_carouselNum / 2.0) * _num + index inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)setIsAuto:(BOOL)isAuto {
    _isAuto = isAuto;
    if (_isAuto) {
        _timerClass = [[LYBTimerClass alloc]init];
        _timerClass.autoTimInterval = _autoTimInterval;
        _timerClass.delegate = self;
        [_timerClass startPolling];
    }
}

- (void)doSomeThing {
    self.currentIndex = (self.currentIndex + 1);
    [self scrollToItemIndex:self.currentIndex];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
