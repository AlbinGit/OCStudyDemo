//
//  LYBSVGViewController.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2020/7/10.
//  Copyright © 2020 Albin. All rights reserved.
//

#import "LYBSVGViewController.h"

@interface LYBSVGViewController ()

@end

@implementation LYBSVGViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 20, 20)];
    imgView.image = [UIImage imageNamed:@"uxIconFont1"];
    [self.view addSubview:imgView];
    
    for(NSString *fontfamilyname in [UIFont familyNames])
       {
           NSLog(@"family:'%@'",fontfamilyname);
           for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
           {
               NSLog(@"\tfont:'%@'",fontName);
           }
           NSLog(@"-------------");
       }
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 50)];
    UIFont *iconfont = [UIFont fontWithName:@"woziku-bsdsm-CN4262" size: 34];
    label.font = iconfont;
    label.text = @"啊啊啊嗷123";
    [self.view addSubview: label];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 300, 50)];
    label1.text = @"啊啊啊嗷123";
    [self.view addSubview: label1];
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
