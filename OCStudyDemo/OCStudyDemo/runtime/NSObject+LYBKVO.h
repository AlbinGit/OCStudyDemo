//
//  NSObject+LYBKVO.h
//  OCStudyDemo
//
//  Created by Albin on 2018/7/24.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYBObservationInfo : NSObject

void PrintDescription(NSString *name, id obj);

@end


typedef void(^LYBObservingBlock) (id observedObject,NSString *observedKey,id oldValue,id newValue);

@interface NSObject (LYBKVO)

- (void)LYB_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(LYBObservingBlock)block;

- (void)LYB_removeObserver:(NSObject *)observer forKey:(NSString *)key;


@end
