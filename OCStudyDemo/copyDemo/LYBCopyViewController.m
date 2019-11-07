//
//  LYBCopyViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/2/26.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBCopyViewController.h"
#import "LYBShallowCopyModel.h"
#import "LYBDeepCopyModel.h"
@interface LYBCopyViewController ()

@end

@implementation LYBCopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[@"1",@"2",@"3"];
    NSArray *arrayCopy = [array copy];
    NSArray *arrayMCopy = [array mutableCopy];
    NSLog(@"array:%p,arrayCopy:%p,arrayMCopy:%p",array,arrayCopy,arrayMCopy);
    NSLog(@"array:%ld,arrayCopy:%ld,arrayMCopy:%ld",array.retainCount,arrayCopy.retainCount,arrayMCopy.retainCount);
    
    NSMutableArray *MArray = [[NSMutableArray alloc]initWithArray:@[@"1",@"2",@"3"]];
    NSMutableArray *MArrayCopy = [MArray copy];
    NSMutableArray *MArrayMCopy = [MArray mutableCopy];
    [MArray removeObjectAtIndex:0];
    NSLog(@"MArray:%p,MArrayCopy:%p,MArrayMCopy:%p",MArray,MArrayCopy,MArrayMCopy);
    NSLog(@"MArray:%ld,MArrayCopy:%ld,MArrayMCopy:%ld",MArray.retainCount,MArrayCopy.retainCount,MArrayMCopy.retainCount);
    //总结：只有不可变对象copy时是浅拷贝，其他3种情况都是深拷贝
    
    LYBShallowCopyModel *model = [LYBShallowCopyModel new];
    model.name = @"Albin";
    model.sex = @"男";
    model.mstr = @"123".mutableCopy;
    model.marr = @[@"1".mutableCopy,@"2"].mutableCopy;
    LYBShallowCopyModel *modelCopy = [model copy];
    [modelCopy.mstr appendString:@"4"];
    [modelCopy.marr[0] appendString:@"2"];
//    modelCopy.name = @"bin";
    
    NSLog(@"model.name:%p,modelCopy.name:%p",model.name,modelCopy.name);
    NSLog(@"model:%p,modelCopy%p",model,modelCopy);//浅拷贝

    LYBDeepCopyModel *deepModel = [LYBDeepCopyModel new];
    deepModel.name = @"bin";
    deepModel.sex = @"nan";
    deepModel.mstr = @"123".mutableCopy;
    NSMutableString *mstr = [NSMutableString stringWithFormat:@"1"];
    deepModel.marr = @[mstr,@"2"].mutableCopy;
    LYBDeepCopyModel *deepModelMutableCopy = [deepModel mutableCopy];
    [deepModelMutableCopy.mstr appendString:@"4"];
    [deepModel.marr[0] appendString:@"2"];

    NSLog(@"deepModel.name:%p,deepModelMutableCopy.name:%p",deepModel.name,deepModelMutableCopy.name);//深拷贝
    NSLog(@"deepModel.mstr:%p,deepModelMutableCopy.mstr:%p",deepModel.mstr,deepModelMutableCopy.mstr);//深拷贝
    NSLog(@"deepModel:%p,deepModelMutableCopy:%p",deepModel,deepModelMutableCopy);//深拷贝
    
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
