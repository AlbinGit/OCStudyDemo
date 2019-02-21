//
//  LYBBlockViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/3/29.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBBlockViewController.h"
#import "LYBBlockView.h"
#import "LYBBlockModel.h"
@interface LYBBlockViewController ()

@property (nonatomic ,assign) NSInteger i;
@property (nonatomic ,copy) void(^block)(void);//属于self的block,会循环引用
@property (nonatomic ,copy) NSString *titleStr;
@property (nonatomic ,strong) NSData *data;
@property (nonatomic ,strong) LYBBlockModel *model;

@end

@implementation LYBBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test1];
//    [self test2];
    [self test3];
    [self test4];
}

- (void)test4{
    _model = [[LYBBlockModel alloc]init];
    [_model completionHandler:^(NSData *data) {
        _data = data;//self持有model，model不持有block,所以不循环引用
        NSLog(@"data:%@",data);
    }];
}

- (void)test3{
    LYBBlockModel *model = [[LYBBlockModel alloc]init];
    [model startCompletionHandler:^(NSData *data) {
        _data = data;//self不持有model，所以不循环引用
        NSLog(@"data:%@",data);
    }];
}

- (void)test2{
    LYBBlockView *blockView = [[LYBBlockView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:blockView];//这时self就持有了blockView，下面的block会循环引用
    [blockView setCompletionHandler:^(NSString *title) {
        _titleStr = title;
        NSLog(@"title--%@",_titleStr);
    }];
}

- (void)test1{
    _i = 1;
    //定义在函数外面的block是global类型的
    //定义在函数内部的block，但是没有捕获任何自动变量，那么它也是全局的。比如下面这样的代码
    NSInteger (^block)(void)=^{
//        _i = 2;
        NSInteger a = 110;
        return a;
    };
    NSLog(@"^block:%@",block);//global,没有捕获任何自动变量
    NSLog(@"a-->%ld",block());
    
    [self testBlock:^{
        _i = 3;
        NSLog(@"i-->%ld",(long)_i);
    }];
    
    
//    self.block = ^{
//        //循环引用
//        _i = 4;
//        NSLog(@"i-->%ld",(long)_i);
//    };
//    self.block();
    
    NSInteger __block a = 10;
    void (^handler)(void) = ^{
        a = 20;
        NSLog(@"a:%ld",(long)a);
    };
    handler();
    a = 30;
}

- (void)testBlock:(void(^)(void))block{
    _i = 4;
    if (block) {
        block();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"dealloc-->%@",NSStringFromClass(self.class));
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
