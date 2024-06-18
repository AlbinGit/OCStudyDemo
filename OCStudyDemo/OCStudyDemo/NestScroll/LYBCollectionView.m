//
//  LYBCollectionView.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2024/1/4.
//  Copyright © 2024 Albin. All rights reserved.
//

#import "LYBCollectionView.h"

@implementation LYBCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

