//
//  ViewController.m
//  RedEnvelope
//
//  Created by wangliang on 2018/1/4.
//  Copyright © 2018年 wangliang. All rights reserved.
//

#import "ViewController.h"
#import "RedEnvViewController.h"
#import "Reward.h"
#import "RedPacketViewController.h"

@interface ViewController ()<CAAnimationDelegate>

@property(nonatomic,strong) RedEnvViewController *redEnvViewController;

@property(nonatomic,strong) UIButton *openButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSString *str=@"58.00";
//    
//    float count=[str floatValue];
//    NSLog(@"count=%.2f",count);
    [self test];
}

-(void)test{
    
    _openButton=[[UIButton alloc] initWithFrame:CGRectMake(50, 100, 50, 50)];
    
    [_openButton setImage:[UIImage imageNamed:@"redpacket_open_btn"] forState:UIControlStateNormal];
    
//    _openButton.backgroundColor=[UIColor orangeColor];
    
    [_openButton addTarget:self action:@selector(openButtonDidLick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_openButton];
   
}

-(void)openButtonDidLick{
     [self.openButton.layer addAnimation:[self openButtonRotateAnimation] forKey:@"transform"];
}

-(CAKeyframeAnimation *)openButtonRotateAnimation
{
    CAKeyframeAnimation *keyAnimate=[CAKeyframeAnimation animation];
    
    keyAnimate.values=[NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0.5, 0)],[NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0, 0.5, 0)],[NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.28, 0, 0.5, 0)], nil];
    
    keyAnimate.cumulative=YES;
    keyAnimate.duration=0.4;
    keyAnimate.repeatCount=3;
    keyAnimate.removedOnCompletion=YES;
    keyAnimate.fillMode=kCAFillModeForwards;
    
    keyAnimate.delegate=self;
    
    return keyAnimate;
}

- (IBAction)redEnvelopeDidClick:(id)sender {
   
    //2. xib
    
    NSDictionary *dict=@{
                      @"money":@"88.88",
                      @"content":@"恭喜发财,大吉大利!",
                      @"name": @"尼古拉斯",
                      @"iconName": @"avatar.png"
                      };

     Reward *reward=[Reward rewardWithDict:dict];

    [RedPacketViewController redPacketWithReward:reward completeBlock:^(float money) {
        
        NSLog(@"领取金额: %.2f",money);
    
    } cancelBlock:^{
    
        NSLog(@"取消领取");
    }];

    //1. Native Code
//    NSDictionary *dict=@{
//                         @"money":@"88.88",
//                         @"content":@"恭喜发财,大吉大利!",
//                         @"name": @"爱瑞思",
//                         @"iconName": @"avatar.png"
//                         };
//
//    Reward *reward=[Reward rewardWithDict:dict];
//
//    [RedEnvViewController redEnvelopeWithReward:reward completeBlock:^(float money) {
//          NSLog(@"领取金额: %.2f",money);
//    } cancelBlock:^{
//        NSLog(@"取消领取");
//    }];

//   _redEnvViewController=[[RedEnvViewController alloc] initRedEnvelopeWithReward:reward completeBlock:^(float money) {
//
//        NSLog(@"领取金额: %f",money);
//
//    } cancelBlock:^{
//
//        NSLog(@"取消领取");
//    }];

}


@end
