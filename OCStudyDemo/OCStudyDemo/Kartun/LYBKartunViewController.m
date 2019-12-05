//
//  LYBKartunViewController.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2019/11/13.
//  Copyright © 2019 Albin. All rights reserved.
//

#import "LYBKartunViewController.h"
#import "LZThreadFreezeMonitor.h"

@interface LYBKartunViewController ()

@end

@implementation LYBKartunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[LZThreadFreezeMonitor sharedInstance] startMonitor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[LZThreadFreezeMonitor sharedInstance] stopMonitor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self kartunTest];
}


- (void)kartunTest {
    //    dispatch_async(dispatch_get_main_queue(), ^{
//    for (int i = 0; i < 9999; i++) {
//        NSLog(@"test");
//    }
    //    });
    
    sleep(2);
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
