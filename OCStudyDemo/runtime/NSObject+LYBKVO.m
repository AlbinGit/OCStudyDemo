//
//  NSObject+LYBKVO.m
//  OCStudyDemo
//
//  Created by Albin on 2018/7/24.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "NSObject+LYBKVO.h"
#import <objc/message.h>

NSString *const KLYBKVOClassPrefix = @"LYBKVOClassPrefix_";
NSString *const KLYBKVOAssociatedObservers = @"LYBKVOAssociatedObservers";

@interface LYBObservationInfo : NSObject

@property (nonatomic ,weak) NSObject *observer;
@property (nonatomic ,copy) NSString *key;
@property (nonatomic ,copy) LYBObservingBlock block;



@end

@implementation LYBObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key block:(LYBObservingBlock)block{
    if (self = [super init]) {
        _observer = observer;
        _key = key;
        _block = block;
    }
    return self;
}

#pragma mark - Debug Help Method
static NSArray *ClassMethodNames(Class c){
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(c, &methodCount);
    for (int i = 0; i<methodCount; i++) {
        [array addObject:NSStringFromSelector(method_getName(methodList[i]))];
    }
    free(methodList);
    return array;
}

static void PrintDescription(NSString *name, id obj){
    NSString *str = [NSString stringWithFormat:@"%@:%@\n\tNSObject class %s\n\tRuntime class %s\n\ttimplements methods <%@>\n\n",name,obj,class_getName([obj class]),class_getName(object_getClass(obj)),[ClassMethodNames(object_getClass(obj)) componentsJoinedByString:@","]];
    printf("%s\n",[str UTF8String]);
}

#pragma mark - Helpers
static NSString * getterForSetter(NSString *setter){
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    //remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *key = [setter substringWithRange:range];
    
    //lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    return key;
}

static NSString * setterForGetter(NSString *getter){
    if (getter.length <=0) {
        return nil;
    }
    //uper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    //add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:",firstLetter,remainingLetters];
    return setter;
}

#pragma mark - Overridden Method
static void kvo_setter(id self, SEL _cmd, id newValue){
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ dees not have setter %@",self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    // cast our pointer so the compiler won't complain
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // call super's setter, which is original class's setter method
    objc_msgSendSuperCasted(&superclazz, _cmd, newValue);
    
    // look up observers and call the blocks
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(KLYBKVOAssociatedObservers));
    for (LYBObservationInfo *each in observers) {
        if ([each.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                each.block(self, getterName, oldValue, newValue);
            });
        }
    }
}

static Class kvo_class(id self, SEL _cmd){
    return class_getSuperclass(object_getClass(self));
}


@end


@implementation NSObject (LYBKVO)

- (void)LYB_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(LYBObservingBlock)block{
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterSelector) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@",self,key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        return;
    }
    
    Class clazz = object_getClass(self);
    NSString *className = NSStringFromClass(clazz);
    
    //if not an KVO class yet
    if (![className hasPrefix:KLYBKVOClassPrefix]) {
        clazz = [self makeKvoClassWithOriginalClassName:className];
        object_setClass(self, clazz);
    }
    
    // add our kvo setter if this class (not superclasses) does't implement the setter?
    if (![self hasSelecter:setterSelector]) {
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
    }
    
    LYBObservationInfo *info = [[LYBObservationInfo alloc]initWithObserver:self Key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(KLYBKVOAssociatedObservers));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(KLYBKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:info];
}

- (void)LYB_removeObserver:(NSObject *)observer forKey:(NSString *)key{
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(KLYBKVOAssociatedObservers));
    LYBObservationInfo *infoToRemove;
    for (LYBObservationInfo *info in observers) {
        if (info.observer==observer && [info.key isEqualToString:key]) {
            infoToRemove = info;
            break;
        }
    }
    [observers removeObject:infoToRemove];
}

- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClassName{
    NSString *kvoClazzName = [KLYBKVOClassPrefix stringByAppendingString:originalClassName];
    Class clazz = NSClassFromString(kvoClazzName);
    if (clazz) {
        return clazz;
    }
    
    // class does't exist yet,make it
    Class originalClazz = object_getClass(self);
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);
    
    // grab class method's signature so we can borrow it
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);
    
    objc_registerClassPair(kvoClazz);
    return kvoClazz;
}

- (BOOL)hasSelecter:(SEL)selector{
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(clazz, &methodCount);
    for (int i = 0; i<methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    
    free(methodList);
    return NO;
}




@end
