//
//  JHUClassModel.h
//  JHCocoa
//
//  Created by Fanty on 15/1/14.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    JHUClassModelString,
    JHUClassModelDouble,
    JHUClassModelLongLong,
}JHUClassModelType;

//一个json 的根类解析模型
@interface JHUClassModel : NSObject{
    //类的属性集
    NSMutableDictionary* properties;
    
    //类的数组集
    NSMutableArray* subClassArray;
}

//属性集
@property(nonatomic,readonly) NSDictionary* properties;

//类的名称
@property(nonatomic,strong) NSString* className;

//添加字符串
-(void)addKey:(NSString*)key type:(JHUClassModelType)type;

//添加类
-(void)addKey:(NSString*)key class:(NSString*)className;

//改变所有属性中的类名
-(void)changeClassName:(NSString*)className newClassName:(NSString*)newClassName;

@end
