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
            [content appendFormat:@"@interface %@ : NSObject<NSCoding,NSCopying>\n\n\n",classModel.className];
            [classModel.properties enumerateKeysAndObjectsUsingBlock:^(id key,id object,BOOL*stop){
                [content appendFormat:@"%@ %@;\n\n",object,key];
            }];
            if([classModel.className isEqualToString:moduleName])
                [content appendString:@"+(id)parser:(NSData*)data;\n\n"];

            [content appendString:@"\n\n@end\n\n"];

        }

    }

    
    NSString* headerFile=[inPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",moduleName]];
    
    [content writeToFile:headerFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSRange range;
    range.location=0;
    range.length=[content length];
    [content deleteCharactersInRange:range];
    
    [content appendFormat:@"#import \"%@.h\"\n",moduleName];
    [content appendString:@"#import \"JSONParser.h\"\n\n\n\n\n\n"];

    
    [writeExistClass removeAllObjects];

    for(JHClassWriterDictionary* dictionary in array){
        JHUClassModel* classModel=dictionary.classModel;
        if(![writeExistClass containsObject:classModel.className]){
            [writeExistClass addObject:dictionary.classModel.className];
            [content appendFormat:@"@implementation %@;\n\n",dictionary.classModel.className];
            
            [content appendString:@"- (void)encodeWithCoder:(NSCoder *)aCoder{\n\n"];
            
            [classModel.properties enumerateKeysAndObjectsUsingBlock:^(id key,id object,BOOL*stop){
                if([object rangeOfString:@"(nonatomic,copy)"].length>0)
                    [content appendFormat:@"    if(self.%@!=nil) [aCoder encodeObject:self.%@ forKey:@\"%@\"];\n",key,key,key];
                else if([object rangeOfString:@"(nonatomic,assign) double"].length>0)
                    [content appendFormat:@"    [aCoder encodeDouble:self.%@ forKey:@\"%@\"];\n",key,key];
                else
                    [content appendFormat:@"    [aCoder encodeInt64:self.%@ forKey:@\"%@\"];\n",key,key];
            }];
            [content appendString:@"}\n\n"];

            [content appendString:@"- (id)initWithCoder:(NSCoder *)aDecoder{\n\n"];
            [content appendString:@"    self=[self init];\n"];
            [content appendString:@"    if(self){\n"];
            
            [classModel.properties enumerateKeysAndObjectsUsingBlock:^(id key,id object,BOOL*stop){
                if([object rangeOfString:@"(nonatomic,copy)"].length>0)
                    [content appendFormat:@"        self.%@=[aDecoder decodeObjectForKey:@\"%@\"];\n",key,key];
                else if([object rangeOfString:@"(nonatomic,assign) double"].length>0)
                    [content appendFormat:@"        self.%@=[aDecoder decodeDoubleForKey:@\"%@\"];\n",key,key];
                else
                    [content appendFormat:@"        self.%@=[aDecoder decodeInt64ForKey:@\"%@\"];\n",key,key];
            }];
            [content appendString:@"    }\n"];
            [content appendString:@"    return self;\n"];


            [content appendString:@"}\n\n"];

            [content appendString:@"- (id)copyWithZone:(NSZone *)zone{\n\n"];
            [content appendFormat:@"    %@ *copy = [[[self class] allocWithZone:zone] init];\n",classModel.className];
            [content appendString:@"    if (copy != nil) {\n"];
            [classModel.properties enumerateKeysAndObjectsUsingBlock:^(id key,id object,BOOL*stop){
                [content appendFormat:@"        copy.%@ = self.%@;\n",key,key];
            }];
            [content appendString:@"    }\n"];

            [content appendString:@"    return copy;\n"];
            [content appendString:@"}\n\n"];

            if([classModel.className isEqualToString:moduleName]){
                [content appendString:@"+(id)parser:(NSData*)data{\n\n"];
                
                [content appendString:@"    JSONParser* parser=[[JSONParser alloc] init];\n"];
                [content appendFormat:@"    parser.serialModelName=@\"%@\";\n",moduleName];
                [content appendString:@"    [parser parse:data];\n"];
                [content appendString:@"    return parser.result;\n"];
                [content appendString:@"}\n\n"];
                
            }
            
            
            [content appendString:@"\n\n@end\n\n"];
            
        }
    }

    NSString* sourceFile=[inPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",moduleName]];

    [content writeToFile:sourceFile atomically:YES encoding:NSUTF8StringEncoding error:nil];

}


@end
