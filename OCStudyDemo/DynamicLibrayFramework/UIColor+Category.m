//
//  UIColor+Category.m
//  DynamicLibrayFramework
//
//  Created by liyanbin16 on 2022/6/17.
//  Copyright © 2022 Albin. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

+ (UIColor *)colorWithHexString:(NSString *)hexStr{
    return [UIColor blackColor];
}

+ (void)colorLog{
    NSLog(@"color!");
    [self log];
}

+ (void)log {
    NSLog(@"UIColor (Category)");
}

@end
