//
//  JHParserWriter.m
//  JHCocoa
//
//  Created by Fanty on 15/1/22.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import "JHParserWriter.h"
#import "JHUModel.h"

@implementation JHParserWriter

-(void)writeJHUModelArray:(NSArray*)array inPath:(NSString*)path{
    NSString* header=[path stringByAppendingPathComponent:@"JHCocoaParser.h"];
    
    NSMutableString* content=[[NSMutableString alloc] initWithString:@"#import <Foundation/Foundation.h>\n\n\n\n\n\n"];
    
    for(JHUModel* model in array){
        [content appendFormat:@"@class %@;\n",model.moduleName];
    }
    [content appendString:@"\n"];
    
    [content appendString:@"@interface JHCocoaParser : NSObject\n\n"];

    
    for(JHUModel* model in array){
        [content appendFormat:@"+(%@*)parser%@:(NSData*)data;\n\n",(model.isRootArray?@"NSArray":model.moduleName),[NSString stringWithFormat:@"%@%@",model.moduleName,(model.isRootArray?@"Array":@"")]];
    }
    
    [content appendString:@"@end\n\n"];

    
    
    [content writeToFile:header atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    NSString* source=[path stringByAppendingPathComponent:@"JHCocoaParser.m"];

    NSRange range;
    range.location=0;
    range.length=[content length];
    [content deleteCharactersInRange:range];

    [content appendString:@"#import \"JHCocoaParser.h\"\n\n"];
    [content appendString:@"#import \"JSONParser.h\"\n\n"];
    [content appendString:@"@implementation JHCocoaParser\n\n"];

    for(JHUModel* model in array){
        [content appendFormat:@"+(%@*)parser%@:(NSData*)data{\n\n",(model.isRootArray?@"NSArray":model.moduleName),[NSString stringWithFormat:@"%@%@",model.moduleName,(model.isRootArray?@"Array":@"")]];
        
        [content appendString:@"    JSONParser* parser=[[JSONParser alloc] init];\n"];
        [content appendFormat:@"    parser.serialModelName=@\"%@\";\n",model.moduleName];
        [content appendString:@"    [parser parse:data];\n"];
        [content appendString:@"    return parser.result;\n"];
        [content appendString:@"}\n\n"];

    }
    [content appendString:@"@end\n\n"];

    [content writeToFile:source atomically:YES encoding:NSUTF8StringEncoding error:nil];

}


@end
