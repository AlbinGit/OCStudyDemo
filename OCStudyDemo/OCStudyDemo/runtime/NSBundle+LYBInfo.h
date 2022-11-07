//
//  NSBundle+LYBInfo.h
//  OCStudyDemo
//
//  Created by liyanbin16 on 2022/3/4.
//  Copyright © 2022 Albin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (LYBInfo)

+ (NSArray <Class>*)lyb_bundleOwnClassesInfo;

+ (NSArray <Class>*)lyb_bundleAllClassesInfo;

@end

NS_ASSUME_NONNULL_END
