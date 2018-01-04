//
//  RedPacketViewController.m
//  RedEnvelope
//
//  Created by wangliang on 2018/1/4.
//  Copyright © 2018年 wangliang. All rights reserved.
//

#import "RedPacketViewController.h"
#import "Reward.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ViewScaleByIphone5 ([UIScreen mainScreen].bounds.size.width/320.0f)

@interface RedPacketViewController ()<UIGestureRecognizerDelegate,CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImgViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImgViewY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bachImgViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImgViewW;
@property (strong, nonatomic) IBOutlet UIWindow *redPacketWindow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openBtnW;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property(nonatomic,copy) CompleteBlock completeBlock;
@property(nonatomic,copy) CancelBlock cancelBlock;
@property(nonatomic,strong) Reward *reward;

@end

@implementation RedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}

+(instancetype)redPacketWithReward:(Reward *)reward completeBlock:(CompleteBlock)completeBlock cancelBlock:(CancelBlock)cancelBlock
{
    RedPacketViewController *redPacketVc=[[RedPacketViewController alloc] initRedPacketWithReward:reward completeBlock:completeBlock cancelBlock:cancelBlock];
    
    return redPacketVc;
}

-(instancetype)initRedPacketWithReward:(Reward *)reward completeBlock:(CompleteBlock)completeBlock cancelBlock:(CancelBlock)cancelBlock
{
    self=[super init];
    
    if (self) {
        
        _reward=reward;
        _completeBlock=completeBlock;
        _cancelBlock=cancelBlock;

        //TapGesture
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonAction:)];

        tapGR.delegate=self;
        [self.view addGestureRecognizer:tapGR];

        [self setupRedPacketWindow];
        
        [self loadbackgroundImageView];
        
        [self setupSubViewStyle];
    
    }
    return self;
}

-(void)setupSubViewStyle
{
    self.iconImageView.layer.cornerRadius=3;
    self.iconImageView.clipsToBounds=YES;
    self.iconImageView.layer.borderWidth=1;
    self.iconImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.iconImageView.image=[UIImage imageNamed:_reward.iconName];
    
    self.nameLabel.textColor=[UIColor colorWithRed:255.0/255.0 green:226.0/255.0 blue:177.0/255.0 alpha:1];
    self.nameLabel.text=_reward.name;

    self.detailLabel.textColor=[UIColor colorWithRed:245.0/255.0 green:193.0/255.0 blue:150.0/255.0 alpha:1];
    
    self.messageLabel.textColor=[UIColor colorWithRed:234.0/255.0 green:204.0/255.0 blue:157.0/255.0 alpha:1];
    self.messageLabel.text=_reward.content;

}
- (IBAction)openButtonAction:(id)sender {
    
     [self.openButton.layer addAnimation:[self openButtonRotateAnimation] forKey:@"transform"];
}

- (IBAction)closeButtonAction:(id)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backImageView.transform=CGAffineTransformMakeScale(0.2, 0.2);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.08 animations:^{
            
            self.backImageView.transform=CGAffineTransformMakeScale(0.25, 0.25);
            
        } completion:^(BOOL finished) {
            
            [self.redPacketWindow removeFromSuperview];
            
            self.redPacketWindow.rootViewController=nil;
            
            self.redPacketWindow=nil;
            
            //cancelBlock
            
            if (_cancelBlock) {
                
                _cancelBlock();
            }
        }];
    }];
}


#pragma mark -- UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([_openButton pointInside:[touch locationInView:_openButton] withEvent:nil]) {
        
        [self openButtonAction:nil];
        
        return NO;
    }
    
    if ([_closeButton pointInside:[touch locationInView:_closeButton] withEvent:nil]) {
        
        [self closeButtonAction:nil];
        
        return NO;
    }
    
    return (![_backImageView pointInside:[touch locationInView:_backImageView] withEvent:nil]);
}

#pragma mark -- CAAnimationDelegate

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(_completeBlock){
        
        _completeBlock([_reward.money floatValue]);
    }
    
    self.messageLabel.text=[NSString stringWithFormat:@"中奖金额%.2f",[_reward.money floatValue]];
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


-(void)loadbackgroundImageView
{
    UIImage *image=[UIImage imageNamed:@"redpacket_bg"];
    
    //h1/w1=h2/w2
    CGFloat width=ScreenWidth - 50 * ViewScaleByIphone5;
    CGFloat height=width * (image.size.height / image.size.width);
    
    CGFloat x=25 * ViewScaleByIphone5;
    
    CGFloat y=(ScreenHeight - height) * 0.5;
    
    CGFloat openBtnWH=100 *ViewScaleByIphone5;
    
    self.backImgViewX.constant=x;
    self.backImgViewY.constant=y;
    self.bachImgViewH.constant=height;
    self.backImgViewW.constant=width;
    
    self.openBtnH.constant=openBtnWH;
    self.openBtnW.constant=openBtnWH;
 
    [self startBackGroundImageViewAnimate];
    
    [self.backImageView addSubview:self.openButton];
}

-(void)startBackGroundImageViewAnimate{
    
    self.backImageView.transform=CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backImageView.transform=CGAffineTransformMakeScale(1.05, 1.05);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 animations:^{
            self.backImageView.transform=CGAffineTransformMakeScale(0.95, 0.95);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                self.backImageView.transform=CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    }];
}

-(void)setupRedPacketWindow
{
   
    self.redPacketWindow.frame=[UIScreen mainScreen].bounds;
    
    self.redPacketWindow.windowLevel=1314;
    self.redPacketWindow.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.35];
    
    [self.redPacketWindow makeKeyAndVisible];
    self.redPacketWindow.rootViewController=self;
    
    
}

-(void)dealloc
{
    NSLog(@"RedPacketViewController 销毁 --");
}

@end
