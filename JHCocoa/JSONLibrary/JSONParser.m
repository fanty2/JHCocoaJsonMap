//
//  JsonParser.m
//
//
//  Created by fanty on 13-4-28.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "JSONParser.h"
#import <objc/runtime.h>

//集合
@interface SerialSubModelClassInfo : NSObject

//属性名
@property(nonatomic,strong) NSString* propertyName;

//属性类型
@property(nonatomic,strong) NSString* propertyType;

@end

@interface JSONParser()

//加载所有与模块类有关的类名
-(void)loadAllModelInfo;

//获取某一类的属性集
-(NSArray *)propertyFromClass:(Class)class;

//解析字典
-(void)parserDictonary:(NSDictionary*)dictonary serialInObject:(id)serialObject withObjectProperties:(NSArray*)properties;

//解析数组
-(void)parserArray:(NSArray*)dictArray serialInArray:(NSMutableArray*)serialInArray;

//找出与字典相似度高的类名
-(NSString*)classTypeForDictonary:(NSDictionary*)dict;

//检测与字典相似的属性的数量
-(int)checkDict:(NSDictionary*)dict withProperties:(NSArray*)properties;

@end


@implementation SerialSubModelClassInfo

@end

@implementation JSONParser

@synthesize result;

-(id)init{
    self=[super init];
    if(self){
    }
    return self;
}

-(void)loadAllModelInfo{
    if([self.serialSubModuleName count]>0)return;
    
    int i=0;
    NSMutableArray* array=[[NSMutableArray alloc] initWithCapacity:2];
    
    [array addObject:self.serialModelName];
    
    while(YES){
        NSString* className=[NSString stringWithFormat:@"%@_%d",self.serialModelName,i];
        Class cls=NSClassFromString(className);
        if(cls==nil)break;
        i++;
        [array addObject:className];
    }
    self.serialSubModuleName=array;
}

-(void)parse:(NSData*)data{
    result=nil;
    if([data length]>2){

        NSError* error=nil;
        id jsonMap = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
        if(error!=nil || jsonMap==nil){
            return;
        }
        if(self.serialModelName!=nil){
            Class class=NSClassFromString(self.serialModelName);
            result=[[class alloc] init];
            if(result!=nil){
                [self loadAllModelInfo];

                
                NSArray* properties=[self propertyFromClass:NSClassFromString(self.serialModelName)];
                
                if([jsonMap isKindOfClass:[NSDictionary class]]){
                    [self parserDictonary:jsonMap serialInObject:result withObjectProperties:properties];
                }
                else if([jsonMap isKindOfClass:[NSArray class]]){
                    result=[[NSMutableArray alloc] initWithCapacity:2];
                    [self parserArray:jsonMap serialInArray:result];
                }
            
            }
            else{
                NSLog(@"serialModel class not init:%@",self.serialModelName);
            }
        }
        else{
            result=jsonMap;
        }
    }
}

-(void)parserDictonary:(NSDictionary*)dictonary serialInObject:(id)serialObject withObjectProperties:(NSArray*)properties{
    [dictonary enumerateKeysAndObjectsUsingBlock:^(NSString* key,id value,BOOL*stop){
        NSString* propertyType=[self propertyTypeForPropertyName:key withObjectProperties:properties];
        if(propertyType!=nil){
            
            if([value isKindOfClass:[NSDictionary class]]){
                Class cls=NSClassFromString(propertyType);
                if(cls!=nil){
                    id newClass=[[cls alloc] init];
                    NSArray* __properties=[self propertyFromClass:cls];
                    [self parserDictonary:value serialInObject:newClass withObjectProperties:__properties];
                    [serialObject setValue:newClass forKey:key];
                }
            }
            else if([value isKindOfClass:[NSArray class]]){
                if([propertyType isEqualToString:@"NSArray"]){
                    NSMutableArray* list=[[NSMutableArray alloc] initWithCapacity:2];
                    [self parserArray:value serialInArray:list];
                    [serialObject setValue:list forKey:key];
                }
            }
            else if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]){
                [serialObject setValue:value forKey:key];
            }
        }
    }];
}

-(void)parserArray:(NSArray*)dictArray serialInArray:(NSMutableArray*)serialInArray{
    for(id obj in dictArray){
        if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]){
            [serialInArray addObject:obj];
        }
        else if([obj isKindOfClass:[NSDictionary class]]){
            NSString* propertyType=[self classTypeForDictonary:obj];
            if(propertyType!=nil){
                Class cls=NSClassFromString(propertyType);
                id newClass=[[cls alloc] init];
                NSArray* __properties=[self propertyFromClass:cls];
                [self parserDictonary:obj serialInObject:newClass withObjectProperties:__properties];
                [serialInArray addObject:newClass];
            }
        }
        else if([obj isKindOfClass:[NSArray class]]){
            NSMutableArray* list=[[NSMutableArray alloc] initWithCapacity:2];
            [self parserArray:obj serialInArray:list];
            [serialInArray addObject:list];
        }
    }
}

-(NSString*)propertyTypeForPropertyName:(NSString*)name withObjectProperties:(NSArray*)properties{
    for(SerialSubModelClassInfo* classInfo in properties){
        if([classInfo.propertyName isEqualToString:name]){
            return classInfo.propertyType;
        }
    }
    return nil;
}

-(NSString*)classTypeForDictonary:(NSDictionary*)dict{
    NSString* classType=nil;
    int eqSame=0;
    
    
    for(NSString* subModuleName in self.serialSubModuleName){
        NSArray* properties=[self propertyFromClass:NSClassFromString(subModuleName)];
        int _eqSame=[self checkDict:dict withProperties:properties];
        if(_eqSame>eqSame){
            eqSame=_eqSame;
            classType=subModuleName;
            if(eqSame>=[dict count]){
                break;
            }
        }
    }
    return classType;
}

-(int)checkDict:(NSDictionary*)dict withProperties:(NSArray*)properties{
    __block int eqSameCount=0;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString* dictKey,id dictValue,BOOL*stop){
        NSString* propertyType=nil;
        for(SerialSubModelClassInfo* property in properties){
            if([property.propertyName isEqualToString:dictKey]){
                propertyType=property.propertyType;
                break;
            }
        }
        if(propertyType!=nil){
            if([dictValue isKindOfClass:[NSDictionary class]]){
                NSArray* __properties=[self propertyFromClass:NSClassFromString(propertyType)];
                int _eqSameCount=[self checkDict:dictValue withProperties:__properties];
                eqSameCount+=_eqSameCount;
            }
            else if([dictValue isKindOfClass:[NSArray class]] && [propertyType isEqualToString:@"NSArray"]){
                eqSameCount++;
            }
            else if([dictValue isKindOfClass:[NSString class]] && [propertyType isEqualToString:@"NSString"]){
                eqSameCount++;
            }
            else if([dictValue isKindOfClass:[NSNumber class]] && [propertyType isEqualToString:@"NSNumber"]){
                eqSameCount++;
            }
        }
    }];
    return eqSameCount;
}


-(NSArray *)propertyFromClass:(Class)class{
    
    NSMutableArray *propertyList = [[NSMutableArray alloc] initWithCapacity:2] ;
    
    unsigned int outCount, i;
    
    while(class!=NULL && ![NSStringFromClass(class) isEqualToString:@"NSObject"]){
        objc_property_t *properties = class_copyPropertyList(class, &outCount);
        
        for(i = 0; i < outCount; i++) {
            
            objc_property_t property = properties[i];
            
            NSString *eachPropertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
            NSString *eachPropertyType = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];

            SerialSubModelClassInfo* classInfo=[[SerialSubModelClassInfo alloc] init];
            classInfo.propertyName=eachPropertyName;
            NSString* propertyType=[[eachPropertyType componentsSeparatedByString:@","] firstObject];
            if([propertyType isEqualToString:@"T@\"NSString\""]){
                classInfo.propertyType=@"NSString";
            }
            else if([propertyType isEqualToString:@"T@\"NSArray\""]){
                classInfo.propertyType=@"NSArray";
            }
            else if([propertyType isEqualToString:@"T@\"NSDictionary\""]){
                classInfo.propertyType=@"NSDictionary";
            }
            else if([propertyType rangeOfString:@"@\""].length>0){
                propertyType=[propertyType stringByReplacingOccurrencesOfString:@"T@\"" withString:@""];
                propertyType=[propertyType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                classInfo.propertyType=propertyType;
            }
            else{
                classInfo.propertyType=@"NSNumber";
            }
            [propertyList addObject:classInfo];
        }
        
        free(properties);
        class=[class superclass];
    }
    
    return propertyList;
}


@end


//T@"NSString",&,N,V_a
//Td,N,V_b
//Tq,N,V_c
//T@"TestModel_1",N,V_d
//T@"NSArray",&,N,V_e

/*
 @property(nonatomic,strong) NSString* a;
 
 @property(nonatomic,assign) double b;
 
 @property(nonatomic,assign) long long c;
 
 @property(nonatomic,assign)  TestModel_1* d;
 
 @property(nonatomic,strong)  NSArray* e;

 */
