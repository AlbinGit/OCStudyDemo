//
//  NSObject+LYBRuntime.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2022/3/3.
//  Copyright © 2022 Albin. All rights reserved.
//

#import "NSObject+LYBRuntime.h"
#import <objc/message.h>

@implementation NSObject (LYBRuntime)


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

//- (void)getAllClass {
//    unsigned int count;
//    const char **classes;
//    Dl_info info;
//    
//    //1.获取app的路径
//    dladdr(&_mh_execute_header, &info);
//    
//    //2.返回当前运行的app的所有类的名字，并传出个数
//    //classes：二维数组 存放所有类的列表名称
//    //count：所有的类的个数
//    classes = objc_copyClassNamesForImage(info.dli_fname, &count);
//    
//    for (int i = 0; i < count; i++) {
//        //3.遍历并打印，转换Objective-C的字符串
//        NSString *className = [NSString stringWithCString:classes[i] encoding:NSUTF8StringEncoding];
//        Class class = NSClassFromString(className);
//        NSLog(@"class name = %@", class);
//    }
//}

@end
