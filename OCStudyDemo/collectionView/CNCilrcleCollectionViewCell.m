//
//  CNCilrcleCollectionViewCell.m
//  ChinaNews
//
//  Created by Albin on 2017/3/20.
//  Copyright © 2017年 Liufangfang. All rights reserved.
//

#import "CNCilrcleCollectionViewCell.h"
#import "LYBCellModel.h"

@implementation CNCilrcleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    
    self.imgView = ({
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.layer.masksToBounds = YES;
        imageView;
    });
    [self.contentView addSubview:_imgView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.frame = self.bounds;
    self.layer.cornerRadius = self.bounds.size.width/2;
}

- (void)loadView:(LYBCellModel *)model
{
    _titleLabel.text = model.title;
}

@end
