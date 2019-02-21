//
//  CNCilrcleCollectionViewCell.h
//  ChinaNews
//
//  Created by Albin on 2017/3/20.
//  Copyright © 2017年 Liufangfang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYBCellModel;

@interface CNCilrcleCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UIImageView *imgView;

- (void)loadView:(LYBCellModel *)model;

@end
