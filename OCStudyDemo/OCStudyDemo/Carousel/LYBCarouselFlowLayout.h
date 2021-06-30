//
//  LYBCarouselFlowLayout.h
//  OCStudyDemo
//
//  Created by 李艳彬 on 2020/2/20.
//  Copyright © 2020 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LYBCarouselStyle) {
    LYBCarouselStyle_Normal,///普通样式,一张图占用整个屏幕宽度
    LYBCarouselStyle_scale, /// 中间大两边小
};

@interface LYBCarouselFlowLayout : UICollectionViewFlowLayout

/**
 样式风格
 */
@property (nonatomic, assign, readonly) LYBCarouselStyle style;
/**
 构造方法

 @param style 轮播图风格
 @return 实例对象
 */
- (instancetype)initWithStyle:(LYBCarouselStyle)style;

@end

NS_ASSUME_NONNULL_END

