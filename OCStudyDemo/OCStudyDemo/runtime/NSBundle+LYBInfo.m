//
//  NSBundle+LYBInfo.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2022/3/4.
//  Copyright © 2022 Albin. All rights reserved.
//

#import "NSBundle+LYBInfo.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>

@implementation NSBundle (LYBInfo)


+ (NSArray<Class> *)lyb_bundleOwnClassesInfo {
    NSMutableArray *resultArray = [NSMutableArray array];
    
    unsigned int classCount;
    const char **classes;
    Dl_info info;
    
    dladdr(&_mh_execute_header, &info);
    classes = objc_copyClassNamesForImage(info.dli_fname, &classCount);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_apply(classCount, dispatch_get_global_queue(0, 0), ^(size_t iteration) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSString *className = [NSString stringWithCString:classes[iteration] encoding:NSUTF8StringEncoding];
        Class class = NSClassFromString(className);
        [resultArray addObject:class];
        dispatch_semaphore_signal(semaphore);

        NSLog(@"NSBundle---->%@",className);
    });
    
    return resultArray.mutableCopy;
}

+ (NSArray<Class> *)lyb_bundleAllClassesInfo {
    NSMutableArray *resultArray = [NSMutableArray new];
    
    int classCount = objc_getClassList(NULL, 0);
    
    Class *classes = NULL;
    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) *classCount);
    classCount = objc_getClassList(classes, classCount);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_apply(classCount, dispatch_get_global_queue(0, 0), ^(size_t iteration) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        Class class = classes[iteration];
        NSString *className = [[NSString alloc] initWithUTF8String:class_getName(class)];
        [resultArray addObject:className];
        dispatch_semaphore_signal(semaphore);
        NSMutableString *methodsStr = [NSMutableString string];
//        NSLog(@"className---->：%@",className);
        [methodsStr appendFormat:@"---------------------className:%@---------------------- \n",className];
        NSArray *methods = ClassMethodNames(class);
        for (NSString *method in methods) {
//            NSLog(@"method:[%@]",method);
            [methodsStr appendFormat:@"className:%@,method:[%@] \n",className,method];
        }
        [self writefile:methodsStr];
    });
    
    free(classes);
    
    return resultArray.mutableCopy;
}

static NSArray *ClassMethodNames(Class c){
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(c, &methodCount);
    for (int i = 0; i<methodCount; i++) {
        [array addObject:NSStringFromSelector(method_getName(methodList[i]))];
    }
    free(methodList);
    return array;
}

//- (void)writeToFile:(NSString *)str {
//    // 获取Documents目录
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    // 字符串写入沙盒
//    // 在Documents下面创建一个文本路径，假设文本名称为objc.txt
//    NSString *txtPath = [docPath stringByAppendingPathComponent:@"MyLinkMap.txt"]; // 此时仅存在路径，文件并没有真实存在
//    NSString *string = @"Objective-C";
//
//    // 字符串写入时执行的方法
//    [string writeToFile:str atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"txtPath is %@", txtPath);
//
//    // 字符串读取的方法
//    NSString *resultStr = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"resultStr is %@", resultStr);
//
//
//}

+ (void)writefile:(NSString *)string
{
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    NSLog(@"homePath:%@",homePath);
    NSString *filePath = [homePath stringByAppendingPathComponent:@"MyLinkMap.txt"];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }

    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];

    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾

    NSData* stringData  = [string dataUsingEncoding:NSUTF8StringEncoding];

    [fileHandle writeData:stringData]; //追加写入数据

    [fileHandle closeFile];
}

@end
