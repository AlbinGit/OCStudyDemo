//
//  LYBFatherScrollView.h
//  OCStudyDemo
//
//  Created by liyanbin16 on 2024/1/3.
//  Copyright © 2024 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYBFatherScrollView : UIScrollView

- (void)containerAddSubview1:(UIView *)view;
- (void)containerAddSubview2:(UIView *)view;

- (void)subscrollViewDidScroll:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
