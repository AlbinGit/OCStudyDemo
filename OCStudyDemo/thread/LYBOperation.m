//
//  LYBOperation.m
//  OCStudyDemo
//
//  Created by Albin on 2019/8/6.
//  Copyright © 2019 Albin. All rights reserved.
//

#import "LYBOperation.h"

@implementation LYBOperation


- (void)main {
    if (!self.isCancelled) {
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--->%@",[NSThread currentThread]);
        }
    }
}





@end
