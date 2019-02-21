//
//  LYBBlockModel.h
//  OCStudyDemo
//
//  Created by Albin on 2018/3/29.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LYBBlockModelCompletionHandler) (NSData *data);

@interface LYBBlockModel : NSObject

- (void)completionHandler:(LYBBlockModelCompletionHandler)completionHandler;

@property (nonatomic ,copy) LYBBlockModelCompletionHandler completionHandler;

- (void)startCompletionHandler:(LYBBlockModelCompletionHandler)completionHandler;


@end
