//
//  LYBURLComponentsViewController.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2024/2/28.
//  Copyright © 2024 Albin. All rights reserved.
//

#import "LYBURLComponentsViewController.h"

@interface LYBURLComponentsViewController ()

@end

@implementation LYBURLComponentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlStr = @"https://coupon.m.jd.com/coupons/show.action?key=5e097e9662a84546aa277bcb0e983ee0&roleId=18705425&to=guanyiju.jd.com&name=张三";
    NSDictionary *p1 = [self getKeyValuesWithURLStr:urlStr];
    NSLog(@"p1:%@",p1);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url:%@",url);
    
    NSString *urlStr1 = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url1 = [NSURL URLWithString:urlStr1];
    NSLog(@"url1:%@",url1);
}

- (NSDictionary *)getKeyValuesWithURLStr:(NSString *)urlString{
    if(!urlString) return nil;
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:urlString];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name && obj.value) {
            parm[obj.name] = obj.value;
        }
    }];
    return parm;
}

@end
