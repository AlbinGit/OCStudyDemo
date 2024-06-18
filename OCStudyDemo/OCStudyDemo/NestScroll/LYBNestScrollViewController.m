//
//  LYBNestScrollViewController.m
//  OCStudyDemo
//
//  Created by liyanbin16 on 2024/1/3.
//  Copyright © 2024 Albin. All rights reserved.
//

#import "LYBNestScrollViewController.h"
#import "LYBNestScrollCell.h"
#import "LYBFatherScrollView.h"
#import "LYBSecondView.h"
#import "LYBCollectionView.h"

@interface LYBNestScrollViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LYBSecondViewDelegate>

@property (nonatomic,strong) LYBFatherScrollView *fV;
@property (nonatomic,strong) LYBCollectionView *c1;
@property (nonatomic,strong) LYBSecondView *c2;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *footerView;

@property (nonatomic,assign) CGPoint pointA;
@property (nonatomic,assign) BOOL canParentViewScroll;
@property (nonatomic,assign) BOOL canChildViewScroll;
@property (nonatomic,assign) BOOL isSwipeUp;

@property (nonatomic,assign) CGPoint point1;
@property (nonatomic,assign) CGPoint point2;

@end

@implementation LYBNestScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _canParentViewScroll = NO;
    _canChildViewScroll = YES;
    _isSwipeUp = NO;
    [self.view addSubview:self.c1];
    [_c1 addSubview:self.headerView];
    [_c1 addSubview:self.footerView];
//    CGFloat contentHeight = _c1.contentSize.height + _c1.contentInset.top + _c1.contentInset.bottom;
//    _c1.height = MIN(_c1.height, contentHeight);
//    [self.fV containerAddSubview2:self.c2];
    [self addF];
}

- (void)addC2 {
    [_c1 addSubview:self.c2];
//    _footerView.height += _c2.height;
    _c1.contentInset = UIEdgeInsetsMake(100, 0, _footerView.height + _c2.height, 0);
}

- (void)addF {
    [self.view addSubview:self.c2];
    [_c1 removeFromSuperview];
    _c1.frame = CGRectMake(0, -_c1.height, _c1.width, _c1.height);
    [_c2.c addSubview:_c1];
    [_c1 layoutIfNeeded];
    _point1 = CGPointMake(0, _c1.contentSize.height + _c1.contentInset.bottom - _c1.height);
    _point2 = CGPointMake(0, -_c2.c.contentInset.top);
}

- (LYBFatherScrollView *)fV {
    if (!_fV) {
        _fV = [[LYBFatherScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _fV;
}

- (UICollectionView *)c1 {
    if (!_c1) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 0;
        _c1 = [[LYBCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _c1.backgroundColor = [UIColor clearColor];
        _c1.delegate = self;
        _c1.dataSource = self;
        _c1.showsVerticalScrollIndicator = NO;
        _c1.showsHorizontalScrollIndicator = NO;
        [_c1 registerClass:[LYBNestScrollCell class] forCellWithReuseIdentifier:@"LYBNestScrollCell"];
        if (@available(iOS 11.0, *)) {
            _c1.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _c1.contentInset = UIEdgeInsetsMake(100, 0, 100, 0);
    }
    return _c1;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -100, SCREEN_WIDTH, 100)];
        _headerView.backgroundColor = [UIColor yellowColor];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        //获取内容高度
        [_c1 layoutIfNeeded];
        CGFloat contentHeight = _c1.contentSize.height;
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, contentHeight, SCREEN_WIDTH, 100)];
        _footerView.backgroundColor = [UIColor yellowColor];
        _pointA = CGPointMake(0, _c1.contentSize.height + _c1.contentInset.bottom-20);
    }
    return _footerView;
}

- (LYBSecondView *)c2 {
    if (!_c2) {
        _c2 = [[LYBSecondView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _c2.delegate = self;
    }
    return _c2;
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
    [self handelScrollViewDidScroll1:scrollView];
}

- (void)subScrollViewDidScroll:(UIScrollView *)scrollView {
    [self handelScrollViewDidScroll1:scrollView];
}

- (void)handelScrollViewDidScroll1:(UIScrollView *)scrollView {
    if (scrollView == _c1) {
        if (!_canChildViewScroll) {
            scrollView.contentOffset = _point1;
        }
        if (scrollView.contentOffset.y >= _point1.y) {
            scrollView.contentOffset = _point1;
            _canChildViewScroll = NO;
            _canParentViewScroll = YES;
        }
    } else {
        if (!_canParentViewScroll) {
            scrollView.contentOffset = _point2; // point A
            _canChildViewScroll = YES;
        }
        if (scrollView.contentOffset.y <= _point2.y) {
            
            scrollView.contentOffset = _point2;
            _canParentViewScroll = NO;
            _canChildViewScroll = YES;
        }
        
        
    }
}

- (void)handelScrollViewDidScroll:(UIScrollView *)scrollView {
    _c2.isScrolling = YES;
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:self.view];
    // 向下滑动
    if(velocity.y > 80){
        _isSwipeUp = NO;
    // 向上滑动
    }else if(velocity.y < -80){
        _isSwipeUp = YES;
    }
    if (scrollView == _c1) {
        if (!_isSwipeUp) {
            return;
        }
        if (!_canParentViewScroll) {
            scrollView.contentOffset = _pointA; // point A
            _canChildViewScroll = YES;
        }
        if (scrollView.contentOffset.y >= _pointA.y) {
            scrollView.contentOffset = _pointA;
            _canParentViewScroll = NO;
            _canChildViewScroll = YES;
        }
    } else {
        if (_isSwipeUp) {
            return;
        }
        if (!_canChildViewScroll) {
            scrollView.contentOffset = CGPointZero; // point B
        }
        if (scrollView.contentOffset.y <= 0) {
            scrollView.contentOffset = CGPointZero; // point B
            _canChildViewScroll = NO;
            _canParentViewScroll = YES;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        // 停止后要执行的代码
        _c2.isScrolling = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            // 停止后要执行的代码
            _c2.isScrolling = NO;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"111");
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
