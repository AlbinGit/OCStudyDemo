//
//  LYBShallowCopyModel.m
//  OCStudyDemo
//
//  Created by Albin on 2018/2/26.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBShallowCopyModel.h"

@implementation LYBShallowCopyModel

- (id)copyWithZone:(NSZone *)zone{
    LYBShallowCopyModel *model = [[[self class] allocWithZone:zone]init];
    model.name = self.name;
    model.sex = self.sex;
    model.mstr = [_mstr mutableCopy];
    model.marr = [_marr mutableCopy];
    return model;
}



@end
