//
//  NSTimer+LYBCategory.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2021/6/30.
//  Copyright © 2021 Albin. All rights reserved.
//

#import "NSTimer+LYBCategory.h"

@implementation NSTimer (LYBCategory)

- (void)pauseTimer {
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
