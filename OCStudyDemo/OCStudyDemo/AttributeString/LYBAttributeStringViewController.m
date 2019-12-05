//
//  LYBAttributeStringViewController.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2019/9/27.
//  Copyright © 2019 Albin. All rights reserved.
//

#import "LYBAttributeStringViewController.h"
#import "LYBMethodModel.h"

@interface LYBAttributeStringViewController ()

@end

@implementation LYBAttributeStringViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSString *str = @"aj33啊¥1嗷¥5.89嗷嗷99.对的";
    NSString *str = @"a的啊";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    label.backgroundColor = [UIColor yellowColor];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    label.attributedText = [self jdBlockFontWithString:str stringFont:[UIFont systemFontOfSize:14] stringColor:[UIColor blackColor] numberFontSize:30 numberColor:[UIColor redColor]];
    CGSize labelSize = [label.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesFontLeading  context:nil].size;
    label.bounds = CGRectMake(0, 0, labelSize.width, labelSize.height);
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 50)];
    label1.backgroundColor = [UIColor lightGrayColor];
    label1.text = str;
    label1.numberOfLines = 0;
    label1.font = [UIFont systemFontOfSize:36];
    [self.view addSubview:label1];
    CGSize labelSize1 = [self sizeWithFont:label1.font text:label1.text maxWidth:self.view.frame.size.width maxHeight:MAXFLOAT];
    label1.bounds = CGRectMake(0, 0, labelSize1.width, labelSize1.height);
    
    UIView *topLine = [UIView new];
    topLine.backgroundColor = [UIColor redColor];
    topLine.frame = CGRectMake(label1.frame.origin.x, label1.frame.origin.y + [self getLabelTopGapByFont:label1.font text:label1.text] - 1, label1.frame.size.width, 1);
    topLine.alpha = 0.1;
    [self.view addSubview:topLine];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomLine];
    bottomLine.frame = CGRectMake(label1.frame.origin.x,  label1.frame.origin.y + label1.frame.size.height - [self getLabelBottomGapByFont:label1.font text:label1.text], label1.frame.size.width, 1);
    bottomLine.alpha = 0.1;
    
    //身份证
    NSString *IDregex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    [self verifyString:@"130423199111102832" byRegex:IDregex];
    
    //英文字母开头
    NSString *ZIMU = @"^[A-Za-z].*";
    [self verifyString:@"a1dd11@1#$%^&*>}{P.  \n ddd" byRegex:ZIMU];
    
    [self textSearchRange];
    
    [self method1];
}

- (void)method1 {
    BOOL a = YES;
    LYBMethodModel *modelA = [[LYBMethodModel alloc] init];
    modelA.method = @selector(logA);
    LYBMethodModel *modelB = [[LYBMethodModel alloc] init];
    modelA.method = @selector(logB);
    LYBMethodModel *modelC = [[LYBMethodModel alloc] init];
    modelA.method = @selector(logC);
    LYBMethodModel *modelD = [[LYBMethodModel alloc] init];
    modelA.method = @selector(logD);
    
    NSArray *array = nil;
    if (a) {
        array = @[modelC,modelA,modelB,modelD];
    } else {
        array = @[modelA,modelB,modelC,modelD];
    }
//    for (LYBMethodModel *model in array) {
//        if ([self performSelector:model.method]) {
//            break;
//        }
//    }
}



- (BOOL)logA {
    NSLog(@"A");
    return NO;
}

- (BOOL)logB {
    NSLog(@"B");
    return NO;
}

- (BOOL)logC {
    NSLog(@"C");
    return YES;
}

- (BOOL)logD {
    NSLog(@"D");
    return NO;
}

- (BOOL)verifyString:(NSString *)string byRegex:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:string];
    NSLog(@"result : %@ --> %@",result ? @"验证成功" : @"验证失败",string);
    return result;
}

- (void)textSearchRange {
    NSString *str = @"aaa123ddd";
    NSString *regex = [NSString stringWithFormat:@"[0-9]+([.]{0,1}[0-9]+)"];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    
        NSRange range = [str rangeOfString:regex options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            NSString *subStr = [str substringWithRange:range];
            NSLog(@"%@", subStr);
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        }
}

- (NSMutableAttributedString *)jdBlockFontWithString:(NSString *)string stringFont:(UIFont *)stringFont stringColor:(UIColor *)stringColor numberFontSize:(CGFloat)numberFontSize numberColor:(UIColor *)numberColor {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSDictionary *stringAttributes = @{NSFontAttributeName: stringFont,
                                       NSForegroundColorAttributeName: stringColor
                                       };
    ;
    NSDictionary *numterAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:numberFontSize],
                                       NSForegroundColorAttributeName: numberColor
                                       };
    [attributedStr addAttributes:stringAttributes range:NSMakeRange(0, string.length)];

//    NSString *regex = [NSString stringWithFormat:@"[0-9]+([.]{0,1}[0-9]+){0,1}"];
    NSString *regex = [NSString stringWithFormat:@"([¥0-9]|[0-9])([.]{0,1}[0-9])"];
    NSRegularExpression *regular = [NSRegularExpression
                                    regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *rangeArray = [regular matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *result in rangeArray) {
        if (result.range.location != NSNotFound) {
            [attributedStr addAttributes:numterAttributes range:result.range];
        }
    }
    return attributedStr;
}

- (CGSize)sizeWithFont:(UIFont *)font text:(NSString *)text maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight{
    if (!font) return CGSizeZero;
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maxWidth,maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
    return size;
}

- (CGFloat)getLabelBottomGapByFont:(UIFont *)font text:(NSString *)text {
    if ([self verifyContainChineseString:text]) {
        return floorf((font.lineHeight - font.pointSize) / 2.0 + font.pointSize / 20.0);
    }
    if ([self verifyNumString:text]) {
        return floorf(-font.descender);
    }
    return floorf((font.lineHeight - font.pointSize) / 2.0 + font.pointSize / 20.0);
}

- (CGFloat)getLabelTopGapByFont:(UIFont *)font text:(NSString *)text {
    return (font.lineHeight - font.pointSize) / 2.0;
}


- (BOOL)verifyNumString:(NSString *)string {
    NSString *regex = [NSString stringWithFormat:@"(^(¥|[0-9])[0-9]*(.[0-9]+)?)$"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:string];
    NSLog(@"是否为数字: %@ --> %@",result ? @"验证成功" : @"验证失败",string);
    return result;
}

- (BOOL)verifyChineseString:(NSString *)string {
    NSString *regex = [NSString stringWithFormat:@"^[\u4E00-\u9FA5]*$"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:string];
    NSLog(@"是否为纯中文: %@ --> %@",result ? @"验证成功" : @"验证失败",string);
    return result;
}


- (BOOL)verifyContainChineseString:(NSString *)string {
    NSString *regex = [NSString stringWithFormat:@"[\u4E00-\u9FA5]"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:string];
    NSLog(@"是否包含中文: %@ --> %@",result ? @"验证成功" : @"验证失败",string);
    return result;
}


@end
