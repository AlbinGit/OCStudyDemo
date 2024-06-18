//
//  LYBSecondView.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2024/1/3.
//  Copyright © 2024 Albin. All rights reserved.
//

#import "LYBSecondView.h"
#import "LYBNestScrollCell.h"

@interface LYBSecondView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation LYBSecondView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.c];
    }
    return self;
}

- (UICollectionView *)c {
    if (!_c) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 0;
        _c = [[LYBCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _c.tag = 110;
        _c.backgroundColor = [UIColor clearColor];
        _c.delegate = self;
        _c.dataSource = self;
        _c.showsVerticalScrollIndicator = NO;
        _c.showsHorizontalScrollIndicator = NO;
        [_c registerClass:[LYBNestScrollCell class] forCellWithReuseIdentifier:@"LYBNestScrollCell"];
        if (@available(iOS 11.0, *)) {
            _c.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _c.contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT, 0, 0, 0);
    }
    return _c;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYBNestScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYBNestScrollCell" forIndexPath:indexPath];
    [cell loadView:[NSString stringWithFormat:@"%ld",indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, 100);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector:@selector(subScrollViewDidScroll:)]) {
        [_delegate subScrollViewDidScroll:scrollView];
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (_isScrolling) {
//        return _c;
//    }
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view == nil) {
//        for (UIView *subView in self.subviews) {
//            CGPoint tp = [subView convertPoint:point fromView:self];
//            if (CGRectContainsPoint(subView.bounds, tp)) {
//                view = subView;
//            }
//        }
//    }
//    return view;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"222");
}

@end
