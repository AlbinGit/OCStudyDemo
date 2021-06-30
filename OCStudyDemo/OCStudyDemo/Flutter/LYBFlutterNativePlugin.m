////
////  LYBFlutterNativePlugin.m
////  OCStudyDemo
////
////  Created by 李艳彬 on 2019/12/23.
////  Copyright © 2019 Albin. All rights reserved.
////
//
//#import "LYBFlutterNativePlugin.h"
//
//@implementation LYBFlutterNativePlugin
//
//+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
//    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"lianchu" binaryMessenger:[registrar messenger]];
//    LYBFlutterNativePlugin *instance = [[LYBFlutterNativePlugin alloc]init];
//    [registrar addMethodCallDelegate:instance channel:channel];
//}
//
//- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
//    if ([call.method isEqualToString:@"comeonman"]) {
//        result(@"么么哒");
//    }else {
//        result(FlutterMethodNotImplemented);
//    }
//}
//
//
//@end
