
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
#import "SMCallStack.h"

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
    //将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //子线程开启一个持续的loop用来进行监控
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
                NSLog(@"timeout-->%ld",activity);
                if (activity == kCFRunLoopBeforeSources || activity == kCFRunLoopAfterWaiting)
                {
                    NSLog(@"timeout-->in %ld",activity);
                    if (++self.freezeTime < kBDPanThreadFreezeLimit)
                        continue;
                    
                    [self handleCallbacksStackForMainThreadStucked];
                }
            }
            self.freezeTime = 0;
        }
    });
}

#pragma mark - Private Methods

- (void)handleCallbacksStackForMainThreadStucked
{
    NSString *logs = [self formatBacktraceLogsForAllThreads];
//    NSString *logs = [SMCallStack callStackWithType:SMCallStackTypeMain];

    NSLog(@"kartun-->%@",logs);
    [self showAlert:logs];
//    [JDMTA_Interface jdmta_event_click:nil
//                               EventID:@"FS_kartun_logs_point"
//                             EventName:nil
//                            ParamValue:logs
//                          NextPageName:nil];
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
    
    thread_t mainThread = 0;
    if (threadCount > 0) {
        mainThread = threadList[0];
    }
    
    // 2. 挂起主线程，保证call stack信息的精确性
    thread_t selfThread = mach_thread_self();
    if (mainThread != selfThread) {
        thread_suspend(mainThread);
    }
    
    // 3. 获取主线程的backtrace信息
    NSString *backTrace = [self formatBacktraceForThread:mainThread];
    if (backTrace) {
        [backTracesArray addObject:backTrace];
    }
    
    // 4. 激活被挂起的线程
    thread_resume(mainThread);
    
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


- (void)showAlert:(NSString *)str{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    });
}


@end

