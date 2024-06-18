//
//  main.m
//  OCStudyDemo
//
//  Created by Albin on 2018/2/26.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int func(int count)
{
    return count + 1;
}

int (*funcptr)(int) = &func;


int main(int argc, char * argv[]) {
    @autoreleasepool {
//        int a = func(10);
//        NSLog(@"main a-->%d",a);
//        int b = funcptr(1);
//        NSLog(@"main b-->%d",b);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}


