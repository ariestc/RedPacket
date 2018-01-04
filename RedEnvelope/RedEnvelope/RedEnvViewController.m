//
//  RedEnvViewController.m
//  RedEnvelope
//
//  Created by wangliang on 2018/1/4.
//  Copyright © 2018年 wangliang. All rights reserved.
//

#import "RedEnvViewController.h"
#import "Reward.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ViewScaleByIphone5 ([UIScreen mainScreen].bounds.size.width/320.0f)

#define LeftMargin 20

@interface RedEnvViewController ()<UIGestureRecognizerDelegate,CAAnimationDelegate>

@property(nonatomic,strong) Reward *reward;

@property(nonatomic,strong) UIWindow *redEnvWindow;

@property(nonatomic,strong) UIImageView *iconImageView;

@property(nonatomic,strong) UIImageView *bgImageView;

@property(nonatomic,strong) UIButton *openButton;

@property(nonatomic,strong) UIButton *closeButton;

@property(nonatomic,strong) UILabel *nameLabel;

@property(nonatomic,strong) UILabel *detailLabel;

@property(nonatomic,strong) UILabel *msgLabel;

@property(nonatomic,copy) CompleteBlock completeBlock;

@property(nonatomic,copy) CancelBlock cancelBlock;

@end

@implementation RedEnvViewController

+(instancetype)redEnvelopeWithReward:(Reward *)reward completeBlock:(CompleteBlock)completeBlock cancelBlock:(CancelBlock)cancelBlock
{
    RedEnvViewController *redEnvVC=[[self alloc] initRedEnvelopeWithReward:reward completeBlock:completeBlock cancelBlock:cancelBlock];
    
    return redEnvVC;
}

-(instancetype)initRedEnvelopeWithReward:(Reward *)reward completeBlock:(CompleteBlock)completeBlock cancelBlock:(CancelBlock)cancelBlock
{
    self=[super init];
    
    if (self) {
        
        _reward=reward;
        _completeBlock=completeBlock;
        _cancelBlock=cancelBlock;
        
        //TapGesture
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeRedEnvelopeView)];
        
        tapGR.delegate=self;
        [self.view addGestureRecognizer:tapGR];
        
        
//        [self.redEnvWindow addSubview:self.view];
       
        [self.redEnvWindow addSubview:self.bgImageView];
        
//        [_redEnvWindow addSubview:self.view];
//        [_redEnvWindow addSubview:_bgImageView];
    }
    return self;
}

-(void)startBackGroundImageViewAnimate{
    
    self.bgImageView.transform=CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.bgImageView.transform=CGAffineTransformMakeScale(1.05, 1.05);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 animations:^{
            self.bgImageView.transform=CGAffineTransformMakeScale(0.95, 0.95);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                self.bgImageView.transform=CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    }];
}

-(void)openButtonDidLick
{
    [_openButton.layer addAnimation:[self openButtonRotateAnimation] forKey:@"transform"];
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

-(void)closeRedEnvelopeView
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.bgImageView.transform=CGAffineTransformMakeScale(0.2, 0.2);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.08 animations:^{
            
            self.bgImageView.transform=CGAffineTransformMakeScale(0.25, 0.25);
            
        } completion:^(BOOL finished) {
            
            [self.redEnvWindow removeFromSuperview];
            
            self.redEnvWindow.rootViewController=nil;
            
            self.redEnvWindow=nil;
            
            //cancelBlock
            
            if (_cancelBlock) {
                
                _cancelBlock();
            }
        }];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark -- CAAnimationDelegate

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(_completeBlock){
        
        _completeBlock([_reward.money floatValue]);
    }
    
    _msgLabel.text=[NSString stringWithFormat:@"中奖金额%.2f",[_reward.money floatValue]];
}


#pragma mark -- UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([_openButton pointInside:[touch locationInView:_openButton] withEvent:nil]) {
        
        [self openButtonDidLick];
        
        return NO;
    }
    
    if ([_closeButton pointInside:[touch locationInView:_closeButton] withEvent:nil]) {
        
        [self closeRedEnvelopeView];
        
        return NO;
    }
    
    return (![_bgImageView pointInside:[touch locationInView:_bgImageView] withEvent:nil]);
}

-(UILabel *)msgLabel
{
    if (_msgLabel == nil) {
        
        CGFloat y=CGRectGetMaxY(_detailLabel.frame)+10*ViewScaleByIphone5;
        CGFloat width=_bgImageView.frame.size.width - 2 * LeftMargin;
        CGFloat height=27 * ViewScaleByIphone5;
        _msgLabel=[[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, y, width, height)];
        
        _msgLabel.textColor=[UIColor colorWithRed:234.0/255.0 green:204.0/255.0 blue:157.0/255.0 alpha:1];
        _msgLabel.font=[UIFont systemFontOfSize:23];
        _msgLabel.textAlignment=NSTextAlignmentCenter;
        
        _msgLabel.text=_reward.content;
    }
    return _msgLabel;
}

-(UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        
        CGFloat y=CGRectGetMaxY(_nameLabel.frame)+10;
        CGFloat width=_bgImageView.frame.size.width - 2 * LeftMargin;
        _detailLabel=[[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, y, width, LeftMargin)];
        
        _detailLabel.textColor=[UIColor colorWithRed:245.0/255.0 green:193.0/255.0 blue:150.0/255.0 alpha:1];
        _detailLabel.font=[UIFont systemFontOfSize:15];
        _detailLabel.textAlignment=NSTextAlignmentCenter;
        
        _detailLabel.text=@"给你发了一个红包";
        
    }
    return _detailLabel;
}

-(UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        
        CGFloat y=CGRectGetMaxY(_iconImageView.frame)+10;
        CGFloat width=_bgImageView.frame.size.width - 2 * LeftMargin;
        _nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(LeftMargin,y,width, LeftMargin)];
        
        _nameLabel.textColor=[UIColor colorWithRed:255.0/255.0 green:226.0/255.0 blue:177.0/255.0 alpha:1];
        _nameLabel.font=[UIFont systemFontOfSize:17];
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        
        _nameLabel.text=_reward.name;
    }
    return _nameLabel;
}

-(UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        
        CGFloat x=_bgImageView.frame.size.width * 0.5 - 24;
        _iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, 35, 48, 48)];
        
        _iconImageView.layer.cornerRadius=3;
        _iconImageView.clipsToBounds=YES;
        _iconImageView.layer.borderWidth=1;
        _iconImageView.layer.borderColor=[UIColor whiteColor].CGColor;
        
        _iconImageView.image=[UIImage imageNamed:_reward.iconName];
    }
    return _iconImageView;
}


-(UIButton *)closeButton
{
    if (_closeButton==nil) {
        
        _closeButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_closeButton setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    }
    
    return _closeButton;
}

-(UIButton *)openButton
{
    if (_openButton ==nil) {
        
        CGFloat WH=100 *ViewScaleByIphone5;
        
        CGFloat x=(_bgImageView.frame.size.width - WH)*0.5;
        CGFloat y=_bgImageView.frame.size.height * 0.5;
        _openButton=[[UIButton alloc] initWithFrame:CGRectMake(x, y, WH, WH)];
        
        [_openButton setImage:[UIImage imageNamed:@"redpacket_open_btn"] forState:UIControlStateNormal];
        
        [_openButton addTarget:self action:@selector(openButtonDidLick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _openButton;
}

//lazy load bgImageView
-(UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        
        UIImage *image=[UIImage imageNamed:@"redpacket_bg"];
        
        //h1/w1=h2/w2
        CGFloat width=ScreenWidth - 50 * ViewScaleByIphone5;
        CGFloat height=width * (image.size.height / image.size.width);
        
        CGFloat x=25 * ViewScaleByIphone5;
        
        CGFloat y=(ScreenHeight - height) * 0.5;
        
        _bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        _bgImageView.image=image;
        
        [_bgImageView addSubview:self.openButton];
        [_bgImageView addSubview:self.closeButton];
        [_bgImageView addSubview:self.iconImageView];
        [_bgImageView addSubview:self.nameLabel];
        [_bgImageView addSubview:self.detailLabel];
        [_bgImageView addSubview:self.msgLabel];
        
        [self startBackGroundImageViewAnimate];
    }
    return _bgImageView;
}


//lazy load redEnvWindow

-(UIWindow *)redEnvWindow
{
    if (_redEnvWindow == nil) {
        
        _redEnvWindow=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _redEnvWindow.windowLevel=1314;
        _redEnvWindow.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.35];
        
//        [_redEnvWindow makeKeyAndVisible];
        _redEnvWindow.hidden=NO;
        
        _redEnvWindow.rootViewController=self;
    }
    
    return _redEnvWindow;
}

-(void)dealloc
{
    NSLog(@"RedEvViewController 销毁 --");
}


@end
