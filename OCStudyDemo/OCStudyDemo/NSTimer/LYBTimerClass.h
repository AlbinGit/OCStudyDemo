//
//  LYBTimerClass.h
//  OCStudyDemo
//
//  Created by Albin on 2018/4/9.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LYBTimerClassDelegate<NSObject>

- (void)doSomeThing;

@end

@interface LYBTimerClass : NSObject

@property (nonatomic ,weak) id<LYBTimerClassDelegate> delegate;
@property (nonatomic ,assign) NSTimeInterval autoTimInterval;//定时器间隔

- (void)startPolling;
- (void)startPolling1;
- (void)stopPolling;



@end
