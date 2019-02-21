//
//  LYBRuntimeViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/7/19.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBRuntimeViewController.h"
#import "LYBAutoDictionnary.h"
#import <objc/message.h>
#import "NSObject+LYBKVO.h"

@interface Message : NSObject

@property (nonatomic, copy) NSString *text;

@end

@implementation Message

@end

@interface LYBRuntimeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, strong) Message *message;

@end

@implementation LYBRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LYBAutoDictionnary *dict = [LYBAutoDictionnary new];
    dict.date = [NSDate dateWithTimeIntervalSince1970:475372800];
    NSLog(@"dict,date = %@",dict.date);
    
    SEL select = NSSelectorFromString(@"logStr");
    char a = ((char(*)(id,SEL))objc_msgSend)(dict,select);
    NSLog(@"a:%c",a);
    
    [dict performSelector:@selector(code)];
    
    if ([dict isKindOfClass:[LYBAutoDictionnary class]]) {
        NSLog(@"YES");
    }else{
        NSLog(@"NO");
    }
    
    [self p_kvoTest];
    
}

- (void)p_kvoTest{
    self.message = [[Message alloc] init];
    [self.message LYB_addObserver:self forKey:NSStringFromSelector(@selector(text))
                       withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
                           NSLog(@"%@.%@ is now: %@", observedObject, observedKey, newValue);
                           dispatch_async(dispatch_get_main_queue(), ^{
                               self.textField.text = newValue;
                           });
                           
                       }];
    
    [self buttonClick:nil];
}

- (IBAction)buttonClick:(id)sender {
    NSArray *msgs = @[@"Hello World!", @"Objective C", @"Swift", @"Peng Gu", @"peng.gu@me.com", @"www.gupeng.me", @"glowing.com"];
    NSUInteger index = arc4random_uniform((u_int32_t)msgs.count);
    self.message.text = msgs[index];
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
