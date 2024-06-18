//
//  LYBContainerViewController.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2023/12/14.
//  Copyright © 2023 Albin. All rights reserved.
//

#import "LYBContainerViewController.h"
#import "FSSContainerView.h"

@interface LYBContainerViewController ()

@end

@implementation LYBContainerViewController

- (void)dealloc {
    NSLog(@"dealloc:LYBContainerViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FSSContainerView *containerView = [[FSSContainerView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100)];
    containerView.backgroundColor = [UIColor purpleColor];
    containerView.flexDirection = row;
    containerView.autoWidth = YES;
    containerView.autoHeight = YES;
    [self.view addSubview:containerView];
    
    [containerView addSubview:[self getSubView1:CGSizeMake(100, 50)]];
    UIView *v2 = [self getSubView1:CGSizeMake(100, 50)];
    UIView *v3 = [self getSubView1:CGSizeMake(50, 100)];
    UIView *v4 = [self getSubView1:CGSizeMake(50, 100)];
    [containerView addSubview:v2];
    [containerView addSubview:v3];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [containerView addSubview:v4];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [v3 removeFromSuperview];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v2.width = 50;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v2.fss_visibility = gone;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v2.fss_visibility = visibility;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v2.fss_visibility = invisible;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v2.fss_visibility = visibility;
    });
    
    FSSContainerView *containerView1 = [[FSSContainerView alloc] initWithFrame:CGRectMake(0, containerView.bottom + 10, SCREEN_WIDTH, 100)];
    containerView1.backgroundColor = [UIColor purpleColor];
    containerView1.flexDirection = column;
    containerView1.autoWidth = YES;
    containerView1.autoHeight = YES;
    [self.view addSubview:containerView1];
    
    [containerView1 addSubview:[self getSubView1:CGSizeMake(100, 50)]];
    UIView *v22 = [self getSubView1:CGSizeMake(100, 50)];
    UIView *v33 = [self getSubView1:CGSizeMake(50, 100)];
    UIView *v44 = [self getSubView1:CGSizeMake(50, 100)];
    [containerView1 addSubview:v22];
    [containerView1 addSubview:v33];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [containerView1 addSubview:v44];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [v33 removeFromSuperview];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v22.width = 50;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v22.fss_visibility = gone;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v22.fss_visibility = visibility;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v22.fss_visibility = invisible;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v22.fss_visibility = visibility;
    });
    
    containerView1.fss_click = ^(UIView * _Nonnull view) {
        FSSContainerView *v = (FSSContainerView *)view;
        if (v.flexDirection == row) {
            v.flexDirection = column;
        } else {
            v.flexDirection = row;
        }
    };
    containerView.fss_click = ^(UIView * _Nonnull view) {
        FSSContainerView *v = (FSSContainerView *)view;
        if (v.flexDirection == row) {
            v.flexDirection = column;
        } else {
            v.flexDirection = row;
        }
        containerView1.top = v.bottom + 10;
    };
}

- (UIView *)getSubView1:(CGSize)size {
    UIView *v1 = [[UIView alloc] init];
    v1.size = size;
    v1.fss_paddingTop = 10;
    v1.fss_paddingLeft = 10;
    v1.fss_paddingBottom = 10;
    v1.fss_paddingRight = 10;
    v1.backgroundColor = [UIColor yellowColor];
    v1.fss_click = ^(UIView * _Nonnull view) {
        view.fss_visibility = gone;
    };
    return v1;
}


@end
