//
//  DYNTouchDownGestureRecognizer.m
//  JDBDynamicModule
//
//  Created by 李格非 on 2021/1/12.
//

#import "DYNTouchDownGestureRecognizer.h"
//#import <UIKit/UIGestureRecognizerSubclass.h>

@interface DYNTouchDownGestureRecognizer ()

/*  touch 事件   */
@property (nonatomic,assign) SEL customAction;

/*  tagert   */
@property (nonatomic,weak) id customTarget;

@property (nonatomic,assign,readwrite) DYNTouchDownGestureState gestureState;

@property(nonatomic,assign) NSTimeInterval beginTime;

@end

@implementation DYNTouchDownGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.anyObject;
    self.beginTime = touch.timestamp;
    if (self.state == UIGestureRecognizerStatePossible) {
        if (self.customAction && self.view == touch.view) {
            self.gestureState = DYNTouchDownGestureStateOnTouch;
            [self.customTarget performSelector:self.customAction withObject:self];
        }
        self.state = UIGestureRecognizerStateFailed;
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)addCustomActionWithTarget:(nullable id)target action:(SEL)customAction{
    self.customTarget = target;
    self.customAction = customAction;
}


@end
