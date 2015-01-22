//
//  JsonParser.h
//
//
//  Created by fanty on 13-4-28.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <Foundation/Foundation.h>
//把json data 转化成model 类的解析库
@interface JSONParser: NSObject{
    id result;

}

//输出结果
@property(nonatomic,readonly) id result;

//要序列成的模块类名
@property(nonatomic,strong) NSString* serialModelName;

//要要
@property(nonatomic,strong) NSArray* serialSubModuleName;


//解析字节流
-(void)parse:(NSData*)data;

@end
