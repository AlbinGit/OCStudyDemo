//
//  UIView+FSSLayout.h
//  JDBLocalizationModule-localizationModuleResource
//
//  Created by liyanbin16 on 2023/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FSSLayoutVisibility) {
    visibility = 0,
    invisible,
    gone,
};

@interface UIView (FSSLayout)

@property (nonatomic, assign) CGFloat fss_paddingTop;
@property (nonatomic, assign) CGFloat fss_paddingLeft;
@property (nonatomic, assign) CGFloat fss_paddingBottom;
@property (nonatomic, assign) CGFloat fss_paddingRight;
@property (nonatomic, assign) FSSLayoutVisibility fss_visibility;
@property (nonatomic, copy) void(^fss_updateLayout)(UIView *view);
@property (nonatomic, copy) void(^fss_click)(UIView *view);

@end

NS_ASSUME_NONNULL_END



