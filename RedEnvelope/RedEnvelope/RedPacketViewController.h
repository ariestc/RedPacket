//
//  RedPacketViewController.h
//  RedEnvelope
//
//  Created by wangliang on 2018/1/4.
//  Copyright © 2018年 wangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reward;

typedef void(^CompleteBlock) (float money);

typedef void(^CancelBlock) (void);

@interface RedPacketViewController : UIViewController

+(instancetype)redPacketWithReward:(Reward *)reward completeBlock:(CompleteBlock)completeBlock cancelBlock:(CancelBlock)cancelBlock;

@end
