//
//  LYBDeepCopyModel.h
//  OCStudyDemo
//
//  Created by Albin on 2018/2/26.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYBDeepCopyModel : NSObject<NSMutableCopying>

@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *sex;
@property (nonatomic ,strong) NSMutableString *mstr;
@property (nonatomic ,strong) NSMutableArray *marr;


@end
