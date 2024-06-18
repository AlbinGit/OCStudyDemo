//
//  FSSContainerView.h
//  JDBLocalizationModule-localizationModuleResource
//
//  Created by liyanbin16 on 2023/12/13.
//

#import <UIKit/UIKit.h>
#import "UIView+FSSLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FSSFlexDirection) {
    row = 0,//横向布局
    column//纵向布局
};

@interface FSSContainerView : UIView

@property (nonatomic, assign) FSSFlexDirection flexDirection;
@property (nonatomic, assign) BOOL autoWidth;
@property (nonatomic, assign) BOOL autoHeight;
/// 刷新所有子视图
- (void)reloadLayout;

@end

NS_ASSUME_NONNULL_END
