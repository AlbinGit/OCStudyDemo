//
//  UIView+PPEX.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2023/12/8.
//  Copyright © 2023 Albin. All rights reserved.
//

#import "UIView+PPEX.h"

@implementation UIView (PPEX)

/// 设置高斯模糊(在原有基础上盖一个imageView)需要在有size之后设置
/// - Parameter inputRadius: 模糊程度, 数字越大越模糊, 设置0 , 就是移除
- (void)tryToAddBlurEffectWithInputRadius:(CGFloat)inputRadius {
    
    for (UIView *subview in self.subviews) {
        if (subview.tag == 19930713) {
            [subview removeFromSuperview];
        }
    }
    
    if (inputRadius < 0.01) {
        return;
    }
    
    // 1. 先把当前view截个图
    CGSize imageSize = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.backgroundColor = UIColor.whiteColor;
    imageView.image = [self cgreateGaussianBlurImage:image inputRadius:inputRadius];
    imageView.tag = 19930713;
    [self addSubview:imageView];
}

- (UIImage *)cgreateGaussianBlurImage:(UIImage *)image inputRadius:(CGFloat)inputRadius {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    //设置模糊程度 (值越大，越模糊)
    [filter setValue:@(inputRadius) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //        CGRect frame = [ciImage extent];
    CGImageRef outImage = [context createCGImage:result fromRect:ciImage.extent];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    // 内存释放 (补充)
    CGImageRelease(outImage);
    return blurImage;
}

@end
