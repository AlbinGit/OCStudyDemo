//
//  LYBLockViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/8/17.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBLockViewController.h"

@interface LYBLockViewController ()

@end

@implementation LYBLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self synchronizadMethod];
//    [self NSLookMethod];
//    [self NSConditionMethod];
    [self NSRecursiveLockMethod];
}

//2.1、synchronizad 给需要加锁的代码进行加锁。
- (void)synchronizadMethod{
    
    NSLog(@"synchronizad 测试");
    
    static NSObject *lock = nil;
    
    if (!lock) {
        lock = [[NSString alloc] init];
        
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程A，准备好");
        @synchronized(lock){
            NSLog(@"线程A lock, 请等待");
            [NSThread sleepForTimeInterval:3];
            NSLog(@"线程A 执行完毕");
        }
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程B，准备好");
        @synchronized(lock){
            NSLog(@"线程B lock, 请等待");
            [NSThread sleepForTimeInterval:1];
            NSLog(@"线程B 执行完毕");
        }
    });
    //线程A、B无顺序执行（因为GlobalQueue是并行队列）
}

//2.2、NSLock 对多线程需要安全的代码加锁
- (void)NSLookMethod {
    
    static NSLock *lock = nil;
    if (!lock) {
        lock = [[NSLock alloc] init];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程A，准备好");
        [lock lock];
        NSLog(@"线程A lock, 请等待");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"线程A 执行完毕");
        [lock unlock];
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"线程B，准备好");
        [lock lock];
        NSLog(@"线程B lock, 请等待");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"线程B 执行完毕");
        [lock unlock];
    });
    // 线程A、B 无先后顺序执行
}

//2.3、NSCondition 条件锁，只有达到条件之后，才会执行锁操作，否则不会对数据进行加锁

- (void)NSConditionMethod {
    
#define kCondition_A  1
#define kCondition_B  2
    
    __block NSUInteger condition = kCondition_B;
    static NSConditionLock *conditionLock = nil;
    if (!conditionLock) {
        conditionLock = [[NSConditionLock alloc] initWithCondition:condition];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程A，准备好,检测是否可以加锁");
        BOOL canLock = [conditionLock tryLockWhenCondition:kCondition_A];
        
        if (canLock) {
            NSLog(@"线程A lock, 请等待");
            [NSThread sleepForTimeInterval:1];
            NSLog(@"线程A 执行完毕");
            [conditionLock unlock];
        }else{
            NSLog(@"线程A 条件不满足，未加lock");
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程B，准备好,检测是否可以加锁");
        BOOL canLock = [conditionLock tryLockWhenCondition:kCondition_B];
        
        if (canLock) {
            NSLog(@"线程B lock, 请等待");
            [NSThread sleepForTimeInterval:1];
            NSLog(@"线程B 执行完毕");
            [conditionLock unlock];
        }else{
            NSLog(@"线程B 未加lock");
        }
    });
}

//2.4、NSRecursiveLock 递归锁，同一个线程可以多次加锁，但是不会引起死锁,如果是NSLock，则会导致崩溃
- (void)reverseDebug:(NSUInteger )num lock:(NSRecursiveLock *)lock
{
    [lock lock];
    if (num<=0) {
        NSLog(@"结束");
        return;
    }
    NSLog(@"加了递归锁, num = %ld", num);
    [NSThread sleepForTimeInterval:0.5];
    [self reverseDebug:num-1 lock:lock];
    
    [lock unlock];
}

- (void)NSRecursiveLockMethod {
    
    static NSRecursiveLock *lock = nil;
    
    if (!lock) {
        lock = [[NSRecursiveLock alloc] init];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self reverseDebug:5 lock:lock];
        NSLog(@"end");
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"dealloc-->LYBLockViewController.h");
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
