//
//  LYBHitTestViewController.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2019/11/18.
//  Copyright © 2019 Albin. All rights reserved.
//

#import "LYBHitTestViewController.h"
#import "LYBHitTestAView.h"
#import "LYBHitTestBView.h"
#import "LYBHitTestCView.h"

@interface LYBHitTestViewController ()
{
    LYBHitTestAView *_viewA;
    LYBHitTestBView *_viewB;
    LYBHitTestCView *_viewC;
}
@end

@implementation LYBHitTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _viewA = [[LYBHitTestAView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300) / 2, (SCREEN_HEIGHT - 500)/2, 300, 500)];
    _viewA.backgroundColor = [UIColor redColor];
    _viewA.userInteractionEnabled = YES;
    [self.view addSubview:_viewA];
    UITapGestureRecognizer *tapA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapA)];
    [_viewA addGestureRecognizer:tapA];
    
    _viewB = [[LYBHitTestBView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, (SCREEN_HEIGHT - 400)/2, 200, 400)];
    _viewB.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_viewB];
    UITapGestureRecognizer *tapB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapB)];
    [_viewB addGestureRecognizer:tapB];
    
    _viewC = [[LYBHitTestCView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, (SCREEN_HEIGHT - 300)/2, 100, 300)];
    _viewC.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_viewC];
    UITapGestureRecognizer *tapC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapC)];
    _viewC.viewA = _viewA;
    [_viewC addGestureRecognizer:tapC];
    
    UIButton *btnC = [UIButton buttonWithType:UIButtonTypeCustom];
    btnC.frame = CGRectMake(0, 0, 100, 100);
    btnC.backgroundColor = [UIColor blueColor];
    [btnC addTarget:self action:@selector(btnC) forControlEvents:UIControlEventTouchUpInside];
    [_viewC addSubview:btnC];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    field.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:field];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)tapA {
    NSLog(@"A");
}

- (void)tapB {
    NSLog(@"B");
}

- (void)tapC {
    NSLog(@"C");
}

- (void)btnC {
    NSLog(@"btnC");
}

@end
