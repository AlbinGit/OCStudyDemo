//
//  LYBTimerViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/4/9.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBTimerViewController.h"
#import "LYBTimerClass.h"
#import <objc/message.h>

@interface LYBTimerViewController ()<LYBTimerClassDelegate>

@property (nonatomic ,strong) LYBTimerClass *timerClass;

@end

@implementation LYBTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _timerClass = [[LYBTimerClass alloc]init];
    _timerClass.delegate = self;
    [_timerClass startPolling];
//    [_timerClass startPolling1];
}

- (void)doSomeThing{
    [self log];
}

- (void)log{
    NSLog(@"haha");
}

- (void)dealloc{
    NSLog(@"dealloc --> LYBTimerViewController");
//    [_timerClass stopPolling];
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
