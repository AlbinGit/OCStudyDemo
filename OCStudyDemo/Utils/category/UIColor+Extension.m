//
//  UIColor+Extension.m
//  OCStudyDemo
//
//  Created by Albin on 2018/4/4.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)


+ (UIColor *)colorWithHexString:(NSString *)hexStr{
    return [self getColor:hexStr andAlpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)aAlpha{
    return [self getColor:hexStr andAlpha:aAlpha];
}

+ (UIColor *)getColor:(NSString *)hexColor andAlpha:(CGFloat)aAlpha{
    
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    if (nil == hexColor || 0 == hexColor.length) {
        
        NSLog(@"Color String is Nil.");
        return [UIColor blackColor];
    }
    if (hexColor.length != 6) {
        NSLog(@"Color String is wrong!");
        return [UIColor blackColor];
    }
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    NSString *dexHexColor = [hexColor substringWithRange:range];
    [[NSScanner scannerWithString:dexHexColor] scanHexInt:&red];
    
    range.location = 2;
    dexHexColor = [hexColor substringWithRange:range];
    [[NSScanner scannerWithString:dexHexColor] scanHexInt:&green];
    
    range.location = 4;
    dexHexColor = [hexColor substringWithRange:range];
    [[NSScanner scannerWithString:dexHexColor] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.f) green:(float)(green/255.f) blue:(float)(blue/255.f) alpha:aAlpha];
}

@end
