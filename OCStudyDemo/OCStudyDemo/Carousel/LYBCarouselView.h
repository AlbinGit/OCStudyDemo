//
//  LYBCarouselView.h
//  OCStudyDemo
//
//  Created by 李艳彬 on 2020/2/20.
//  Copyright © 2020 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBCarouselProtocol.h"
#import "LYBCarouselFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYBCarouselView : UIView

/**
 相关代理
 */
@property (nonatomic, weak) id <LYBCarouselDelegate> delegate;

/**
 相关数据源
 */
@property (nonatomic, weak) id <LYBCarouselDatasource> datasource;


/**
 布局自定义layout
 */
@property (nonatomic, strong, readonly) LYBCarouselFlowLayout *flowLayout;

/**
 样式风格
 */
@property (nonatomic, assign, readonly) LYBCarouselStyle style;

//轮播时长
@property (nonatomic,assign) NSTimeInterval animationDuration;

@property (nonatomic, assign) BOOL isShowPageControl;
@property (nonatomic,copy) NSString *pageControlNormalLocalImage;//轮播指示器默认图片
@property (nonatomic,copy) NSString *pageControlHighlightedLocalImage;//轮播指示器选中图片
@property (nonatomic, assign) CGFloat pageSpace;//轮播指示器间距
@property (nonatomic, assign) CGFloat pageBottom;//轮播指示器底部距离
@property (nonatomic, assign) CGFloat pageHeight;//轮播指示器高度
@property (nonatomic,assign) CGFloat itemCornerRadius;//item圆角

/**
 是否开始无限轮播
 YES: 可以无限衔接
 NO: 滑动到第一张或者最后一张就不能滑动了
 */
@property (nonatomic, assign) BOOL loop;

#pragma mark - < 相关方法 >
/**
 创建实例构造方法

 @param frame 尺寸大小
 @param delegate 代理
 @param datasource 数据源
 @param flowLayout 自定义flowlayout
 @return 实例对象
 */
- (instancetype _Nullable )initWithFrame:(CGRect)frame
                        delegate:(id<LYBCarouselDelegate> _Nullable)delegate
                        datasource:(id<LYBCarouselDatasource> _Nullable)datasource
                       flowLayout:(nonnull LYBCarouselFlowLayout *)flowLayout;

- (void)updateFrame:(CGRect)frame;
/**
 注册自定视图

 @param viewClass 自定义视图类名
 @param identifier 重用唯一标识符
 */
- (void)registerViewClass:(Class _Nullable )viewClass identifier:(NSString *_Nullable)identifier;

/**
 刷新轮播图
 */
- (void)reloadView;

//停止定时器
- (void)pauseScroll;

//继续定时器
- (void)resumeScrollAfterTimeInterval:(NSTimeInterval)interval;


@end

NS_ASSUME_NONNULL_END
