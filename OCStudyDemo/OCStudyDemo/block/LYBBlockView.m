//
//  LYBBlockView.m
//  OCStudyDemo
//
//  Created by Albin on 2018/3/29.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBBlockView.h"

@implementation LYBBlockView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [btn setTitle:@"block回调" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)btnClick:(UIButton *)btn{
    if (_completionHandler) {
        _completionHandler(btn.titleLabel.text);
    }
    self.completionHandler = nil;//如果点击了btn回调，就会解除循环引用，否则还是会内存泄漏
}

- (void)dealloc{
    NSLog(@"dealloc-->%@",NSStringFromClass(self.class));
}

@end
