//
//  DYNTouchDownGestureRecognizer.h
//  JDBDynamicModule
//
//  Created by 李格非 on 2021/1/12.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DYNTouchDownGestureState) {
    DYNTouchDownGestureStateOnTouch,
    DYNTouchDownGestureStateOnClick,
};

NS_ASSUME_NONNULL_BEGIN

@interface DYNTouchDownGestureRecognizer : UIGestureRecognizer


/*  手势类型   */
@property (nonatomic,assign,readonly) DYNTouchDownGestureState gestureState;

- (void)addCustomActionWithTarget:(nullable id)target action:(SEL)customAction;

@end

NS_ASSUME_NONNULL_END
