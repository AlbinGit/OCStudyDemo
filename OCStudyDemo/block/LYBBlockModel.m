//
//  LYBBlockModel.m
//  OCStudyDemo
//
//  Created by Albin on 2018/3/29.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBBlockModel.h"

@implementation LYBBlockModel


- (void)startCompletionHandler:(LYBBlockModelCompletionHandler)completionHandler{
    _completionHandler = completionHandler;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self p_requestCompletion];
    });
}

- (void)p_requestCompletion{
    if (_completionHandler) {
        NSLog(@"_completionHandler:%@",_completionHandler);
        NSDictionary*dic =@{@"name":@"macRong",@"webHome":@"eqi.cc"};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        _completionHandler(data);
    }
}

- (void)completionHandler:(LYBBlockModelCompletionHandler)completionHandler{
    if (completionHandler) {
        NSLog(@"completionHandler:%@",completionHandler);
        NSDictionary *dic = @{@"name":@"macRong",@"webHome":@"eqi.cc"};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        completionHandler(data);
    }
}


@end
