//
//  JHUpdate.m
//  JHCocoa
//
//  Created by Fanty on 15/1/13.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import "JHUpdate.h"


//  http server

//   http  server   ->  json

//  client   -> json           dictonary     model

//   model          .h  .m

#import "JHUModel.h"
#import "ChamleonFormDataRequest.h"

#import "JHClassParser.h"

#import "JHClassWriter.h"

@interface JHUpdate()

//解析json 并生成文件
-(BOOL)parserModel:(JHUModel*)model withData:(NSData*)data isRootArray:(BOOL*)isRootArray;

@end

@implementation JHUpdate

-(id)init{
    self=[super init];
    if(self){
        urls=[[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

-(BOOL)parserPath:(NSString*)file{
    [urls removeAllObjects];
    
    rootPath=[file stringByDeletingLastPathComponent];
    NSString* path=rootPath;

    @autoreleasepool {
        

        NSError* error = nil;
        NSData* data=[[NSData alloc] initWithContentsOfFile:file];
        NSDictionary* object = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:&error];
        
        if (error != nil) {
            NSLog(@"path:%@ json parseer error: %@",file, [error localizedDescription]);
            return NO;
        }
        
        isAsiHttpRequest=[[object objectForKey:@"ASIHTTPRequest"] boolValue];
        
        NSArray* array=[object objectForKey:@"url_map_model"];
        if(![array isKindOfClass:[NSArray class]]){
            NSLog(@"url_map_model %@ is not array json!",file);
            return NO;
        }
        
        int moduleNameIndex=0;
        for(NSDictionary* dict in array){
            JHUModel* model =[[JHUModel alloc] init];
            model.map_url=[dict objectForKey:@"map_url"];
            model.moduleName=[dict objectForKey:@"moduleName"];
            if([model.moduleName length]<1){
                model.moduleName=[NSString stringWithFormat:@"JHModel_%d",moduleNameIndex];
            }
            model.method=[dict objectForKey:@"method"];
            if([model.method length]<1){
                model.method=@"get";
            }
            [urls addObject:model];
            moduleNameIndex++;
        }
    }
    
    
    for(JHUModel* model in urls){
        @autoreleasepool {
            BOOL isRootArray=NO;
            if([model.map_url length]>0){
                if([model.map_url rangeOfString:@"://"].length>0){
                    ChamleonFormDataRequest* request=nil;
                    if([[model.method uppercaseString] isEqualToString:@"POST"]){
                        request=[ChamleonFormDataRequest requestWithURL:[NSURL URLWithString:model.map_url]];
                    }
                    else{
                        request=[ChamleonHTTPRequest requestWithURL:[NSURL URLWithString:model.map_url]];
                    }
                    [request startSynchronous];
                    
                    
                    if(![self parserModel:model withData:[request responseData] isRootArray:&isRootArray]){
                        NSLog(@"map_url %@ json parser error!",model.map_url);
                        return NO;
                    }
                    
                }
                else{
                    NSData* data=[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:model.map_url]];
                    if(![self parserModel:model withData:data isRootArray:&isRootArray]){
                        NSLog(@"map_url %@ json parser error!",model.map_url);
                        return NO;
                    }
                }
                model.isRootArray=isRootArray;
            }
            else{
                NSLog(@"url_map_model any object  map_url is empty!");
            }
        }
    }
    
    path=[rootPath stringByAppendingPathComponent:@"parser"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSLog(@"write root:%@",path);
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"create models  success!");
    return YES;
}

-(BOOL)parserModel:(JHUModel*)model withData:(NSData*)data  isRootArray:(BOOL*)isRootArray{
    NSError* error=nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    if(error!=nil){
        NSLog(@"jaon error:%@",error);
        return NO;
    }
    
    *isRootArray=[object isKindOfClass:[NSArray class]];
    
    JHClassParser* classParser=[[JHClassParser alloc] init];
    [classParser parserModel:model withData:object];
    
    JHClassWriter* classWriter=[[JHClassWriter alloc] init];
    
    NSString* path=[rootPath stringByAppendingPathComponent:@"model"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [classWriter writeClassDictionary:classParser.subClassCache moduleName:model.moduleName inPath:path];
    
    return YES;
}


@end
