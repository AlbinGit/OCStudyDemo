//
//  ViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/2/26.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic ,strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = @[@{@"title":@"浅拷贝&深拷贝",
                     @"class":@"LYBCopyViewController",
                     },
                   @{@"title":@"圆形collectionView",
                     @"class":@"LYBCircelCollectionViewController",
                     },
                   @{@"title":@"协议",
                     @"class":@"LYBProtocolViewController",
                     },
                   @{@"title":@"Block",
                     @"class":@"LYBBlockViewController",
                     },
                   @{@"title":@"雷达demo",
                     @"class":@"LYBRadarDemoViewController",
                     },
                   @{@"title":@"thread",
                     @"class":@"LYBThreadViewController",
                     },
                   @{@"title":@"runtime",
                     @"class":@"LYBRuntimeViewController",
                     },
                   @{@"title":@"NSTimer",
                     @"class":@"LYBTimerViewController",
                     },
                   @{@"title":@"Sort",
                     @"class":@"LYBSortViewController",
                     },
                   @{@"title":@"Lock",
                     @"class":@"LYBLockViewController",
                     },
                   @{@"title":@"Media",
                     @"class":@"LYBMediaViewController",
                     },
                   ];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"text"];
    }
    cell.textLabel.text = _dataArray[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc;
    NSString *className = _dataArray[indexPath.row][@"class"];
    if ([className isEqualToString:@"LYBRuntimeViewController"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        vc = [storyboard instantiateViewControllerWithIdentifier:className];
    }else{
        vc = [[NSClassFromString(className) alloc]init];
    }
    vc.title = _dataArray[indexPath.row][@"title"];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
