//
//  UIColor+Category.h
//  DynamicLibrayFramework
//
//  Created by liyanbin16 on 2022/6/17.
//  Copyright © 2022 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Category)
+ (UIColor *)colorWithHexString:(NSString *)hexStr;
+ (void)colorLog;

@end

NS_ASSUME_NONNULL_END
