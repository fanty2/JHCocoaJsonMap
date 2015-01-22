//
//  main.m
//  JHCocoa
//
//  Created by Fanty on 15/1/13.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JHUpdate.h"

#include <stdlib.h>
#include <stdio.h>



int main(int argc, const char * argv[]) {
    
    BOOL ret=YES;
    //init              安装
    //update            更新
    //version           版本
//#ifdef DEBUG
//    if(argc>=0){
//#else
    if(argc>1){
//#endif
        char* buffer=(char*)malloc(sizeof(char)*512);
        memset(buffer,0,512);
        getcwd(buffer, 256);
        
        //当前文件的目录
        NSString* path=[[NSString stringWithUTF8String:buffer] stringByAppendingPathComponent:@"JHCocoa.json"];
        free(buffer);
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
            path=[NSString stringWithUTF8String:argv[0]];
            path=[[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"JHCocoa.json"];
        }
        const char* sv=argv[1];
        
//#ifdef DEBUG
//        path=@"/Users/fanty/Documents/partime/自己的项目/JHCocoa/resource/JHCocoa.json";
//        sv="-update";
//#endif

        if(strcmp(sv, "-update")==0){
            NSLog(@"in update");
            JHUpdate* update=[[JHUpdate alloc] init];
            [update parserPath:path];
        }
        else if(strcmp(sv, "-init")==0){
            
        }
        else if(strcmp(sv, "-version")==0){
            NSLog(@"JHCocoa version:v1.0.0");
        }
        else{
            ret=NO;
        }
    }
    else{
        ret=NO;
    }
    if(!ret){
        NSLog(@"Please use arg");
    }
    return 0;
}
