//
//  Reward.h
//  RedEnvelope
//
//  Created by wangliang on 2018/1/4.
//  Copyright © 2018年 wangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Reward : NSObject

@property(nonatomic,copy) NSString *name;

@property(nonatomic,copy) NSString *content;

@property(nonatomic,strong) NSString *iconName;

@property(nonatomic,assign) NSString *money;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)rewardWithDict:(NSDictionary *)dict;

@end
