//
//  LYBCarouselViewController.m
//  OCStudyDemo
//
//  Created by 李艳彬 on 2020/2/20.
//  Copyright © 2020 Albin. All rights reserved.
//

#import "LYBCarouselViewController.h"
#import "LYBCarouselHeader.h"

@interface LYBCarouselViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation LYBCarouselViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = [UIColor clearColor];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-10 * WIDTH_BASE, 0, self.contentView.width + 20 * WIDTH_BASE, self.contentView.height)];
    _imgView.layer.cornerRadius = 3;
    _imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imgView];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(self.width - 32, self.height - 21, 30, 12)];
    _backView.layer.cornerRadius = 12 / 2;
    _backView.layer.masksToBounds = YES;
    UIView *alphaView = [[UIView alloc] initWithFrame:_backView.bounds];
    alphaView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    alphaView.alpha = 0.5;
    [_backView addSubview:alphaView];
    [self.contentView addSubview:_backView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:_backView.bounds];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:9];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [_backView addSubview:_titleLabel];
}

- (void)loadView:(NSString *)imgName isShowText:(BOOL)isShowText text:(NSString *)text {
    _imgView.image = [UIImage imageNamed:imgName];
    _titleLabel.text = text;
    _backView.hidden = !isShowText;
}

@end

@interface LYBCarouselViewController ()<LYBCarouselDelegate,LYBCarouselDatasource>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) LYBCarouselView *carouselView;

@end

@implementation LYBCarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    LYBCarouselFlowLayout *flowLayout = [[LYBCarouselFlowLayout alloc] initWithStyle:LYBCarouselStyle_Normal];
    _carouselView = [[LYBCarouselView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200 * WIDTH_BASE) delegate:self datasource:self flowLayout:flowLayout];
    [_carouselView registerViewClass:[LYBCarouselViewCell class] identifier:@"cell"];
    _carouselView.backgroundColor = [UIColor orangeColor];
    _carouselView.isShowPageControl = YES;
    _carouselView.isAuto = YES;
    [self.view addSubview:_carouselView];
    
    [self requestNetworkData];
}



#pragma mark - 网络层
- (void)requestNetworkData {
    // 模拟网络请求
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *arr = [NSMutableArray array];
        NSString *imgName = @"";
        for (int i = 0; i < 4; i++) {
            imgName = [NSString stringWithFormat:@"%02d.jpg", i + 1];
            [arr addObject:imgName];
        }
        self.dataArr = arr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.carouselView reloadView];
        });
    });
}

#pragma mark - Delegate
- (NSInteger)numbersForCarousel {
    return self.dataArr.count;
}

- (UICollectionViewCell *)carouselCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LYBCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];;
    [cell loadView:self.dataArr[indexPath.row] isShowText:YES text:[NSString stringWithFormat:@"%ld/%ld",indexPath.row + 1,_dataArr.count]];
    return cell;
}

- (void)carouselView:(LYBCarouselView *)carouselView didSelectedAtIndex:(NSInteger)index {
    NSLog(@"LYBCarouselView,didSelectedAtIndex-->%ld",index);
}

- (CGSize)carouselViewItemSize {
    return CGSizeMake(SCREEN_WIDTH, 200 * WIDTH_BASE);
}

- (CGFloat)carouselViewItemMidSpace {
    return 10;
}

- (UIEdgeInsets)carouselViewEdgeInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
