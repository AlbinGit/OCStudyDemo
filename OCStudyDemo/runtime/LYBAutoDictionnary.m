//
//  LYBAutoDictionnary.m
//  OCStudyDemo
//
//  Created by Albin on 2018/7/19.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "LYBAutoDictionnary.h"
#import <objc/runtime.h>
#import "LYBTestMethod.h"
#import "LYBInvocation.h"

@interface LYBAutoDictionnary()

@property (nonatomic ,strong) NSMutableDictionary *backingStore;

@end

@implementation LYBAutoDictionnary
@dynamic string,number,date,opaqueObject;

- (instancetype)init{
    if (self = [super init]) {
        _backingStore = [NSMutableDictionary new];
    }
    return self;
}

id autoDictionnaryGetter(id self,SEL _cmd){
    LYBAutoDictionnary *typeSelf = (LYBAutoDictionnary *)self;
    NSMutableDictionary *backingStore = typeSelf.backingStore;
    NSString *key = NSStringFromSelector(_cmd);
    return [backingStore objectForKey:key];
}
void autoDictionnarySetter(id self,SEL _cmd,id value){
    LYBAutoDictionnary *typeSelf = (LYBAutoDictionnary *)self;
    NSMutableDictionary *backingStore = typeSelf.backingStore;
    NSString *selString = NSStringFromSelector(_cmd);
    NSMutableString *key = [selString mutableCopy];
    //Remove the ':' at the end
    [key deleteCharactersInRange:NSMakeRange(key.length-1, 1)];
    //Remove the 'set' prefix
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    //Lowercase the first character
    NSString *lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
    if (value) {
        [backingStore setObject:value forKey:key];
    }else{
        [backingStore removeObjectForKey:key];
    }
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSString *selString = NSStringFromSelector(sel);
    if ([selString hasPrefix:@"set"]) {
        class_addMethod(self, sel, (IMP)autoDictionnarySetter, "v@:@");
        return YES;
    }
    NSMutableArray *array = [NSMutableArray array];
    unsigned int count;
    objc_property_t *props = class_copyPropertyList(self, &count);
    for (int i=0; i<count; i++) {
        objc_property_t property = props[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        [array addObject:propertyName];
    }
    if ([array containsObject:selString]) {
        class_addMethod(self, sel, (IMP)autoDictionnaryGetter, "@@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}


- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSString *selString = NSStringFromSelector(aSelector);
    if ([selString isEqualToString:@"logStr"]) {
        return [LYBTestMethod new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if (aSelector == @selector(code)) {
        return [NSMethodSignature signatureWithObjCTypes:"V@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    if ([anInvocation selector] == @selector(code)) {
        LYBInvocation *invocation = [LYBInvocation new];
        [anInvocation invokeWithTarget:invocation];
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"doesNotRecognizeSelector: %@", NSStringFromSelector(aSelector));
    [super doesNotRecognizeSelector:aSelector];
}


@end
