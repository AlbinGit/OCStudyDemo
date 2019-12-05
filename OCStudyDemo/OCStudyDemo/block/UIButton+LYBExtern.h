//
//  UIButton+LYBExtern.h
//  OCStudyDemo
//
//  Created by Albin on 2018/6/19.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIButtonBlock) (UIButton *btn);

@interface UIButton (LYBExtern)

@property (nonatomic ,copy) UIButtonBlock block;


- (void)clickAction:(UIButtonBlock)block;

@end
