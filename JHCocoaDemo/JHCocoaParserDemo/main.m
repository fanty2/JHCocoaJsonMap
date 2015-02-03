//
//  main.m
//  JHCocoaParserDemo
//
//  Created by Fanty on 15/1/21.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestClassModel.h"

#import "TestClassWithClassModel.h"

#import "TestArray_stringAndNumberAndClassModel.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString* path=@"/Users/fanty/Documents/project/自己的项目/JHCocoaDemo/JHCocoaCreateDemo/JHCocoa_resource/";
        

        
        NSArray* array1=[TestArray_stringAndNumberAndClassModel parser:[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"array_stringAndNumberAndClass.json"]]];

        
        
        TestClassWithClassModel* classWithClassModel=[TestClassWithClassModel parser:[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"classWithClass.json"]]];

        TestClassModel* testClassModel=[TestClassModel parser:[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"only_class.json"]]];

        
        NSLog(@"classWithClassModel:%@",classWithClassModel);
        NSLog(@"testClassModel:%@",testClassModel);
        NSLog(@"array:%@",array1);
        
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}
