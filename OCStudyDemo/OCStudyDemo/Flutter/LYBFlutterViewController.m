////
////  LYBFlutterViewController.m
////  OCStudyDemo
////
////  Created by 李艳彬 on 2019/12/23.
////  Copyright © 2019 Albin. All rights reserved.
////
//
//#import "LYBFlutterViewController.h"
//
//@interface LYBFlutterViewController ()
//
//@end
//
//@implementation LYBFlutterViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    UIImageView *imgView = [UIImageView new];
//    
//    [self setInitialRoute:@"one"];
//    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"one_page" binaryMessenger:self];
//    [methodChannel invokeMethod:@"one" arguments:nil];
//    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
//        NSLog(@"method:%@",call.method);
//        NSLog(@"arguments:%@",call.arguments);
//        if ([call.method isEqualToString:@"exit"]) {
//            [self.navigationController popViewControllerAnimated:YES];
//        } else if ([call.method isEqualToString:@"image"]) {
////            UIImage *image = [UIImage imageNamed:@"1"];
////            NSData *imageData = UIImagePNGRepresentation(image);
////
////            if (result) {
////                result(imageData);
////            }
//            
//            [imgView sd_setImageWithURL:[NSURL URLWithString:@"https://img13.360buyimg.com/zx/jfs/t14572/59/2202344014/21812/f677149/5a9cc0eaNd99ac51b.jpg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                if (image) {
//                    NSData *imageData = UIImagePNGRepresentation(image);
//                    if (result) {
//                        result(imageData);
//                    }
//                }
//            }];
//        }
//    }];
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
