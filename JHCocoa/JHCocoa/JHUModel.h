//
//  JHUModel.h
//  JHCocoa
//
//  Created by Fanty on 15/1/13.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

//json文件 解析对象
@interface JHUModel : NSObject

//要调用的映射url
@property(nonatomic,strong) NSString* map_url;

//要调用的映射所生成出来的映射名称，如果不传，将采用默认名称
@property(nonatomic,strong) NSString* moduleName;

//调用的获取的方法
@property(nonatomic,strong) NSString* method;

//判断json 根是否为数组
@property(nonatomic,assign) BOOL isRootArray;

//request header
@property(nonatomic,strong) NSDictionary* requestHeader;

//request post 参数
@property(nonatomic,strong) NSDictionary* postData;


@end
