//
//  LYBCarouselFlowLayout.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2020/2/20.
//  Copyright © 2020 Albin. All rights reserved.
//

#import "LYBCarouselFlowLayout.h"

@interface LYBCarouselFlowLayout ()

//居中卡片宽度与据屏幕宽度比例
@property (nonatomic,assign) CGFloat cardWidthScale;
@property (nonatomic,assign) CGFloat cardHeightScale;

@end

@implementation LYBCarouselFlowLayout

- (instancetype)initWithStyle:(LYBCarouselStyle)style {
    if(self = [super init]) {
        _style = style;
        _cardWidthScale = 0.3f;
        _cardHeightScale = 0.3f;
    }
    return self;
}

- (instancetype)initWithStyle:(LYBCarouselStyle)style cardScale:(CGFloat)cardScale {
    if(self = [super init]) {
        _style = style;
        _cardWidthScale = cardScale;
        _cardHeightScale = cardScale;
    }
    return self;
}

//初始化方法
- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (_style == LYBCarouselStyle_scale) {
//        self.sectionInset = UIEdgeInsetsMake([self insetY], [self insetX], [self insetY], [self insetX]);
//        self.itemSize = CGSizeMake([self itemWidth], [self itemHeight]);
    }
}

//设置缩放动画
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //获取cell的布局
    NSArray *origin_attributesArr = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributesArr = [[NSArray alloc] initWithArray:origin_attributesArr copyItems:YES];
    if (_style == LYBCarouselStyle_scale) {
        //屏幕中线
        CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2.0f;
        //最大移动距离，计算范围是移动出屏幕前的距离
        CGFloat maxApart = (self.collectionView.bounds.size.width + [self itemWidth])/2.0f;
        //刷新cell缩放
        for (UICollectionViewLayoutAttributes *attributes in attributesArr) {
            //获取cell中心和屏幕中心的距离
            CGFloat apart = fabs(attributes.center.x - centerX);
            //移动进度 -1~0~1
            CGFloat progress = apart/maxApart;
            //在屏幕外的cell不处理
            if (fabs(progress) > 1) {continue;}
            //根据余弦函数，弧度在 -π/4 到 π/4,即 scale在 √2/2~1~√2/2 间变化
            CGFloat scale = fabs(1 - progress);
            CGFloat myScale = _cardWidthScale + scale * (1.0 - _cardWidthScale);
            //缩放大小
            attributes.transform = CGAffineTransformMakeScale(myScale, myScale);
        }
    }
    return attributesArr;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (_style == LYBCarouselStyle_scale) {
        CGFloat offsetAdjustment = MAXFLOAT;
        CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
        
        CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
        NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
        
        for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
            CGFloat itemHorizontalCenter = layoutAttributes.center.x;
            if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter;
            }
        }
        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    } else {
        CGFloat offsetAdjustment = MAXFLOAT;
        CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0) - (CGRectGetWidth(self.collectionView.bounds) - self.itemSize.width) / 2.0 + self.sectionInset.left;
        
        CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
        NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
        
        for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
            CGFloat itemHorizontalCenter = layoutAttributes.center.x;
            if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter;
            }
        }
        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    }
}

#pragma mark -
#pragma mark 配置方法
//卡片宽度
- (CGFloat)itemWidth {
//    return self.collectionView.bounds.size.width * _cardWidthScale;
    return self.itemSize.width;
}

- (CGFloat)itemHeight {
//    return self.collectionView.bounds.size.height * _cardHeightScale;
    return self.itemSize.height;
}

//设置左右缩进
- (CGFloat)insetX {
    CGFloat insetX = (self.collectionView.bounds.size.width - [self itemWidth])/2.0f;
    return insetX;
}

- (CGFloat)insetY {
    CGFloat insetY = (self.collectionView.bounds.size.height - [self itemHeight])/2.0f;
    return insetY;
}

//是否实时刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}


@end
