//
//  JHClassWriter.h
//  JHCocoa
//
//  Created by Fanty on 15/1/14.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  JHUModel;

//把json 解析成class 的类字典
@interface JHClassParser : NSObject{
    NSMutableArray* subClassCache;
    NSString* moduleName;
    int moduleCreateIndex;
}

//输出生成的类结构字典
@property(nonatomic,readonly) NSArray* subClassCache;

//把json 解析成class
-(void)parserModel:(JHUModel*)model withData:(id)jsonMap;


@end
