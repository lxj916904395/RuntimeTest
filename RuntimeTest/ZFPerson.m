//
//  ZFPerson.m
//  RuntimeTest
//
//  Created by zhongding on 2018/9/11.
//

#import "ZFPerson.h"

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

@end
