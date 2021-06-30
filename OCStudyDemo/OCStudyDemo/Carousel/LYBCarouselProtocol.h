//
//  LYBCarouselProtocol.h
//  OCStudyDemo
//
//  Created by 李艳彬 on 2020/2/20.
//  Copyright © 2020 Albin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYBCarouselView;
NS_ASSUME_NONNULL_BEGIN

@protocol LYBCarouselDelegate <NSObject>

/**
 轮播图点击代理

 @param carouselView 轮播图实例对象
 @param index 被点击的下标
 */
- (void)carouselView:(LYBCarouselView *)carouselView didSelectedAtIndex:(NSInteger)index;


- (void)carouselView:(LYBCarouselView *)carouselView collectionView:(UICollectionView *)collectionView scrollViewToIndex:(NSInteger)index;

- (void)carouselView:(LYBCarouselView *)carouselView scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)cv_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol LYBCarouselDatasource<NSObject>
/**
 轮播图数量

 @return 轮播图展示个数
 */
- (NSInteger)numbersForCarousel;
/**
 自定义每个轮播图视图

 @param collectionView 轮播图控件
 @param indexPath 轮播图cell实际下标
 @return 自定义视图
 */
- (UICollectionViewCell *)carouselCollectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

/// ItemSize
- (CGSize)carouselViewItemSize;

///Item之间的间距
- (CGFloat)carouselViewItemMidSpace;
///轮播图上下左右间距
- (UIEdgeInsets)carouselViewEdgeInsets;

@end


@protocol LYBCarouselPageControlProtocol<NSObject>
@required
/**
 总页数
 */
@property (nonatomic, assign) NSInteger         pageNumbers;
/**
 当前页
 */
@property (nonatomic, assign) NSInteger         currentPage;

- (void)setCurrentPage:(NSInteger)currentPage;
- (void)setPageNumbers:(NSInteger)pageNumbers;
@end

NS_ASSUME_NONNULL_END
