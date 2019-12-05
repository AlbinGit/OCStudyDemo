//
//  LYBTimerClass.m
//  OCStudyDemo
//
//  Created by Albin on 2018/4/9.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBTimerClass.h"
#import "NSTimer+LYBBlockSupport.h"

struct {
    unsigned int isRespondSomeThing:1;
}_delegateFlags;

@implementation LYBTimerClass{
    NSTimer *_pollingTimer;
    BOOL _isRespondDelegate;
}

- (instancetype)init{
    return [super init];
}

- (void)dealloc{
    [_pollingTimer invalidate];
}

- (void)stopPolling{
    [_pollingTimer invalidate];
    _pollingTimer = nil;
}

- (void)startPolling{
    __weak LYBTimerClass *weakSelf = self;
    _pollingTimer = [NSTimer lyb_scheduledTimerWithTimeInterval:1 repeats:YES block:^{
        LYBTimerClass *strongSelf = weakSelf;
        [strongSelf p_doPoll];
    }];
}

- (void)startPolling1{
    _pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(p_doPoll) userInfo:nil repeats:YES];
}

- (void)setDelegate:(id<LYBTimerClassDelegate>)delegate{
    _delegate = delegate;
    _isRespondDelegate = [_delegate respondsToSelector:@selector(doSomeThing)];
    _delegateFlags.isRespondSomeThing = [_delegate respondsToSelector:@selector(doSomeThing)];
}

- (void)p_doPoll{
    static int i = 0;
    i++;
    NSLog(@"i--->%d",i);
    if (_delegateFlags.isRespondSomeThing) {
        [_delegate doSomeThing];
    }
}

@end
