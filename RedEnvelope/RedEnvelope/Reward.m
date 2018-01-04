//
//  Reward.m
//  RedEnvelope
//
//  Created by wangliang on 2018/1/4.
//  Copyright © 2018年 wangliang. All rights reserved.
//

#import "Reward.h"

@implementation Reward

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self=[super init];
    if (self) {
        
        _name=dict[@"name"];
        _content=dict[@"content"];
        _money=dict[@"money"];
        _iconName=dict[@"iconName"];
        
    }
    return self;
}

+(instancetype)rewardWithDict:(NSDictionary *)dict
{
    
    return [[self alloc] initWithDict:dict];
}

@end
