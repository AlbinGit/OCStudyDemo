//
//  UIView+Animation.m
//  OCStudyDemo
//
//  Created by Albin on 2018/4/10.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)shakeAnimation
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:+0.1];
    shake.toValue = [NSNumber numberWithFloat:-0.1];
    shake.duration = 2;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = MAXFLOAT;
    shake.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:shake forKey:@"imageView"];
}


- (void)floatAnimation
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 3.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.beginTime = CACurrentMediaTime();
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.keyPath = @"position";
    CGPoint p1;CGPoint p2;CGPoint p3;
    CGFloat x1;CGFloat x2;CGFloat x3;
    CGFloat y1;CGFloat y2;CGFloat y3;
    
    if (arc4random()%2) {
        x1 = self.frame.origin.x+arc4random()%10+1;
    }else{
        x1 = self.frame.origin.x-arc4random()%10+1;
    }
    if (arc4random()%2) {
        x2 = self.frame.origin.x+arc4random()%10+1;
    }else{
        x2 = self.frame.origin.x-arc4random()%10+1;
    }
    if (arc4random()%2) {
        x3 = self.frame.origin.x+arc4random()%10+1;
    }else{
        x3 = self.frame.origin.x-arc4random()%10+1;
    }
    if (arc4random()%2) {
        y1 = self.frame.origin.y+arc4random()%10+1;
    }else{
        y1 = self.frame.origin.y-arc4random()%10+1;
    }
    if (arc4random()%2) {
        y2 = self.frame.origin.y+arc4random()%10+1;
    }else{
        y2 = self.frame.origin.y-arc4random()%10+1;
    }
    if (arc4random()%2) {
        y3 = self.frame.origin.y+arc4random()%10+1;
    }else{
        y3 = self.frame.origin.y-arc4random()%10+1;
    }
    p1 = CGPointMake(x1, y1);p2 = CGPointMake(x2, y2);p3 = CGPointMake(x3, y3);
    animation.values = @[[NSValue valueWithCGPoint:self.frame.origin],[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3]];
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:animation forKey:@"imageView"];
}

@end
