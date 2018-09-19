//
//  ZFPerson.m
//  RuntimeTest
//
//  Created by zhongding on 2018/9/11.
//

#import "ZFPerson.h"
#import "ZFDog.h"

#import <objc/runtime.h>
@implementation ZFPerson

- (void)encodeWithCoder:(NSCoder *)aCoder{
    //存储成员变量个数
    unsigned int count = 0;
    //获取成员变量
    Ivar *vars = class_copyIvarList([self class], &count);
    
    //遍历成员变量
    for (int i = 0; i < count; i++) {
        Ivar ivar = vars[i];
        //变量名
        const char *name = ivar_getName(ivar);
        //变量名转成utf-8
        NSString *key = [NSString stringWithUTF8String:name];
        //获取value
        id value = [self valueForKey:key];
        
        [aCoder encodeObject:value forKey:key];
    }
    //释放
    free(vars);
}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        //存储成员变量个数
        unsigned int count = 0;
        //获取成员变量
        Ivar *vars = class_copyIvarList([self class], &count);
        
        //遍历成员变量
        for (int i = 0; i < count; i++) {
            Ivar ivar = vars[i];
            //变量名
            const char *name = ivar_getName(ivar);
            //变量名转成utf-8
            NSString *key = [NSString stringWithUTF8String:name];
            //获取value
            id value = [aDecoder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
        }
        //释放
        free(vars);
    }
    return self;
}


#pragma mark ***************** 动态方法解析;
//
//void walk(){
//    NSLog(@"%s",__func__);
//}
//
////动态方法解析
//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    //方法未实现
////    if (sel == @selector(walk)) {
////        //返回c方法实现
////        return class_addMethod(self, sel, (IMP)walk, "v@:");
////    }
//
//
//    //方法未实现
//    if (sel == @selector(walk)) {
//        //获取方法
//        Method method = class_getInstanceMethod(self, @selector(run));
//        //获取方法的实现
//        IMP methodIMP = method_getImplementation(method);
//        //修改方法的实现
//         return class_addMethod(self, sel, methodIMP, "v@:");
//    }
//    return [super resolveInstanceMethod:sel];
//}
//
//- (void)run{
//    NSLog(@"%s",__func__);
//}
//
////类方法动态解析
//+ (BOOL)resolveClassMethod:(SEL)sel{
//    //jump方法未实现
//    if (sel == @selector(jump)) {
//
//        //获取类方法
//        Method method = class_getClassMethod(self, @selector(talk));
//        //方法实现
//        IMP methodIMP = method_getImplementation(method);
//        //替换方法的实现
//        return class_addMethod(object_getClass(self), sel, methodIMP, "v@:");
//    }
//
//    return [super resolveClassMethod:sel];
//}
//
//+ (void)talk{
//    NSLog(@"%s",__func__);
//}

#pragma mark ***************** 快速转发;

//- (id)forwardingTargetForSelector:(SEL)aSelector{
//    //把消息转发给ZFDog处理
//    if(aSelector == @selector(run)){
//        return [ZFDog new];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

#pragma mark ***************** 方法签名;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    //对run方法签名
    if(aSelector == @selector(run)){
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //把消息转发给ZFDog处理
//    [anInvocation invokeWithTarget:[ZFDog new]];
    
    //转发自己处理
    anInvocation.selector = @selector(jump);
    [anInvocation invoke];
    
}

- (void)jump{
    NSLog(@"%s",__func__);
}

@end
