//
//  LYBTestMethod.m
//  OCStudyDemo
//
//  Created by Albin on 2018/7/19.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBTestMethod.h"
#import <objc/runtime.h>

@implementation LYBTestMethod

//- (NSString *)log{
//    NSLog(@"hello log!");
//    return @"log";
//}

char logStr(){
    NSLog(@"hello log!");
    return 'a';
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    class_addMethod(self, sel, (IMP)logStr, "c");
    return [super resolveInstanceMethod:sel];
}

@end
