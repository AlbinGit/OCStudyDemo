//
//  LYBImageView.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2023/2/14.
//  Copyright © 2023 Albin. All rights reserved.
//

#import "LYBImageView.h"

@interface LYBImageView()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation LYBImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blueColor];
    _imageView = [[UIImageView alloc] init];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
}

- (void)setImage:(UIImage *)image {
    if (image.size.height <= 0 || image.size.height <= 0 || self.width <= 0 || self.height <= 0) {
        return;
    }
    CGFloat scale = self.width / self.height;
    CGFloat imageScale = image.size.width / image.size.height;
    if (scale > imageScale) {
        CGFloat height = self.width / (image.size.width / image.size.height);
        _imageView.frame = CGRectMake(0, 0, self.width, height);
    } else {
        _imageView.frame = CGRectMake(0, 0, self.width, self.height);
    }
    _imageView.image = image;
}



@end
