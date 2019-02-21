//
//  LYBRadarDemoViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/4/4.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBRadarDemoViewController.h"
#import "LYBRadarView.h"
@interface LYBRadarDemoViewController ()

@end

@implementation LYBRadarDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LYBRadarView *radarView = [[LYBRadarView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:radarView];
    [radarView start];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
    view1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view1];
    [view1 floatAnimation];
    view1.alpha = 0.5;
    view1.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
