//
//  LYBProtocolViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/3/5.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBProtocolViewController.h"
#import "LYBPerson1.h"
#import "LYBPerson2.h"
#import "LYBTestProtocol.h"


@interface LYBProtocolViewController ()

@end

@implementation LYBProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *name = @"albin";
    NSString *sex = @"男";
    NSInteger age = 18;
    for (NSInteger i = 0; i<2; i++) {
        if (i==0) {
            LYBPerson1<LYBTestProtocol> *p1 = (id<LYBTestProtocol>)[[LYBPerson1 alloc]init];
            [self setPersonModel:p1 withName:name sex:sex age:age];
        }else{
            LYBPerson2<LYBTestProtocol> *p2 = (id<LYBTestProtocol>)[[LYBPerson2 alloc]init];
            [self setPersonModel:p2 withName:name sex:sex age:0];
        }
    }
}

- (void)setPersonModel:(id<LYBTestProtocol>)model withName:(NSString *)name sex:(NSString *)sex age:(NSInteger)age{
    model.name = name;
    model.sex = sex;
    if (age>0) {
        model.age = age;
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
