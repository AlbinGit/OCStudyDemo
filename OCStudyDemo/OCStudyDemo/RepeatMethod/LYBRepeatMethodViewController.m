//
//  LYBRepeatMethodViewController.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2022/7/13.
//  Copyright © 2022 Albin. All rights reserved.
//

#import "LYBRepeatMethodViewController.h"
#import "UIColor+Extension.h"

@interface LYBRepeatMethodViewController ()

@end

@implementation LYBRepeatMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    myView.backgroundColor = [UIColor colorWithHexString:@"#FF0000"];
    [self.view addSubview:myView];
    [UIColor colorLog];
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
