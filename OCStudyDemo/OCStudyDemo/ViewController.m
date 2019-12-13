//
//  ViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/2/26.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>

@interface ViewController ()

@property (nonatomic ,strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = @[@{@"title":@"浅拷贝&深拷贝",
                     @"class":@"LYBCopyViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"圆形collectionView",
                     @"class":@"LYBCircelCollectionViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"协议",
                     @"class":@"LYBProtocolViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"Block",
                     @"class":@"LYBBlockViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"雷达demo",
                     @"class":@"LYBRadarDemoViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"thread",
                     @"class":@"LYBThreadViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"GCD",
                     @"class":@"LYBGCDViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"NSOperation",
                     @"class":@"LYBNSOperationViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"runtime",
                     @"class":@"LYBRuntimeViewController",
                     @"type":@"StoryBoard",
                     },
                   @{@"title":@"NSTimer",
                     @"class":@"LYBTimerViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"Sort",
                     @"class":@"LYBSortViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"Lock",
                     @"class":@"LYBLockViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"Media",
                     @"class":@"LYBMediaViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"weak&unsafe_unretained",
                     @"class":@"LYBWeak_unsafe_unretainedViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"Animation",
                     @"class":@"LYBAnimationViewController",
                     @"type":@"StoryBoard",
                     },
                   @{@"title":@"AttributeString",
                     @"class":@"LYBAttributeStringViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"Kartun",
                     @"class":@"LYBKartunViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"HitTest",
                     @"class":@"LYBHitTestViewController",
                     @"type":@"Normal",
                     },
                   @{@"title":@"Flutter",
                     @"class":@"FlutterViewController",
                     @"type":@"Normal",
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
    NSString *type = _dataArray[indexPath.row][@"type"];
    if ([type isEqualToString:@"StoryBoard"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        vc = [storyboard instantiateViewControllerWithIdentifier:className];
    }else{
        vc = [[NSClassFromString(className) alloc]init];
    }
    vc.title = _dataArray[indexPath.row][@"title"];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
