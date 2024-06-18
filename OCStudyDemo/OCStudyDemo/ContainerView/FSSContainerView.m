//
//  FSSContainerView.m
//  JDBLocalizationModule-localizationModuleResource
//
//  Created by liyanbin16 on 2023/12/13.
//

#import "FSSContainerView.h"

@interface FSSContainerView()

@property (nonatomic, strong) NSMutableArray *mySubViews;

@end

@implementation FSSContainerView

- (void)dealloc {
    NSLog(@"dealloc-FSSContainerView");
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _mySubViews = [NSMutableArray array];
    }
    return self;
}

- (void)setFlexDirection:(FSSFlexDirection)flexDirection {
    if (_flexDirection != flexDirection) {
        _flexDirection = flexDirection;
        [self reloadLayout];
    }
}


/// 刷新所有子视图
- (void)reloadLayout {
    [self layoutMySubviews:0];
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    [self addView:view];
    NSInteger index = 0;
    if ([_mySubViews containsObject:view]) {
        index = [_mySubViews indexOfObject:view];
    }
    __weak typeof(self)weakSelf = self;
    view.fss_updateLayout = ^(UIView * _Nonnull view) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf updateLayout:view];
    };
    [self layoutMySubviews:index];
}


/// 子视图fss_visibility属性变化处理
/// - Parameter view: 子视图
- (void)updateLayout:(UIView *)view {
    if (view.fss_visibility == gone) {
        [self removeView:view];
    } else {
        [self addGoneView:view];
    }
    NSInteger index = 0;
    if ([_mySubViews containsObject:view]) {
        index = [_mySubViews indexOfObject:view];
    }
    [self layoutMySubviews:index];
}

- (void)willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];
    NSInteger index = 0;
    if ([_mySubViews containsObject:subview]) {
        index = [_mySubViews indexOfObject:subview];
        [_mySubViews removeObject:subview];
    }
    [self layoutMySubviews:index];
}

/// 系统方法，子视图宽高变化刷新整个view
- (void)layoutSubviews {
    [self reloadLayout];
}

/// 添加gone掉的view
/// - Parameter view: view
- (void)addGoneView:(UIView *)view {
    if ([self.subviews containsObject:view]) {
        NSInteger index = [self.subviews indexOfObject:view];
        if (![_mySubViews containsObject:view] && index <= _mySubViews.count) {
            [_mySubViews insertObject:view atIndex:index];
        }
    }
}

- (void)addView:(UIView *)view {
    if (view.fss_visibility == gone) {
        return;
    }
    if (![_mySubViews containsObject:view]) {
        [_mySubViews addObject:view];
    }
}

- (void)removeView:(UIView *)view {
    if ([_mySubViews containsObject:view]) {
        [_mySubViews removeObject:view];
    }
}

- (void)layoutMySubviews:(NSInteger)index {
    if (_autoWidth || _autoHeight) {
        [self layoutContentSize];
    }
    NSInteger count = _mySubViews.count;
    UIView *lastView = nil;
    if (index >= 1 && index < count) {
        lastView = _mySubViews[index - 1];
    }
    for (NSInteger i = index; i < count; i++) {
        UIView *subView = _mySubViews[i];
        CGFloat paddingTop = subView.fss_paddingTop;
        CGFloat paddingLeft = subView.fss_paddingLeft;
        CGFloat w = CGRectGetWidth(subView.frame);
        CGFloat h = CGRectGetHeight(subView.frame);
        CGFloat last_paddingBottom = lastView.fss_paddingBottom;
        CGFloat last_paddingRight = lastView.fss_paddingRight;
        if (_flexDirection == row) {
            CGFloat x = paddingLeft + CGRectGetMaxX(lastView.frame) + last_paddingRight;
            CGFloat y = paddingTop;
            subView.frame = CGRectMake(x, y, w, h);
        }
        else if (_flexDirection == column) {
            CGFloat x = paddingLeft;
            CGFloat y = paddingTop + CGRectGetMaxY(lastView.frame) + last_paddingBottom;
            subView.frame = CGRectMake(x, y, w, h);
        }
        lastView = subView;
    }
}

//计算父容器大小
- (void)layoutContentSize {
    CGFloat contentWidth = 0;
    CGFloat contentHeight = 0;
    for (UIView *subView in _mySubViews) {
        CGFloat w = CGRectGetWidth(subView.frame);
        CGFloat h = CGRectGetHeight(subView.frame);
        if (_flexDirection == row) {
            contentWidth += subView.fss_paddingLeft + w + subView.fss_paddingRight;
            contentHeight = MAX(subView.fss_paddingTop + h + subView.fss_paddingBottom, contentHeight);
        }
        else if (_flexDirection == column) {
            contentWidth = MAX(subView.fss_paddingLeft + w + subView.fss_paddingRight, contentWidth);
            contentHeight += subView.fss_paddingTop + h + subView.fss_paddingBottom;
        }
    }
    if (_autoWidth) {
        self.width = contentWidth;
    }
    if (_autoHeight) {
        self.height = contentHeight;
    }
}

@end
