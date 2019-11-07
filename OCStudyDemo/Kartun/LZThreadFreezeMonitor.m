
//  Created by Albin on 2019/11/06.
//  Copyright © 2019年 Albin. All rights reserved.


#import "LZThreadFreezeMonitor.h"
#import <libkern/OSAtomic.h>
#import <execinfo.h>
#include <stdio.h>
#include <stdlib.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#import "LZThreadBacktrace.h"

//卡顿监控的间隔
static const NSInteger kBDPanThreadFreezeInterval = 300;
static const NSInteger kBDPanThreadFreezeLimit = 2;

@interface LZThreadFreezeMonitor() {
    CFRunLoopObserverRef observer;
    
@public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}

@property (nonatomic, assign) long long freezeTime; // 卡顿时间
@end


static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    LZThreadFreezeMonitor *moniotr = (__bridge LZThreadFreezeMonitor*)info;
    
    moniotr->activity = activity;
    
    dispatch_semaphore_t semaphore = moniotr->semaphore;
    dispatch_semaphore_signal(semaphore);
}


@implementation LZThreadFreezeMonitor

+ (instancetype)sharedInstance {
    static LZThreadFreezeMonitor *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LZThreadFreezeMonitor alloc] init];
    });
    
    return _instance;
}

- (void)stopMonitor {
    if (!observer)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
    _freezeTime = 0;
}

- (void)startMonitor {
#if DEBUG
    if (observer)
        return;
    
    // // 创建信号
    semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, kBDPanThreadFreezeInterval * NSEC_PER_MSEC));
            if (st != 0)
            {
                if (!observer)
                {
                    self.freezeTime = 0;
                    semaphore = 0;
                    activity = 0;
                    return;
                }

                if (activity == kCFRunLoopBeforeSources || activity == kCFRunLoopAfterWaiting)
                {
                    
                    if (++self.freezeTime < kBDPanThreadFreezeLimit)
                        continue;

                    [self handleCallbacksStackForMainThreadStucked];
                }
            }
            self.freezeTime = 0;
        }
    });
#endif
}

#pragma mark - Private Methods

- (void)handleCallbacksStackForMainThreadStucked
{
    NSString *backtraceLogs = [self formatBacktraceLogsForAllThreads];
    NSLog(@"%@",backtraceLogs);
}

- (NSString * _Nonnull)formatBacktraceForThread:(thread_t)thread {
    
    int const maxStackDepth = 128;
    
    void **backtraceStack = calloc(maxStackDepth, sizeof(void *));
    int backtraceCount = lz_backtraceForMachThread(thread, backtraceStack, maxStackDepth);
    char **backtraceStackSymbols = backtrace_symbols(backtraceStack, backtraceCount);
    
    NSMutableString *stackTrace = [NSMutableString string];
    for (int i = 0; i < backtraceCount; ++i) {
        char *currentStackInfo = backtraceStackSymbols[i];
        [stackTrace appendString:[NSString stringWithUTF8String:currentStackInfo]];
        [stackTrace appendFormat:@"\n"];
    }
    return stackTrace;
}

- (NSString *)formatBacktraceLogsForAllThreads
{
    // 1. 获取所有线程
    mach_msg_type_number_t threadCount;
    thread_act_array_t threadList;
    kern_return_t kret;
    NSMutableArray *backTracesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    kret = task_threads(mach_task_self(), &threadList, &threadCount);
    if (kret != KERN_SUCCESS) {
        // 获取线程列表失败，运行中的线程的调用栈将不精确，没有收集的必要，直接返回空
        return nil;
    }
    
//    // 2. 挂起所有线程，保证call stack信息的精确性
//    thread_t selfThread = mach_thread_self();
//    for (int i = 0; i < threadCount; ++i) {
//        if (threadList[i] != selfThread) {
//            thread_suspend(threadList[i]);
//        }
//    }
//    
//    // 3. 获取所有线程的backtrace信息
//    for (int i = 0; i < threadCount; ++i) {
//        thread_t tmpThread = threadList[i];
//        NSString *backTrace = [self formatBacktraceForThread:tmpThread];
//        if (backTrace) {
//            [backTracesArray addObjectSafe:backTrace];
//        }
//    }
//    
//    // 4. 激活被挂起的线程
//    for (int i = 0; i < threadCount; ++i) {
//        thread_resume(threadList[i]);
//    }
    
    // 5. 格式化输出backtrace log信息,写入日记文件
    NSMutableString *logs = nil;
    if (backTracesArray.count) {
        logs = [[NSMutableString alloc] initWithCapacity:0];
        
        [logs appendFormat:@"\n**************************************\n"];
        UIDevice *device = [UIDevice currentDevice];
        [logs appendFormat:@"Device: %@, %@\n\n", device.model, device.systemVersion];
        for(NSInteger idx = 0; idx < backTracesArray.count; idx++) {
            [logs appendFormat:@"%@", backTracesArray[idx]];
            [logs appendFormat:@"\n\n\n"];
        }
        [logs appendFormat:@"\n**************************************\n\n\n"];
    }
    
    return logs;
}


@end

