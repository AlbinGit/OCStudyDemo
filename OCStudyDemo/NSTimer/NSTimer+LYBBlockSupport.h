//
//  NSTimer+LYBBlockSupport.h
//  OCStudyDemo
//
//  Created by Albin on 2018/4/9.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (LYBBlockSupport)

+ (NSTimer *)lyb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(void))block;

@end
