//
//  LYBAnimationViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2019/8/7.
//  Copyright © 2019 Albin. All rights reserved.
//

#import "LYBAnimationViewController.h"
#import "UIColor+Extension.h"

@interface LYBAnimationViewController () <CAAnimationDelegate>

@property (nonatomic ,strong) CALayer *colorLayer;
@property (nonatomic ,strong) UIView *colorView;
@property (nonatomic ,strong) UIBezierPath *bezierPath;

@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) NSArray *images;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *subtype;

@end

@implementation LYBAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self test3];
    [self transitionUI];
}

- (IBAction)btnAction:(id)sender {
    [self performAnimation];
}

- (void)backGroundColorAnimation{
    //步骤1：创建动画
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    //步骤2：设定动画属性
    animation.autoreverses = NO;
    animation.duration = 0.25;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    UIColor *randomColor = [UIColor randomColor];
    animation.toValue = (__bridge id _Nullable)(randomColor.CGColor);
    //步骤2：设定动画属性
    [self.colorLayer addAnimation:animation forKey:@"keyPath_backgroundColor"];
}

- (void)test1{
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(50, 150, 100, 100);
    colorLayer.backgroundColor = [UIColor redColor].CGColor;
    self.colorLayer = colorLayer;
    [self.view.layer addSublayer:colorLayer];
}

/*
 对独立图层(即非UIView的关联图层，类似上述例子中的colorLayer)做更新属性的显式动画，我们需要设置一个事务来禁用图层行为，否则动画会发生两次，一次是因为显式的CABasicAnimation，另一次是因为隐式动画，从而导致我们看到的动画异常。
 */
- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag{
    if ([self.colorLayer animationForKey:@"keyPath_backgroundColor"] == anim) {
        //禁用隐式动画
        [CATransaction begin];
        [CATransaction setDisableActions:true];
        self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
        [CATransaction commit];
    }
}

- (void)test2{
    UIView *view1 = [UIView new];
    view1.frame = CGRectMake(50 , 100, 50, 50);
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(50, 125)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH - 50, 125)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - 100)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(50, SCREEN_HEIGHT - 100)];
    NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(50, 125)];
    animation.values = @[value1,value2,value3,value4,value5];
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.duration = 4;
//    animation.keyTimes = @[@(0), @(1 / 10.0), @(5 / 10.0), @(9 / 10.0), @(1) ];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view1.layer addAnimation:animation forKey:nil];
}

//飞机曲线
- (void)test3 {
    //1.创建三次贝塞尔曲线(一种使用起始点，结束点和另外两个控制点定义的曲线);
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(50, 200)];
    [bezierPath addCurveToPoint:CGPointMake(SCREEN_WIDTH - 50, 200) controlPoint1:CGPointMake(150, 50) controlPoint2:CGPointMake(SCREEN_WIDTH - 150, 250)];
    
    //2.绘制飞行路线
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0;
    [self.view.layer addSublayer:pathLayer];
    
    //3.创建显示飞机的视图
    UIImageView *airPlaneImgView = [[UIImageView alloc] init];
    airPlaneImgView.frame = CGRectMake(0, 0, 50, 50);
    airPlaneImgView.center = CGPointMake(50, 200);
    airPlaneImgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"feiji"]];
//    airPlaneImgView.image = [UIImage imageNamed:@"feiji"];
    [self.view addSubview:airPlaneImgView];
    airPlaneImgView.opaque = YES;
    
    //4.设置关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 5.0;
    animation.path = bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;//设置根据曲线的切线自动旋转,让动画更加真实
    [airPlaneImgView.layer addAnimation:animation forKey:nil];
}

//CAGroupAnimation
- (void)test4 {
    //创建显示颜色的图层
    self.colorView = [UIView new];
    self.colorView.frame = CGRectMake(0, 0, 60, 60);
    self.colorView.center = CGPointMake(50, 200);
    self.colorView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.colorView];
    
    //创建贝塞尔曲线，即帧动画运动轨迹
    self.bezierPath  = [[UIBezierPath alloc] init];
    [self.bezierPath moveToPoint:CGPointMake(50, 200)];
    [self.bezierPath addCurveToPoint:CGPointMake(SCREEN_WIDTH - 50, 200) controlPoint1:CGPointMake(150, 50) controlPoint2:CGPointMake(SCREEN_WIDTH - 150, 250)];
    
    //绘制绘制path，便于观察动画；
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = self.bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
}

- (void)groupAnimation {
    //移除可能未执行完的动画，防止多重动画导致异常
    [self.colorView.layer removeAnimationForKey:@"groupAnimation"];
    
    //1.创建基础动画：修改背景色为紫色
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"backgroundColor";
    basicAnimation.toValue = (__bridge id _Nullable)([UIColor purpleColor].CGColor);
    
    //2.创建关键帧动画
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animation];
    keyFrameAnimation.keyPath = @"position";
    keyFrameAnimation.path = self.bezierPath.CGPath;
    keyFrameAnimation.rotationMode = kCAAnimationRotateAuto;
    
    //3.创建组动画：组合基础动画和关键帧动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[basicAnimation, keyFrameAnimation];
    groupAnimation.duration = 4.0;
    [self.colorView.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
}

- (void)transitionUI {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.imageView.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:self.imageView];
    
    self.images = @[[UIImage imageNamed:@"1"],
                    [UIImage imageNamed:@"2"],
                    [UIImage imageNamed:@"3"],
                    [UIImage imageNamed:@"4"]];
    
    /*
     kCATransitionFade 淡入淡出
     kCATransitionPush 推挤
     kCATransitionReveal 揭开
     kCATransitionMoveIn 覆盖
     私有：
     cube 立方体
     suckEffect 吮吸
     oglFlip 吮吸
     rippleEffect 波纹
     pageCurl 反翻页
     cameraIrisHollowOpen 开镜头
     cameraIrisHollowClose 关镜头
     */
    self.type = @"rippleEffect";
    self.subtype = kCATransitionFromRight;
}

- (void)transitonAnimation {
    CATransition *transition = [[CATransition alloc] init];
    transition.type = _type;
    transition.subtype = _subtype;
    transition.duration = 0.5;
    [self.imageView.layer addAnimation:transition forKey:nil];
    
    UIImage *currentImage = self.imageView.image;
    NSUInteger index = [self.images indexOfObject:currentImage];
    index = (index + 1) % self.images.count;
    self.imageView.image = self.images[index];
}

- (void)performAnimation{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    UIView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    //使用自定义方法得到随机颜色(切换后的颜色)
    UIColor *randomColor = [UIColor randomColor];
    self.view.backgroundColor = randomColor;
    
    //使用UIView动画方法来代替属性动画(为了简化代码步骤)
    [UIView animateWithDuration:1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [coverView removeFromSuperview];
    }];
}


@end
