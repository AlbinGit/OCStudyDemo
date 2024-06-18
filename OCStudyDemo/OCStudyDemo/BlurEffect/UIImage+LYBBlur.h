//
//  UIImage+LYBBlur.h
//  OCStudyDemo
//
//  Created by liyanbin16 on 2023/12/8.
//  Copyright © 2023 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LYBBlur)

// 图片模糊
- (UIImage *)fss_getImageWithBlurNumber:(CGFloat)blur;

/// 毛玻璃
/// - Parameter radius: 模糊度
- (UIImage*)blurRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
