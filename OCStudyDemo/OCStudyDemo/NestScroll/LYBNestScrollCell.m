//
//  LYBNestScrollCell.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2024/1/3.
//  Copyright © 2024 Albin. All rights reserved.
//

#import "LYBNestScrollCell.h"

@interface LYBNestScrollCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LYBNestScrollCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)loadView:(NSString *)text {
    _titleLabel.text = text;
}

@end
