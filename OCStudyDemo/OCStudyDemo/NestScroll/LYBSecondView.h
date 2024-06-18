//
//  LYBSecondView.h
//  OCStudyDemo
//
//  Created by liyanbin16 on 2024/1/3.
//  Copyright © 2024 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LYBSecondViewDelegate <NSObject>

@required
- (void)subScrollViewDidScroll:(UIScrollView *)scrollView;

@end


@interface LYBSecondView : UIView

@property (nonatomic, strong) LYBCollectionView *c;
@property (nonatomic, weak) id<LYBSecondViewDelegate> delegate;
- (void)myScrollViewDidScroll:(UIScrollView *)scrollView;
@property (nonatomic, assign) BOOL isScrolling;

@end

NS_ASSUME_NONNULL_END
