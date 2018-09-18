//
//  ZFPerson.h
//  RuntimeTest
//
//  Created by zhongding on 2018/9/11.
//

#import <Foundation/Foundation.h>

@interface ZFPerson : NSObject<NSCoding>

@property(strong ,nonatomic) NSString *name;
@property(assign ,nonatomic) int age;

- (void)run;
- (void)walk;

+ (void)jump;

@end
