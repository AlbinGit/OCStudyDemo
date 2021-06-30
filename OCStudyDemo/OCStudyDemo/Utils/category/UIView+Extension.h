//
//  UIView+Extension.h
//  OCStudyDemo
//
//  Created by 李艳彬 on 2020/2/28.
//  Copyright © 2020 Albin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LYBCornerRadiusUtil.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct {
     CGFloat topLeft;
     CGFloat topRight;
     CGFloat bottomLeft;
     CGFloat bottomRight;
} BNKCornerRadii;

@interface UIView (Extension)


@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;
@property(nonatomic) CGSize size;

- (CGFloat)maxX;
- (CGFloat)maxY;
- (CGFloat)minX;
- (CGFloat)minY;
- (CGFloat)midX;
- (CGFloat)midY;

- (CGFloat)X;
- (CGFloat)Y;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

- (void)setFrameCenterWithSuperView:(UIView *)superView size:(CGSize)size;
- (void)setFrameInBottomCenterWithSuperView:(UIView *)superView size:(CGSize)size;

- (void)addCorner;

@property(nonatomic, strong) CALayer *fssShadowLayer;
- (void)addShadowWithCornerRadius:(CGFloat)cornerRadius
                      shadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset
                    shadowOpacity:(float)shadowOpacity
                     shadowRadius:(CGFloat)shadowRadius;
- (void)addShadowWithSuperView:(UIView *)superView
                  cornerRadius:(CGFloat)cornerRadius
                   shadowColor:(UIColor *)shadowColor
                  shadowOffset:(CGSize)shadowOffset
                 shadowOpacity:(float)shadowOpacity
                  shadowRadius:(CGFloat)shadowRadius;

@property(nonatomic, strong) CAShapeLayer *fssShapeLayer;
BNKCornerRadii BNKCornerRadiiMake(CGFloat topLeft,CGFloat topRight,CGFloat bottomLeft,CGFloat bottomRight);
//切圆角函数
CGPathRef BNKPathCreateWithRoundedRect(CGRect bounds,
                                      BNKCornerRadii cornerRadii);
- (void)addCornerWithCornerRadii:(BNKCornerRadii)cornerRadii;
- (void)addShadowWithCornerRadii:(BNKCornerRadii)cornerRadii
                     shadowColor:(UIColor *)shadowColor
                    shadowOffset:(CGSize)shadowOffset
                   shadowOpacity:(float)shadowOpacity
                    shadowRadius:(CGFloat)shadowRadius;
- (void)addShadowWithSuperView:(UIView *)superView
                   cornerRadii:(BNKCornerRadii)cornerRadii
                   shadowColor:(UIColor *)shadowColor
                  shadowOffset:(CGSize)shadowOffset
                 shadowOpacity:(float)shadowOpacity
                  shadowRadius:(CGFloat)shadowRadius;


// 得到view所属viewController
+ (UIViewController *)findViewControllerWithView:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
