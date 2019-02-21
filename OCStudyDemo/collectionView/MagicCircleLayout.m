//
//  FabricCircleLayout.m
//  Circle布局
//
//  Created by 南希 on 16/1/26.
//  Copyright © 2016年 南希. All rights reserved.
//

#import "MagicCircleLayout.h"
#define kStopLayout    @"stopLayout"
#define kStartAngle    @"startAngle"


@interface MagicCircleLayout()
@property(nonatomic, assign) int currentIndex;
@property(nonatomic, assign) CGPoint centerPoint;
@end

@implementation MagicCircleLayout


- (int)getOneAngleForPix
{
    return sin(((180 / M_PI) * self.anglePerItem)) * self.itemSize.height;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.delegate = nil;
}


-(CGFloat)angleExtreme
{
    if ([self.collectionView numberOfItemsInSection:0] > 0) {
        return  - ([self.collectionView numberOfItemsInSection:0] - 1) * self.anglePerItem;
        
    }else
    {
        return 0;
    }
}

-(CGFloat)angle{
    //任意（偏移量）contentOffSet.x的角度
   return self.collectionView.contentOffset.y * (360 / self.collectionView.frame.size.height);
    
        //return self.collectionView.contentOffset.y * self.angleExtreme / (self.collectionView.contentSize.height - self.collectionView.bounds.size.height);
}

-(void)setRadius:(CGFloat)radius
{
    _radius = radius;
    
    //当半径改变时你需要重新计算所有值，所以要调用invalidateLayout
    [self invalidateLayout];
}

- (void)prepareLayout
{
    //和init相似，必须call super的prepareLayout以保证初始化正确
    [super prepareLayout];

    //通过offset来改变cell个数
    
    _isLayout = YES;
    
   self.radius = self.collectionView.frame.size.width* 0.5 - self.itemSize.width/2 -10;
    
    //anglePerItem可以是你想要的任何值，但是公式要确保 cell 不要被分散的太开
    self.anglePerItem = 360.0f / 10;
    
}

-(void)stopLayout:(NSNotification *)noti
{
    NSNumber * number = [noti object];
    
    _isLayout = [number boolValue];
}

- (CGSize)collectionViewContentSize
{
    if (_isLayout == NO) {
        return CGSizeMake(0, 0);
    }
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
//    NSLog(@"%f", cellCount * (self.collectionView.frame.size.height / 360) * self.anglePerItem);
    
    return CGSizeMake(self.collectionView.bounds.size.width, (cellCount + self.hideNum) * (self.collectionView.frame.size.height / 360) * self.anglePerItem);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    self.currentIndex = (int)(self.angle / self.anglePerItem);
    //NSLog(@"self.angle - %f", self.angle);
    NSMutableArray * array = [NSMutableArray array];
     NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<cellCount; i++) {
        [array addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    return array;
    
}

- (CGPoint)centerPoint
{
    CGFloat x = self.collectionView.frame.size.width / 2 ;
    CGFloat y = self.collectionView.contentOffset.y + self.collectionView.frame.size.height / 2;
    
    return CGPointMake(x, y);
}

// 获得item的坐标
- (CGPoint)getPointByAngle:(CGFloat)angle
{
    
    CGFloat x = self.centerPoint.x + self.radius * cos((angle - 90) * M_PI / 180) - self.itemSize.width * 0.5;
    CGFloat y = self.centerPoint.y + self.radius * sin((angle - 90) * M_PI / 180) - self.itemSize.width * 0.5;
    return CGPointMake(x, y);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //FabricCircleLayoutAttributes * theAttributes = [FabricCircleLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    UICollectionViewLayoutAttributes * theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat angle = indexPath.row * self.anglePerItem - self.angle;
    
//    NSLog(@"indexPath.row - %ld , currentIndex - %d , self.angle -%f",indexPath.row,self.currentIndex,self.angle);
    
    CGFloat currentAngle = (indexPath.row - self.currentIndex) * self.anglePerItem;
    CGPoint currentPoint = [self getPointByAngle:angle];
    
    if (currentAngle >= self.hideAngleEnd || currentAngle <= self.hideAngleBegin) {
        theAttributes.hidden = YES;
    }
    
    theAttributes.frame = CGRectMake(currentPoint.x, currentPoint.y, self.itemSize.width, self.itemSize.height);
    
    return theAttributes;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
