//
//  JHUpdate.h
//  JHCocoa
//
//  Created by Fanty on 15/1/13.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

//json 更新库
@interface JHUpdate : NSObject{
    
    //所有的配置路径存放
    NSMutableArray* urls;
    
    //是否使用asihttprequest， 暂没用
    BOOL isAsiHttpRequest;
    
    //选择要生成的路径
    NSString* rootPath;
}

//解析路径
-(BOOL)parserPath:(NSString*)path;

@end
