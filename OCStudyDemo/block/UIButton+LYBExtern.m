//
//  UIButton+LYBExtern.m
//  OCStudyDemo
//
//  Created by Albin on 2018/6/19.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "UIButton+LYBExtern.h"
#import <objc/runtime.h>

@implementation UIButton (LYBExtern)

- (void)clickAction:(UIButtonBlock)block{
    [self setBlock:block];
}

- (void)setBlock:(UIButtonBlock)block{
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButtonBlock)block{
    return objc_getAssociatedObject(self, @selector(block));
}

- (void)click:(UIButton *)btn{
    if (self.block) {
        self.block(btn);
    }
}


@end
