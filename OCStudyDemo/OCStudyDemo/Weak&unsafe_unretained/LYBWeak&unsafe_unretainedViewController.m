//
//  LYBWeak&unsafe_unretainedViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2019/8/5.
//  Copyright © 2019 Albin. All rights reserved.
//

#import "LYBWeak&unsafe_unretainedViewController.h"
#import "LYBPerson1.h"

@interface LYBWeak_unsafe_unretainedViewController ()

@end

@implementation LYBWeak_unsafe_unretainedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*weak实现原理(总结)
    Runtime 维护了一个weak表，用于存储指向某个对象的所有weak指针。weak表其实是一个hash（哈希）表，key是所指对象的地址，value是weak指针的地址（这个地址的值是所有对象的地址）数组
     **/
    
    /*weak释放为nil过程
     1.调用objc_release
     2.因为对象的引用计数为0，所以执行dealloc
     3.在dealloc中，调用_objc_rootDealloc函数
     5.调用objc_destructInstance
     6.最后调用objc_clear_deallocating
     对象准备释放时，调用clearDeallocating函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。
     **/
    
    /*
     objc_clear_deallocating该函数的动作如下：
     
     1、从weak表中获取废弃对象的地址为键值的记录
     2、将包含在记录中的所有附有 weak修饰符变量的地址，赋值为nil
     3、将weak表中该记录删除
     4、从引用计数表中删除废弃对象的地址为键值的记录
     **/
    
    
    /* __weak & __unsafe_unretained的用法以及区别
     __unsafe_unretained: 不会对对象进行retain,当对象销毁时,会依然指向之前的内存空间(野指针)
     
     __weak: 不会对对象进行retain,当对象销毁时,会自动指向nil
    **/
    [self test1];
    [self test2];
//    [self test3];
}

- (void)test1{
    LYBPerson1 *p = [[LYBPerson1 alloc] init];
    LYBPerson1 *p1 = p;
    p = nil;
    NSLog(@"%@",p1);
}

- (void)test2{
    LYBPerson1 *p = [[LYBPerson1 alloc] init];
    __weak LYBPerson1 *p1 = p;
    p = nil;
    NSLog(@"%@",p1);
}

- (void)test3{
    LYBPerson1 *p = [[LYBPerson1 alloc] init];
    __unsafe_unretained LYBPerson1 *p1 = p;
    p = nil;
    NSLog(@"%@",p1);
}

@end
