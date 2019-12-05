//
//  LYBMediaViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/8/27.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LYBMediaViewController ()<MPMediaPickerControllerDelegate>
{
    MPMediaPickerController *picker;
}
@end

@implementation LYBMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getMusicList];
    });
}

- (void)getMusicList
{
    picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    
    picker.prompt = @"添加本地音乐";
    
    picker.showsCloudItems = NO;
    
    picker.allowsPickingMultipleItems = YES;
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}



//3、实现代理回调
//取消或者没选回调函数
- (void)mediaPickerDidCancel:(MPMediaPickerController*)mediaPicker
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

//选中选项之后代理回调
-(void)mediaPicker:(MPMediaPickerController*)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    for (  MPMediaItem* item in [mediaItemCollection items])
    {
        //打印输出消息
        NSLog(@"itemURL : %@",item.assetURL);
    }
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
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
