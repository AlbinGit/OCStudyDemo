//
//  UIView+Extension.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2020/2/28.
//  Copyright © 2020 Albin. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

@implementation UIView (Extension)

- (CGFloat)top
{
    return CGRectGetMinY(self.frame);
}

- (void)setTop:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)left
{
    return CGRectGetMinX(self.frame);
}

- (void)setLeft:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right {
    CGRect rect = self.frame;
    rect.origin.x = right - self.width;
    self.frame = rect;
}

- (CGFloat)bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom {
    CGRect rect = self.frame;
    rect.origin.y = bottom - self.height;
    self.frame = rect;
}

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height;
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)centerX
{
    return CGRectGetMidX(self.frame);
}

- (void)setCenterX:(CGFloat)dyn_centerX {
    CGRect rect = self.frame;
    rect.origin.x = dyn_centerX - self.width / 2.0;
    self.frame = rect;
}

- (CGFloat)centerY
{
    return CGRectGetMidY(self.frame);
}

- (void)setCenterY:(CGFloat)dyn_centerY {
    CGRect rect = self.frame;
    rect.origin.y = dyn_centerY - self.height / 2.0;
    self.frame = rect;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)dyn_size {
    CGRect rect = self.frame;
    rect.size = dyn_size;
    self.frame = rect;
}


- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)minX
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)minY
{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)midX
{
    return CGRectGetMidX(self.frame);
}

- (CGFloat)midY
{
    return CGRectGetMidY(self.frame);
}

- (CGFloat)X
{
    return CGRectGetMinX(self.frame);
}
- (CGFloat)Y
{
    return CGRectGetMinY(self.frame);
}

- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setFrameCenterWithSuperView:(UIView *)superView size:(CGSize)size
{
    self.frame = CGRectMake((superView.width - size.width) / 2, (superView.height - size.height) / 2, size.width, size.height);
    [superView addSubview:self];
}

- (void)setFrameInBottomCenterWithSuperView:(UIView *)superView size:(CGSize)size
{
    self.frame = CGRectMake((superView.width - size.width) / 2, superView.height - size.height, size.width, size.height);
    [superView addSubview:self];
}

- (void)addCorner
{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}

- (void)setFssShadowLayer:(CALayer *)fssShadowLayer {
    objc_setAssociatedObject(self, @selector(fssShadowLayer), fssShadowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)fssShadowLayer {
    return objc_getAssociatedObject(self, @selector(fssShadowLayer));
}

- (void)addShadowWithCornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor  shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity  shadowRadius:(CGFloat)shadowRadius {
    [self addShadowWithSuperView:nil cornerRadius:cornerRadius shadowColor:shadowColor shadowOffset:shadowOffset shadowOpacity:shadowOpacity shadowRadius:shadowRadius];
}

- (void)addShadowWithSuperView:(UIView *)superView cornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity shadowRadius:(CGFloat)shadowRadius {
    //////// shadow /////////
    if (!self.fssShadowLayer) {
        self.fssShadowLayer = [CALayer layer];
        self.fssShadowLayer.frame = self.layer.frame;
        
        self.fssShadowLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
        self.fssShadowLayer.shadowOffset = shadowOffset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        self.fssShadowLayer.shadowOpacity = shadowOpacity;////阴影透明度，默认0
        self.fssShadowLayer.shadowRadius = shadowRadius;////阴影半径，默认3
        self.fssShadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius].CGPath;
    }

    //////// cornerRadius /////////
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    if (!superView) {
        superView = self.superview;
    }
    [superView.layer insertSublayer:self.fssShadowLayer below:self.layer];
}

- (void)setFssShapeLayer:(CAShapeLayer *)fssShapeLayer{
    objc_setAssociatedObject(self, @selector(fssShapeLayer), fssShapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)fssShapeLayer {
    return objc_getAssociatedObject(self, @selector(fssShapeLayer));
}

BNKCornerRadii BNKCornerRadiiMake(CGFloat topLeft,CGFloat topRight,CGFloat bottomLeft,CGFloat bottomRight){
     return (BNKCornerRadii){
          topLeft,
          topRight,
          bottomLeft,
          bottomRight,
     };
}
//切圆角函数
CGPathRef BNKPathCreateWithRoundedRect(CGRect bounds,
                                       BNKCornerRadii cornerRadii)
{
     const CGFloat minX = CGRectGetMinX(bounds);
     const CGFloat minY = CGRectGetMinY(bounds);
     const CGFloat maxX = CGRectGetMaxX(bounds);
     const CGFloat maxY = CGRectGetMaxY(bounds);
     
     const CGFloat topLeftCenterX = minX +  cornerRadii.topLeft;
     const CGFloat topLeftCenterY = minY + cornerRadii.topLeft;
     
     const CGFloat topRightCenterX = maxX - cornerRadii.topRight;
     const CGFloat topRightCenterY = minY + cornerRadii.topRight;
     
     const CGFloat bottomLeftCenterX = minX +  cornerRadii.bottomLeft;
     const CGFloat bottomLeftCenterY = maxY - cornerRadii.bottomLeft;
     
     const CGFloat bottomRightCenterX = maxX -  cornerRadii.bottomRight;
     const CGFloat bottomRightCenterY = maxY - cornerRadii.bottomRight;
     /*
      path : 路径
      m : 变换
      x  y : 画圆的圆心点
      radius : 圆的半径
      startAngle : 起始角度
      endAngle ： 结束角度
      clockwise : 是否是顺时针
      void CGPathAddArc(CGMutablePathRef cg_nullable path,
      const CGAffineTransform * __nullable m,
      CGFloat x, CGFloat y, CGFloat radius, CGFloat startAngle, CGFloat endAngle,
      bool clockwise)
      */
     //虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
     
     CGMutablePathRef path = CGPathCreateMutable();
     //顶 左
     CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY,cornerRadii.topLeft, M_PI, 3 * M_PI_2, NO);
     //顶 右
     CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, cornerRadii.topRight, 3 * M_PI_2, 0, NO);
     //底 右
     CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadii.bottomRight,0, M_PI_2, NO);
     //底 左
     CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadii.bottomLeft, M_PI_2,M_PI, NO);
     CGPathCloseSubpath(path);
     return path;
}

- (void)addCornerWithCornerRadii:(BNKCornerRadii)cornerRadii {
    //切圆角
    if (!self.fssShapeLayer) {
        self.fssShapeLayer = [CAShapeLayer layer];
        CGPathRef path = BNKPathCreateWithRoundedRect(self.bounds,cornerRadii);
        self.fssShapeLayer.path = path;
        CGPathRelease(path);
        self.layer.mask = self.fssShapeLayer;
    }
}

- (void)addShadowWithCornerRadii:(BNKCornerRadii)cornerRadii shadowColor:(UIColor *)shadowColor  shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity  shadowRadius:(CGFloat)shadowRadius {
    [self addShadowWithSuperView:nil cornerRadii:cornerRadii shadowColor:shadowColor shadowOffset:shadowOffset shadowOpacity:shadowOpacity shadowRadius:shadowRadius];
}

- (void)addShadowWithSuperView:(UIView *)superView cornerRadii:(BNKCornerRadii)cornerRadii shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity shadowRadius:(CGFloat)shadowRadius {
    
    CGPathRef path = BNKPathCreateWithRoundedRect(self.bounds,cornerRadii);
    ////// shadow /////////
    if (!self.fssShadowLayer) {
        self.fssShadowLayer = [CALayer layer];
        self.fssShadowLayer.frame = self.layer.frame;
        
        self.fssShadowLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
        self.fssShadowLayer.shadowOffset = shadowOffset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        self.fssShadowLayer.shadowOpacity = shadowOpacity;////阴影透明度，默认0
        self.fssShadowLayer.shadowRadius = shadowRadius;////阴影半径，默认3
        self.fssShadowLayer.shadowPath = path;
    }
    
    //切圆角
    if (!self.fssShapeLayer) {
        self.fssShapeLayer = [CAShapeLayer layer];
        self.fssShapeLayer.path = path;
        CGPathRelease(path);
        self.layer.mask = self.fssShapeLayer;
    }
    
    if (!superView) {
        superView = self.superview;
    }
    [superView.layer insertSublayer:self.fssShadowLayer below:self.layer];
}

// 得到view所属viewController
+ (UIViewController *)findViewControllerWithView:(UIView *)view
{
    UIView *currentView = view.superview;
    while(currentView)
    {
        UIResponder *responder = [currentView nextResponder];
        if([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder;
        }
        currentView = currentView.superview;
    }
    return nil;
}

@end
