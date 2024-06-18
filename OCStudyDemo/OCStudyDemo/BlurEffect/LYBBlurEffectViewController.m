//
//  LYBBlurEffectViewController.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2023/12/8.
//  Copyright © 2023 Albin. All rights reserved.
//

#import "LYBBlurEffectViewController.h"
#import "UIView+PPEX.h"
#import "UIImage+LYBBlur.h"

@interface LYBBlurEffectViewController ()

@end

@implementation LYBBlurEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100)];
    imgV1.image = [UIImage imageNamed:@"12"];
    [self.view addSubview:imgV1];
    
//    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgV1.bottom + 10, SCREEN_WIDTH, 100)];
//    imgV2.image = [UIImage imageNamed:@"12"];
//    [self.view addSubview:imgV2];
//    [imgV2 tryToAddBlurEffectWithInputRadius:15];
    
    UIImageView *imgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgV1.bottom + 10, SCREEN_WIDTH, 100)];
    imgV3.image = [UIImage imageNamed:@"12"];
    [self.view addSubview:imgV3];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    effectView.alpha = 0.9;
    [imgV3 addSubview:effectView];
    
    UIImageView *imgV4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgV3.bottom + 10, SCREEN_WIDTH, 100)];
    imgV4.image = [[UIImage imageNamed:@"12"] fss_getImageWithBlurNumber:30];
    [self.view addSubview:imgV4];
    
    UIImageView *imgV5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgV4.bottom + 10, SCREEN_WIDTH, 100)];
    imgV5.image = [[UIImage imageNamed:@"12"] blurRadius:30];
    [self.view addSubview:imgV5];
    
}

@end
