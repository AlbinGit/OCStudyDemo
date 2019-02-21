//
//  UIColor+Extension.h
//  OCStudyDemo
//
//  Created by Albin on 2018/4/4.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithHexString:(NSString *)hexStr;

+ (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)aAlpha;

+ (UIColor *)getColor:(NSString *)hexColor andAlpha:(CGFloat)aAlpha;

@end
