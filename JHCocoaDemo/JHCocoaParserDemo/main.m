//
//  main.m
//  JHCocoaParserDemo
//
//  Created by Fanty on 15/1/21.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JHCocoaParser.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString* path=@"/Users/fanty/Documents/project/自己的项目/JHCocoaDemo/JHCocoaCreateDemo/JHCocoa_resource/";
        

        NSArray* testClassModelArray=[JHCocoaParser parserTestArrayClassModelArray:[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"array_class.json"]]];
        

        NSArray* array_stringAndNumberAndClassArray=[JHCocoaParser parserTestArray_stringAndNumberAndClassModelArray:[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"array_stringAndNumberAndClass.json"]]];

        TestClassWithClassModel* classWithClassModel=[JHCocoaParser parserTestClassWithClassModel:[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"classWithClass.json"]]];

        TestClassModel* testClassModel=[JHCocoaParser parserTestClassModel:[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"only_class.json"]]];

        
        
        
        TestHttpModel* testHttpModel=[JHCocoaParser parserTestHttpModel:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://115.28.1.119:18860/mam/api/mam/clients/update/ios/com.foreveross.bsl2/?ts=415173565.859007&appKey=9ac10bdf29e6cf120294703c95a60878"]]];
        
        NSLog(@"testClassModelArray:%@",testClassModelArray);
        NSLog(@"array_stringAndNumberAndClassArray:%@",array_stringAndNumberAndClassArray);
        NSLog(@"classWithClassModel:%@",classWithClassModel);
        NSLog(@"testClassModel:%@",testClassModel);
        NSLog(@"testHttpModel:%@",testHttpModel);
        
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}
