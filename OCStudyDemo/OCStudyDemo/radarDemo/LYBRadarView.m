//
//  LYBRadarView.m
//  OCStudyDemo
//
//  Created by Albin on 2018/4/4.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBRadarView.h"
#import "LYBSectorView.h"
#import "UIColor+Extension.h"

typedef NS_ENUM(NSUInteger, SectorAnimationStatus) {//扇形视图动画状态
    SectorAnimationUnStart,
    SectorAnimationIsRunning,
    SectorAnimationIsPaused,
};

#define CircleGap   15

@interface LYBRadarView()

@property (nonatomic, strong) LYBSectorView *sectorView;         //扇形视图
@property (nonatomic, assign) SectorAnimationStatus status;

@end

@implementation LYBRadarView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupUI];
        _status = SectorAnimationUnStart;
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:({
        CGRect temp = self.frame;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((temp.size.width - temp.size.width / 3.0) / 2.0, (temp.size.height - temp.size.width / 3.0) / 2.0, temp.size.width / 3.0, temp.size.width / 3.0)];
        imageView.layer.cornerRadius = temp.size.width / 6.0;
        imageView.layer.masksToBounds = YES;
        imageView.image = [UIImage imageNamed:@"hehe.JPG"];
        imageView;
    })];
    [self addSubview:({
        CGRect temp = self.frame;
        _sectorView = [[LYBSectorView alloc] initWithRadius:temp.size.width / 6.0 + 4 * CircleGap degree:M_PI / 6];
        CGRect frame = _sectorView.frame;
        frame.origin.x = (self.frame.size.width - frame.size.width) / 2.0;
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2.0;
        _sectorView.frame = frame;
        _sectorView;
    })];
}

- (void)start {
    if (_status == SectorAnimationUnStart) {
        _status = SectorAnimationIsRunning;
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: 2 * M_PI ];
        rotationAnimation.duration = 5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [_sectorView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    if (_status == SectorAnimationIsPaused) {
        _status = SectorAnimationIsRunning;
        [self resumeLayer:_sectorView.layer];
    }
}

- (void)stop {
    _status = SectorAnimationIsPaused;
    [self pauseLayer:_sectorView.layer];
}

/**
 *  暂停动画
 *
 *  @param layer layer
 */
-(void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

/**
 *  恢复动画
 *
 *  @param layer layer
 */
- (void)resumeLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

/**
 *  主要是用于画同心圆
 *
 *  @param rect rect
 */
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray *colors = @[[UIColor colorWithHexString:@"ff4e7d"], [UIColor colorWithHexString:@"fd7293"], [UIColor colorWithHexString:@"fcb8cd"], [UIColor colorWithHexString:@"fde9f2"], [UIColor colorWithHexString:@"fcebf3"]];
    CGFloat radius = rect.size.width / 6.0;
    for (UIColor *color in colors) {
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
        CGContextSetLineWidth(context, 1);
        
        CGContextAddArc(context, rect.size.width / 2.0, rect.size.height / 2.0, radius, 0, 2* M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        radius += CircleGap;
    }
}

@end
