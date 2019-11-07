//  Created by Albin on 2019/11/06.
//  Copyright © 2019年 Albin. All rights reserved.

#import <Foundation/Foundation.h>

@interface LZThreadFreezeMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitor;
- (void)stopMonitor;

@end
