//
//  UIView+FSSLayout.m
//  JDBLocalizationModule-localizationModuleResource
//
//  Created by liyanbin16 on 2023/12/13.
//

#import "UIView+FSSLayout.h"
#import <objc/runtime.h>

@implementation UIView (FSSLayout)

- (void)setFss_paddingTop:(CGFloat)fss_paddingTop {
    objc_setAssociatedObject(self, @selector(fss_paddingTop), @(fss_paddingTop), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)fss_paddingTop {
    // _cmd：表示当前方法 @selector
    // _cmd == @selector(fss_paddingTop)
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFss_paddingLeft:(CGFloat)fss_paddingLeft {
    objc_setAssociatedObject(self, @selector(fss_paddingLeft), @(fss_paddingLeft), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)fss_paddingLeft {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFss_paddingBottom:(CGFloat)fss_paddingBottom {
    objc_setAssociatedObject(self, @selector(fss_paddingBottom), @(fss_paddingBottom), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)fss_paddingBottom {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFss_paddingRight:(CGFloat)fss_paddingRight {
    objc_setAssociatedObject(self, @selector(fss_paddingRight), @(fss_paddingRight), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)fss_paddingRight {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFss_visibility:(FSSLayoutVisibility)fss_visibility {
    objc_setAssociatedObject(self, @selector(fss_visibility), @(fss_visibility), OBJC_ASSOCIATION_ASSIGN);
    self.hidden = fss_visibility == visibility ? NO : YES;
    if(self.fss_updateLayout) {
        self.fss_updateLayout(self);
    }
}

- (FSSLayoutVisibility)fss_visibility {
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setFss_updateLayout:(void (^)(UIView * _Nonnull))fss_updateLayout {
    objc_setAssociatedObject(self, @selector(fss_updateLayout), fss_updateLayout, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIView * _Nonnull))fss_updateLayout {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFss_click:(void (^)(UIView * _Nonnull))fss_click {
    objc_setAssociatedObject(self, @selector(fss_click), fss_click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tap];
}

- (void)handleTap {
    if(self.fss_click) {
        self.fss_click(self);
    }
}

- (void (^)(UIView * _Nonnull))fss_click {
    return objc_getAssociatedObject(self, _cmd);
}

@end
