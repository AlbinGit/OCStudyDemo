//
//  UIColor+Extension.h
//  OCStudyDemo
//
//  Created by Albin on 2018/4/4.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Category.h"

@interface UIColor (Extension)

+ (UIColor *)colorWithHexString:(NSString *)hexStr;

+ (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)aAlpha;

+ (UIColor *)getColor:(NSString *)hexColor andAlpha:(CGFloat)aAlpha;

//随机获取颜色
+ (UIColor *)randomColor;

+ (void)a;
- (void)a;

@end
