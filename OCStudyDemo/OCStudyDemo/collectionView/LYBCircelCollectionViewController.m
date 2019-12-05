//
//  LYBCircelCollectionViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/2/27.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBCircelCollectionViewController.h"
#import "MagicCircleLayout.h"
#import "CNCilrcleCollectionViewCell.h"
#import "LYBCellModel.h"
#import "DSCircularLayout.h"

#define CN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define CN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LYBCircelCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,assign) CGFloat startAngle;
@property (nonatomic ,assign) CGFloat endAngle;
@property (nonatomic ,assign) CGSize itemSize;
@property (nonatomic ,assign) CGFloat radius;
@property (nonatomic ,assign) CGFloat angularSpacing;//cell之前的间隔
@property (nonatomic ,assign) CGFloat circumference;//周长
@property (nonatomic ,assign) CGFloat maxNoOfCellsInCircle;//圆内cell最多个数
@property (nonatomic ,assign) CGFloat angleOfEachItem;//每个cell的度数


@end

@implementation LYBCircelCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self.view addSubview:self.collectionView];

    CGFloat allItemAngle = _angleOfEachItem*_dataArray.count;
    CGFloat l = allItemAngle*_radius;
    CGFloat angle = (M_PI-_angleOfEachItem)/4;
    CGFloat l1 = angle*_radius;
    
    [self.collectionView setContentOffset:CGPointMake(100*l-l1, 0)];
}

- (void)initData{
    _dataArray = [NSMutableArray array];
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    for (NSString *str in array) {
        LYBCellModel *model = [LYBCellModel new];
        model.title = str;
        [_dataArray addObject:model];
    }
    
    _startAngle = M_PI;
    _endAngle = 0;
    _itemSize = CGSizeMake(80, 80);
    _radius = (CN_SCREEN_WIDTH - _itemSize.width)/2;
    _angularSpacing = 100;
    
    _circumference = ABS(_startAngle - _endAngle)*_radius;
    _maxNoOfCellsInCircle =  _circumference/(MAX(_itemSize.width, _itemSize.height) + _angularSpacing/2);
    _angleOfEachItem = ABS(_startAngle - _endAngle)/_maxNoOfCellsInCircle;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
//        MagicCircleLayout *layout = [[MagicCircleLayout alloc]init];
//        layout.hideAngleBegin = -90;
//        layout.hideAngleEnd = 90;
//        layout.hideNum = 7;
//        layout.itemSize = CGSizeMake(80 , 80);
        
        DSCircularLayout *layout = [[DSCircularLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.rotateItems = YES;
        [layout initWithCentre:self.view.center radius:_radius itemSize:_itemSize andAngularSpacing:_angularSpacing];
        [layout setStartAngle:M_PI endAngle:0];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CN_SCREEN_WIDTH, CN_SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[CNCilrcleCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count*1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CNCilrcleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell) {
        LYBCellModel *model = _dataArray[indexPath.item%_dataArray.count];
        cell.backgroundColor = [UIColor orangeColor];
        [cell loadView:model];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}




- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = (_angleOfEachItem*_radius)/2;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x+(5*_angleOfEachItem-M_PI)/4*_radius;
    targetContentOffset->y = targetOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollView.x:%f",scrollView.contentOffset.x);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
