//
//  LYBTestProtocol.h
//  OCStudyDemo
//
//  Created by Albin on 2018/3/5.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LYBTestProtocol <NSObject>
@required
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *sex;
@optional
@property (nonatomic ,assign) NSInteger age;

@end
