//
//  LYBDeepCopyModel.m
//  OCStudyDemo
//
//  Created by Albin on 2018/2/26.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBDeepCopyModel.h"

@implementation LYBDeepCopyModel

- (id)mutableCopyWithZone:(NSZone *)zone{
    LYBDeepCopyModel *model = [[LYBDeepCopyModel allocWithZone:zone]init];
    model.name = [_name mutableCopy];
    model.sex = [_sex mutableCopy];
    model.mstr = [_mstr mutableCopy];
    model.marr = [[NSMutableArray alloc]initWithArray:_marr copyItems:YES];
    return model;
}


@end
