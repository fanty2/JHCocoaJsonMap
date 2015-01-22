//
//  JHClassWriter.h
//  JHCocoa
//
//  Created by Fanty on 15/1/15.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

//类写入文件的类
@interface JHClassWriter : NSObject

//把解析出来的资源生成.h  .m 文件
-(void)writeClassDictionary:(NSArray*)array moduleName:(NSString*)moduleName inPath:(NSString*)inPath;

@end
