
//  Created by Albin on 2019/11/06.
//  Copyright © 2019年 Albin. All rights reserved.

#include <stdio.h>

#include <mach/mach.h>

/**
 *  fill a backtrace call stack array of given thread
 *
 *  @param thread   mach thread for tracing
 *  @param stack    caller space for saving stack trace info
 *  @param maxCount max stack array count
 *
 *  @return call stack address array
 */
int lz_backtraceForMachThread(thread_t thread, void** stack, int maxCount);

