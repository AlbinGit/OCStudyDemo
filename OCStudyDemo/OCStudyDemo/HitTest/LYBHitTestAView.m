//
//  LYBHitTestAView.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2019/11/18.
//  Copyright © 2019 Albin. All rights reserved.
//

#import "LYBHitTestAView.h"

@implementation LYBHitTestAView

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view == nil) {
//        for (UIView *subView in self.subviews) {
//            CGPoint tp = [subView convertPoint:point fromView:self];
//            if (CGRectContainsPoint(subView.bounds, tp)) {
//                view = subView;
//            }
//        }
//    }
//    return view;
//}
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    BOOL b = CGRectContainsPoint(self.bounds, point);
//    return b;
//}


@end
