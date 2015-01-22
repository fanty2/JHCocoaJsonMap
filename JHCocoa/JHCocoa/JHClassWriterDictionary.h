//
//  JHClassWriterDictionary.h
//  JHCocoa
//
//  Created by Fanty on 15/1/15.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JHUClassModel;

//记录json 中每一个类的模型的字典
@interface JHClassWriterDictionary : NSObject

//该json 中的关键字
@property(nonatomic,strong) NSString* key;

//该json 中的关键字的模型
@property(nonatomic,strong) JHUClassModel*  classModel;

//该json 的关键字的层级
@property(nonatomic,assign) int level;

@end
