//
//  NSTimer+LYBBlockSupport.m
//  OCStudyDemo
//
//  Created by Albin on 2018/4/9.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "NSTimer+LYBBlockSupport.h"

@implementation NSTimer (LYBBlockSupport)


+ (NSTimer *)lyb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(void))block {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(lyb_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)lyb_blockInvoke:(NSTimer *)timer{
    void(^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}


@end
