//
//  ViewController.m
//  RuntimeTest
//
//  Created by zhongding on 2018/9/11.
//

#import "ViewController.h"

#import <objc/runtime.h>
#import "ZFPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self createClass];
    [self runtimeTest];
}

- (void)runtimeTest{
    ZFPerson *p = [ZFPerson new];
    [p run];
    
//    [ZFPerson jump];
}

- (void)archive{
    ZFPerson *p = [ZFPerson new];
    p.name = @"Cat";
    p.age = 18;
    
    //归档路径
    NSString *path = [NSString stringWithFormat:@"%@/archiver.plist",NSHomeDirectory()];
    
    //归档
    [NSKeyedArchiver archiveRootObject:p toFile:path];
    
    //归档
    ZFPerson *p2 = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSLog(@"name=%@,age=%d",p2.name,p2.age);
}

//动态创建类
- (void)createClass{
    //创建类对
    Class ZFCat =  objc_allocateClassPair([NSObject class],"ZFCat", 0);
    
    //添加属性
    NSString *name = @"name";
    
    //添加属性
    class_addIvar(ZFCat, name.UTF8String, sizeof(id), log2(sizeof(id)), @encode(id));
    
    //添加方法
    class_addMethod(ZFCat, @selector(jump), (IMP)jump, "v@:");
    
    //注册类
    objc_registerClassPair(ZFCat);
    
    id cat = [ZFCat new];
    [cat setValue:@"zf" forKey:name];
    
    NSLog(@"name=%@",[cat valueForKey:name]);
    [cat performSelector:@selector(jump)];
 
}

void jump(){
    NSLog(@"猫跳");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}













@end
