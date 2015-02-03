//
//  JHUClassModel.m
//  JHCocoa
//
//  Created by Fanty on 15/1/14.
//  Copyright (c) 2015年 Fanty. All rights reserved.
//

#import "JHUClassModel.h"

@implementation JHUClassModel

@synthesize properties;

-(id)init{
    self=[super init];
    if(self){
        properties=[[NSMutableDictionary alloc] init];
        subClassArray=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addKey:(NSString*)key type:(JHUClassModelType)type{
    if(type==JHUClassModelString)
        [properties setObject:@"@property(nonatomic,copy) NSString*" forKey:key];
    else if(type==JHUClassModelDouble)
        [properties setObject:@"@property(nonatomic,assign) double" forKey:key];
    else if(type==JHUClassModelLongLong)
        [properties setObject:@"@property(nonatomic,assign) long long" forKey:key];

}

-(void)addKey:(NSString*)key class:(NSString*)className{
    [properties setObject:[NSString stringWithFormat:@"@property(nonatomic,copy) %@*",className] forKey:key];
}

-(void)changeClassName:(NSString*)className newClassName:(NSString*)newClassName{
    for(NSString* key in properties.allKeys){
        NSString* property=[properties objectForKey:key];
        [properties setObject:[property stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@*",className] withString:[NSString stringWithFormat:@" %@*",newClassName]] forKey:key];
    }
}


- (BOOL)isEqual:(id)object{
    if([object isKindOfClass:[JHUClassModel class]]){
        JHUClassModel* model =(JHUClassModel*)object;
        if([model.properties count]!=[self.properties count])return NO;
        __block BOOL ret=YES;
        [properties enumerateKeysAndObjectsUsingBlock:^(id key, id object,BOOL*stop){
            NSString* object2=[model->properties objectForKey:key];
            if(![object2 isEqualToString:object]){
                ret=NO;
                *stop=YES;
            }
        }];
        return ret;
    }
    return NO;
}


@end
