//
//  JHParserWriter.h
//  JHCocoa
//
//  Created by Fanty on 15/1/22.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

//解析器写入类
@interface JHParserWriter : NSObject

//把所有的模型块写入，生成一个JHCocoaParser的类，作为json 解析的集合
-(void)writeJHUModelArray:(NSArray*)array inPath:(NSString*)path;

@end
