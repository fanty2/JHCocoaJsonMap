//
//  JHClassWriter.m
//  JHCocoa
//
//  Created by Fanty on 15/1/15.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import "JHClassWriter.h"

#import "JHClassWriterDictionary.h"
#import "JHUClassModel.h"

@implementation JHClassWriter

-(void)writeClassDictionary:(NSArray*)array moduleName:(NSString*)moduleName inPath:(NSString*)inPath{
    NSMutableString* content=[[NSMutableString alloc] initWithString:@"#import <Foundation/Foundation.h>\n\n\n\n\n\n"];
    
    NSMutableArray* writeExistClass=[[NSMutableArray alloc] initWithCapacity:2];
    
    for(JHClassWriterDictionary* dictionary in array){
        if(![writeExistClass containsObject:dictionary.classModel.className]){
            [writeExistClass addObject:dictionary.classModel.className];
            [content appendFormat:@"@class %@;\n",dictionary.classModel.className];
        }
    }
    
    [content appendString:@"\n\n"];
    
    [writeExistClass removeAllObjects];
    
    for(JHClassWriterDictionary* dictionary in array){
        JHUClassModel* classModel=dictionary.classModel;
        if(![writeExistClass containsObject:classModel.className]){
            [writeExistClass addObject:dictionary.classModel.className];
            [content appendFormat:@"@interface %@ : NSObject\n\n\n",classModel.className];
            [classModel.properties enumerateKeysAndObjectsUsingBlock:^(id key,id object,BOOL*stop){
                [content appendFormat:@"%@ %@;\n\n",object,key];
            }];
            [content appendString:@"\n\n@end\n\n"];

        }

    }

    
    NSString* headerFile=[inPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",moduleName]];
    
    [content writeToFile:headerFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSRange range;
    range.location=0;
    range.length=[content length];
    [content deleteCharactersInRange:range];
    
    [content appendFormat:@"#import \"%@.h\"\n\n\n\n\n\n",moduleName];
    
    [writeExistClass removeAllObjects];

    for(JHClassWriterDictionary* dictionary in array){
        JHUClassModel* classModel=dictionary.classModel;
        if(![writeExistClass containsObject:classModel.className]){
            [writeExistClass addObject:dictionary.classModel.className];
            [content appendFormat:@"@implementation %@;\n",dictionary.classModel.className];
            [content appendString:@"\n\n@end\n\n"];
            
        }
    }

    NSString* sourceFile=[inPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",moduleName]];

    [content writeToFile:sourceFile atomically:YES encoding:NSUTF8StringEncoding error:nil];

}


@end
