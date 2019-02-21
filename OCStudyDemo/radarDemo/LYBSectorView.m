//
//  LYBSectorView.m
//  OCStudyDemo
//
//  Created by Albin on 2018/4/4.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBSectorView.h"

@interface LYBSectorView()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat degree;

@end

@implementation LYBSectorView

- (instancetype)initWithRadius:(CGFloat )radius degree:(CGFloat)degree {
    self = [super initWithFrame:CGRectMake(0, 0, 2 *radius, 2 *radius)];
    if (self)  {
        _degree = degree;
        _radius = radius;
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)drawRect:(CGRect)rect {
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    UIColor *aColor = [UIColor colorWithHexString:@"ff4e7d" alpha:0.5];
    //    CGContextSetRGBStrokeColor(context, 1, 1, 1, 0);
    //    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    //    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    //
    //    CGContextMoveToPoint(context, center.x, center.y);
    //    CGContextAddArc(context,center.x, center.y, _radius,  _degree / 2.0, -_degree / 2.0, 1);
    //    CGContextClosePath(context);
    //    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef imgCtx = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextMoveToPoint(imgCtx, center.x,center.y);
    CGContextSetFillColor(imgCtx, CGColorGetComponents([UIColor blackColor].CGColor));
    CGContextAddArc(imgCtx, center.x, center.y, _radius,  _degree / 2.0, -_degree / 2.0, 1);
    CGContextFillPath(imgCtx);//画扇形遮罩
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    CGContextClipToMask(ctx, self.bounds, mask);
    
    CGFloat components[8]={
        1.0, 0.306, 0.49, 0.5,     //start color(r,g,b,alpha)
        0.992, 0.937, 0.890, 0.5      //end color
    };
    //为扇形增加径向渐变色
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, NULL,2);
    (void)(CGColorSpaceRelease(space)),space=NULL;//release
    
    CGPoint start = center;
    CGPoint end = center;
    CGFloat startRadius = 0.0f;
    CGFloat endRadius = _radius;
    CGContextRef graCtx = UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(graCtx, gradient, start, startRadius, end, endRadius, 0);
    (void)(CGGradientRelease(gradient)),gradient=NULL;//release
}

@end
