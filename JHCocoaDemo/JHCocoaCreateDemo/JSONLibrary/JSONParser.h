//
//  JsonParser.h
//
//
//  Created by fanty on 13-4-28.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JSONParser: NSObject{
    id result;

}

//输出结果
@property(nonatomic,readonly) id result;

//要序列成的模块类名
@property(nonatomic,strong) NSString* serialModelName;

//
@property(nonatomic,strong) NSArray* serialSubModuleName;

-(void)parse:(NSData*)data;

@end
