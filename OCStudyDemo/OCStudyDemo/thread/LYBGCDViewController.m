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
@property (nonatomic,strong) NSMutableDictionary *allDict;

@end

@implementation LYBGCDViewController{
    dispatch_queue_t _serialQueue;
    dispatch_queue_t _serialBatchCacheQueue;//批量模版串行队列
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self isNeedWeak];
//
//    NSLog(@"semaphore");
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    long st = dispatch_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 3000*NSEC_PER_MSEC));
//    if (st != 0) {
//        NSLog(@"time Out!");
//    } else {
//        NSLog(@"semaphore");
//    }
    
    [self textFile];
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

- (void)textFile {
    _allDict = [NSMutableDictionary dictionary];
    _serialQueue = dispatch_queue_create("com.jd.DYNDownLoadCacheQueue", DISPATCH_QUEUE_SERIAL);
    _serialBatchCacheQueue = dispatch_queue_create("com.jd.DYNDownLoadBatchCacheQueue", DISPATCH_QUEUE_SERIAL);
    
    NSDictionary *dict1 = @{@"1":@"haha",
                           @"2":@"ddggd",
                           @"3":@"48585858"
    };
    NSString *key1 = @"file1";
    NSDictionary *dict2 = @{@"4":@"haha1",
                           @"5":@"ddggd1",
                           @"6":@"485858581"
    };
    NSString *key2 = @"file2";
    for (NSInteger i = 0; i < 1000; i++) {
        dispatch_async(dispatch_queue_create("1111", DISPATCH_QUEUE_CONCURRENT), ^{
            [self writeFileKey:key1 dict:dict1];
        });
    }
    for (NSInteger i = 0; i < 1000; i++) {
        dispatch_async(dispatch_queue_create("2222", DISPATCH_QUEUE_CONCURRENT), ^{
            [self readFileKey:key1];
        });
    }
    for (NSInteger i = 0; i < 1000; i++) {
        dispatch_async(dispatch_queue_create("3333", DISPATCH_QUEUE_CONCURRENT), ^{
            [self writeFileKey:key2 dict:dict2];
        });
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 1000; i++) {
            dispatch_async(dispatch_queue_create("4444", DISPATCH_QUEUE_CONCURRENT), ^{
                [self readFileKey:key2];
            });
        }
    });
}

- (void)writeFileKey:(NSString *)key dict:(NSDictionary *)dict {
    dispatch_async(_serialQueue, ^{
        [_allDict addEntriesFromDictionary:@{key:dict}];
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        NSString * cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString * downloadPath = [cachesPath stringByAppendingPathComponent:@"DYNDownFiles"];
        NSString *path = [downloadPath stringByAppendingPathComponent:key];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:downloadPath]){
            [fileManager createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if ([data writeToFile:path atomically:YES]) {
            NSLog(@"file:%@写入成功！",key);
        }
    });
}

- (void)readFileKey:(NSString *)key  {
    NSDictionary *dict = _allDict[key];
    if (!dict) {
        NSString * cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString * downloadPath = [cachesPath stringByAppendingPathComponent:@"DYNDownFiles"];
        NSString *path = [downloadPath stringByAppendingPathComponent:key];
        dispatch_sync(_serialBatchCacheQueue, ^{
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]];
            if (dict) {
                [_allDict addEntriesFromDictionary:dict];
                NSLog(@"file:%@读取成功！",key);
            }
        });
    } else {
        NSLog(@"file:%@已读取！",key);
    }
}

- (void)dealloc{
    NSLog(@"dealloc-->%@",NSStringFromClass([self class]));
}



@end
