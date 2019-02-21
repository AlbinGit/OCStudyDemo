//
//  FabricCircleLayout.h
//  Circle布局
//
//  Created by 南希 on 16/1/26.
//  Copyright © 2016年 南希. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CicelLayoutDelegate <NSObject>

- (void)changeNumOfCollectioncellWithOffset:(CGFloat)offsetY;

@end

@interface MagicCircleLayout : UICollectionViewLayout

@property (nonatomic ,assign)CGSize itemSize;
@property (nonatomic ,assign)CGFloat radius;
@property (nonatomic ,assign)CGFloat anglePerItem;//cell与cell之间的角度
@property (nonatomic ,assign)CGPoint anchorPoin;
@property (nonatomic ,assign)CGFloat centerY;
@property (nonatomic ,assign)CGFloat angle;
@property (nonatomic ,assign)CGFloat angleExtreme;
@property (nonatomic, assign)NSInteger startType;
@property (nonatomic, assign)CGFloat startAngle;
@property (nonatomic ,assign)BOOL isLayout;
@property (nonatomic, assign)int hideNum;
@property (nonatomic, assign)CGFloat hideAngleBegin;
@property (nonatomic, assign)CGFloat hideAngleEnd;
@property (nonatomic, assign)id<CicelLayoutDelegate>delegate;

@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;



@end
