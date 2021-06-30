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

/**
 是否自动轮播, 默认为NO
 */
@property (nonatomic, assign) BOOL isAuto;

/**
 自动轮播时间间隔, 默认 3s
 */
@property (nonatomic, assign) NSTimeInterval autoTimInterval;


@property (nonatomic, assign) BOOL isShowPageControl;

/**
 默认的pageControl
 1. 默认在水平居中正下方
 2. 位置可以自己根据frame自行调整
 3. 如果不想将其添加在carousel上,请自行通过调用目标父视图的addSubview方法添加到其他父视图上
 */
@property (nonatomic, strong) UIPageControl *pageControl;


/**
 自定义的pageControl
 */
@property (nonatomic, strong) UIView<LYBCarouselPageControlProtocol> *customPageControl;

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

/**
 注册自定视图

 @param viewClass 自定义视图类名
 @param identifier 重用唯一标识符
 */
- (void)registerViewClass:(Class _Nullable )viewClass identifier:(NSString *_Nullable)identifier;

/**
 注册自定义视图

 @param nibName 自定义视图xib相关文件名
 @param identifier 重用唯一标识符
 */
- (void)registerNibView:(NSString *_Nullable)nibName identifier:(NSString *_Nullable)identifier;


/**
 刷新轮播图
 */
- (void)reloadView;


@end

NS_ASSUME_NONNULL_END
