//
//  NSTimer+LYBCategory.h
//  OCStudyDemo
//
//  Created by liyanbin16 on 2021/6/30.
//  Copyright © 2021 Albin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (LYBCategory)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
