//
//  JHClassWriter.m
//  JHCocoa
//
//  Created by Fanty on 15/1/14.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import "JHClassParser.h"
#import "JHUModel.h"
#import "JHUClassModel.h"
#import "JHClassWriterDictionary.h"

@interface JHClassParser()

//解析子字典
-(void)parserSubCalss:(JHUClassModel*)subClassModel dict:(NSDictionary*) dict level:(int)level;

//解析子数组
-(void)parserSubArray:(NSArray*)array level:(int)level;

//把一些相同的结构整合在一起
-(void)combineTheSameDictonary;

@end

@implementation JHClassParser

@synthesize subClassCache;

-(id)init{
    self=[super init];
    if(self){
        subClassCache=[[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

-(void)parserModel:(JHUModel*)model withData:(id)jsonMap{
    moduleName=model.moduleName;
    if([jsonMap isKindOfClass:[NSDictionary class]]){
        moduleCreateIndex=0;

        JHUClassModel* classModel=[[JHUClassModel alloc] init];
        //设置类的名称
        classModel.className=moduleName;

        [self parserSubCalss:classModel dict:jsonMap level:1];

        JHClassWriterDictionary* dictonary=[[JHClassWriterDictionary alloc] init];
        dictonary.key=classModel.className;
        dictonary.classModel=classModel;
        dictonary.level=0;
        [subClassCache addObject:dictonary];
    }
    else if([jsonMap isKindOfClass:[NSArray class]]){
        moduleCreateIndex=-1;
        [self parserSubArray:jsonMap level:1];
    }
    
    NSArray* array = [subClassCache sortedArrayUsingComparator:^NSComparisonResult(JHClassWriterDictionary *p1, JHClassWriterDictionary *p2){
        return (p1.level<p2.level);
    }];
    if([array count]>0){
        [subClassCache removeAllObjects];
        [subClassCache addObjectsFromArray:array];
        [self combineTheSameDictonary];
    }

}

-(void)parserSubArray:(NSArray*)array level:(int)level{
    for(id obj in array){
        if([obj isKindOfClass:[NSDictionary class]]){
            JHUClassModel* subClassModel=[[JHUClassModel alloc] init];
            [self parserSubCalss:subClassModel dict:obj level:(level+1)];
            

            if(moduleCreateIndex==-1)
                subClassModel.className=moduleName;
            else
                subClassModel.className=[NSString stringWithFormat:@"%@_%d",moduleName,moduleCreateIndex];
            moduleCreateIndex++;
            
            JHClassWriterDictionary* dictonary=[[JHClassWriterDictionary alloc] init];
            dictonary.key=@"";
            dictonary.classModel=subClassModel;
            dictonary.level=level;
            [subClassCache addObject:dictonary];
        }
        else if([obj isKindOfClass:[NSArray class]]){
            [self parserSubArray:obj level:(level+1)];
        }
    }
}

-(void)parserSubCalss:(JHUClassModel*)classModel dict:(NSDictionary*) dict level:(int)level{
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString* key,id obj,BOOL*stop){
        if([obj isKindOfClass:[NSDictionary class]]){
            JHUClassModel* subClassModel=[[JHUClassModel alloc] init];
            [self parserSubCalss:subClassModel dict:obj level:(level+1)];
            
            subClassModel.className=[NSString stringWithFormat:@"%@_%d",moduleName,moduleCreateIndex];
            moduleCreateIndex++;

            [classModel addKey:key class:subClassModel.className];
            JHClassWriterDictionary* dictonary=[[JHClassWriterDictionary alloc] init];
            dictonary.key=key;
            dictonary.classModel=subClassModel;
            dictonary.level=level;
            [subClassCache addObject:dictonary];
        }
        else if([obj isKindOfClass:[NSArray class]]){
            [self parserSubArray:obj level:(level+1)];
            //枚举
            [classModel addKey:key class:@"NSArray"];
        }
        else if([obj isKindOfClass:[NSString class]]){
            [classModel addKey:key type:JHUClassModelString];
        }
        else if([obj isKindOfClass:[NSNumber class]]){
            NSString* format=[NSString stringWithFormat:@"%@",obj];
            const char* objCType=[obj objCType];

            if([format rangeOfString:@"."].length>0){
                if (strcmp(objCType, @encode(double)) == 0){
                    [classModel addKey:key type:JHUClassModelDouble];
                }
                
            }
            else{
                [classModel addKey:key type:JHUClassModelLongLong];
            }
        }
    }];
}

-(void)combineTheSameDictonary{
    NSUInteger count=[subClassCache count];
    for(NSUInteger i=0;i<count-1;i++){
        JHClassWriterDictionary* dict1=[subClassCache objectAtIndex:i];
        for(NSUInteger j=i+1;j<count;j++){
            JHClassWriterDictionary* dict2=[subClassCache objectAtIndex:j];
            if(![dict1.classModel.className isEqualToString:dict2.classModel.className] && [dict1.classModel isEqual:dict2.classModel]){

                NSString* tmpClassName=dict2.classModel.className;
                
                NSString* newClassName=dict1.classModel.className;

                dict2.classModel.className=newClassName;
                
                for(NSUInteger t=j;t<count;t++){
                    JHClassWriterDictionary* dict3=[subClassCache objectAtIndex:t];
                    [dict3.classModel changeClassName:tmpClassName newClassName:newClassName];

                }

            }
        }

    }
}




@end
