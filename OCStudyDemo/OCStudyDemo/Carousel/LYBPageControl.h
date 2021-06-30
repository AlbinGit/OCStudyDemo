//
//  LYBPageControl.h
//  OCStudyDemo
//
//  Created by liyanbin16 on 2021/6/30.
//  Copyright © 2021 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYBPageControl : UIView

@property(nonatomic,assign) NSInteger numberOfPages;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) UIImage * imagePageStateNormal;
@property(nonatomic,strong) UIImage * imagePageStateHighlighted;
@property(nonatomic,assign) float pageSpace;

@end

NS_ASSUME_NONNULL_END
