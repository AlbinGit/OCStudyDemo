//
//  UIView+PPEX.h
//  OCStudyDemo
//
//  Created by liyanbin16 on 2023/12/8.
//  Copyright © 2023 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PPEX)

/// 设置高斯模糊(在原有基础上盖一个imageView)需要在有size之后设置
/// - Parameter inputRadius: 模糊程度, 数字越大越模糊, 设置0 , 就是移除
- (void)tryToAddBlurEffectWithInputRadius:(CGFloat)inputRadius;

@end

NS_ASSUME_NONNULL_END
