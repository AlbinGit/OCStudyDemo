//
//  LYBBorderRadiusViewController.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2021/3/9.
//  Copyright © 2021 Albin. All rights reserved.
//

#import "LYBBorderRadiusViewController.h"
#import "LYBCornerRadiusUtil.h"

@interface LYBBorderRadiusViewController ()

@property (nonatomic, assign) CornerRadii cornerRadii;
@property (nonatomic, strong) UIView *myView;

@end

@implementation LYBBorderRadiusViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 100, 100)];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];

    //切圆角
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    self.cornerRadii = CornerRadiiMake(50, 20, 20, 35);
    CGPathRef path = CYPathCreateWithRoundedRect(view1.bounds,self.cornerRadii);
    shapeLayer.path = path;
    CGPathRelease(path);
    view1.layer.mask = shapeLayer;
    
    UIView *view11 = [[UIView alloc] initWithFrame:CGRectMake(view1.maxX + 20, 80, 100, 100)];
    view11.backgroundColor = [UIColor orangeColor];
    [view11 addCornerWithCornerRadii:BNKCornerRadiiMake(50, 20, 20, 35)];
    [self.view addSubview:view11];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, view1.maxY + 10, 100, 100)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    [view2 addShadowWithCornerRadius:16 shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 2) shadowOpacity:0.15 shadowRadius:4];
    [view2 addShadowWithCornerRadius:16 shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 2) shadowOpacity:0.15 shadowRadius:4];
    [view2 addShadowWithCornerRadius:16 shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 2) shadowOpacity:0.15 shadowRadius:4];
    [view2 addShadowWithCornerRadius:16 shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 2) shadowOpacity:0.15 shadowRadius:4];
    [view2 addShadowWithCornerRadius:16 shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 2) shadowOpacity:0.15 shadowRadius:4];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    view3.backgroundColor = [UIColor orangeColor];
    [view2 addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(10, view2.maxY + 10, 100, 100)];
    view4.backgroundColor = [UIColor yellowColor];
    [view4 addShadowWithSuperView:self.view cornerRadii:BNKCornerRadiiMake(50, 20, 20, 35) shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 2) shadowOpacity:0.5 shadowRadius:4];
    [self.view addSubview:view4];
    
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(10, view4.maxY + 10, 100, 100)];
    view5.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view5];
    [view5 addShadowWithCornerRadii:BNKCornerRadiiMake(50, 20, 20, 35) shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 2) shadowOpacity:0.5 shadowRadius:4];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
