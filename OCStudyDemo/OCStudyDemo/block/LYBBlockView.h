//
//  LYBBlockView.h
//  OCStudyDemo
//
//  Created by Albin on 2018/3/29.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LYBBlockViewCompletionHandler) (NSString *title);

@interface LYBBlockView : UIView


@property (nonatomic ,copy) LYBBlockViewCompletionHandler completionHandler;

@end
