//
//  LYBFatherScrollView.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2024/1/3.
//  Copyright © 2024 Albin. All rights reserved.
//

#import "LYBFatherScrollView.h"
#import "FSSContainerView.h"
#import "LYBSecondView.h"

@interface LYBFatherScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) FSSContainerView *containerView;
@property (nonatomic, strong) UIScrollView *firstV;
@property (nonatomic, strong) UIScrollView *secondV;

@property (nonatomic, assign) BOOL canParentViewScroll;
@property (nonatomic, assign) BOOL canFirstViewScroll;
@property (nonatomic, assign) BOOL canSecondViewScroll;

@property (nonatomic, assign) CGFloat y;

@end

@implementation LYBFatherScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.delegate = self;
        
        _containerView = [[FSSContainerView alloc] initWithFrame:self.bounds];
        _containerView.flexDirection = column;
        _containerView.autoHeight = YES;
        [self addSubview:_containerView];
        _canFirstViewScroll = YES;
        _canSecondViewScroll = NO;
        _canParentViewScroll = NO;
    }
    return self;
}

- (void)containerAddSubview1:(UIView *)view {
    [_containerView addSubview:view];
    self.contentSize = CGSizeMake(self.width, _containerView.height);
    _firstV = view;
}

- (void)containerAddSubview2:(UIView *)view {
    [_containerView addSubview:view];
    self.contentSize = CGSizeMake(self.width, _containerView.height);
    _secondV = view.subviews[0];
}

- (void)subscrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollViewDidScroll:scrollView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return;
    }
    if ([scrollView isKindOfClass:[LYBFatherScrollView class]]) {
        NSLog(@"===Father");
        if (!_canParentViewScroll) {
            if (_canFirstViewScroll) {
                scrollView.contentOffset = CGPointMake(0, 0);
                
            }
            else if (_canSecondViewScroll) {
                scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
                
            }
        }
        if (scrollView.contentOffset.y <= 0) {
            scrollView.contentOffset = CGPointMake(0, 0);
            _canParentViewScroll = NO;
            _canFirstViewScroll = YES;
            _canSecondViewScroll = NO;
        } else if (scrollView.contentOffset.y >= SCREEN_HEIGHT) {
            scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
            _canParentViewScroll = NO;
            _canFirstViewScroll = NO;
            _canSecondViewScroll = YES;
            // 传递滚动给子视图
            if (!_secondV.dragging && !_secondV.decelerating) {
                CGFloat offsetY = scrollView.contentOffset.y - SCREEN_HEIGHT;
                CGPoint offset = _secondV.contentOffset;
                offset.y += offsetY;
                CGFloat maxOffsetY = _secondV.contentSize.height - SCREEN_HEIGHT;
                if (offset.y > maxOffsetY) {    // 限制不超出子视图的滚动范围
                    offset.y = maxOffsetY;
                }
                _secondV.contentOffset = offset;
            }
        } else {
            _canParentViewScroll = YES;
            _canFirstViewScroll = NO;
            _canSecondViewScroll = NO;
        }
    }
    else if ([scrollView.superview isKindOfClass:[LYBSecondView class]]) {
        NSLog(@"===Second");
        if (!_canSecondViewScroll) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        if (scrollView.contentOffset.y <= 0) {
            _canParentViewScroll = YES;
            _canFirstViewScroll = NO;
            _canSecondViewScroll = NO;
        }
        if (_canParentViewScroll) {
            _canFirstViewScroll = NO;
            _canSecondViewScroll = NO;
        } else {
            _canParentViewScroll = NO;
            _canFirstViewScroll = NO;
            _canSecondViewScroll = YES;
        }
    }
    else {
        NSLog(@"===First");
        CGFloat contentHeight = scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom;
        if (!_canFirstViewScroll) {
            scrollView.contentOffset = CGPointMake(0, contentHeight-scrollView.contentInset.top-SCREEN_HEIGHT);
        }
        CGFloat scrollY = scrollView.contentOffset.y + scrollView.contentInset.top;
        if (scrollY + SCREEN_HEIGHT >= contentHeight) {
            _canParentViewScroll = YES;
            _canFirstViewScroll = NO;
            _canSecondViewScroll = NO;
        }
        if (_canParentViewScroll) {
            _canFirstViewScroll = NO;
            _canSecondViewScroll = NO;
        } else {
            _canParentViewScroll = NO;
            _canFirstViewScroll = YES;
            _canSecondViewScroll = NO;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"===touches:%@,event:%@",touches,event);
}

@end
