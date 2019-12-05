//
//  LYBGCDViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2019/8/6.
//  Copyright © 2019 Albin. All rights reserved.
//

#import "LYBGCDViewController.h"

@interface LYBGCDViewController ()

@property (nonatomic ,copy) NSString *name;


@end

@implementation LYBGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self isNeedWeak];
    
    NSLog(@"semaphore");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    long st = dispatch_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 3000*NSEC_PER_MSEC));
    if (st != 0) {
        NSLog(@"time Out!");
    } else {
        NSLog(@"semaphore");
    }
}

- (void)test1{
    dispatch_sync(dispatch_queue_create("1111", DISPATCH_QUEUE_SERIAL), ^{
        NSLog(@"1111");
    });
    NSLog(@"222");
}

//死锁
- (void)test2 {
    dispatch_queue_t q = dispatch_queue_create("1", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(q, ^{
        NSLog(@"1");
        dispatch_sync(q, ^{
            NSLog(@"2");
        });
        NSLog(@"3");
    });
    NSLog(@"4");
    NSLog(@"5");
}

//信号量
- (void)test3 {
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i< 10000; i++) {
        dispatch_async(q, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [array addObject:[NSNumber numberWithInt:i]];
            dispatch_semaphore_signal(semaphore);
        });
    }
}

//异步串行队列（顺序执行）
- (void)serial_asyncTest{
    dispatch_queue_t queue = dispatch_queue_create("Albin", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        sleep(3);
        NSLog(@"1");
    });
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"2");
    });
    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"3");
    });
    
}

- (void)groupTest{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        sleep(1);
        NSLog(@"1");
    });
    
    dispatch_group_async(group, queue, ^{
        sleep(5);
        NSLog(@"2");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"main");
    });
}

- (void)isNeedWeak {
    _name = @"123";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _name = @"456";
        dispatch_async(dispatch_get_main_queue(), ^{
            _name = @"789";
            NSLog(@"name-->%@",_name);
        });
    });
}




- (void)dealloc{
    NSLog(@"dealloc-->%@",NSStringFromClass([self class]));
}



@end
