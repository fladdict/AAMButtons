//
//  ViewController.m
//  AAMButtons
//
//  Created by 深津 貴之 on 12/02/25.
//  Copyright (c) 2012年 Art & Mobile. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

-(void)setPoisition:(CGPoint)thePoint forView:(UIView*)theView
{
    CGRect r = theView.frame;
    r.origin = thePoint;
    theView.frame = r;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initSlideLock];
}

-(void)initSlideLock
{
    /*
     Here is a initialization of SlideLock.
     */
    UIImageView *track = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SlideLock_track"]];
    UIImageView *thumb = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SlideLock_thumb"]];
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SlideLock_background"]];
    AAMSlideLock *slideLock = [[AAMSlideLock alloc]initWithTrackView:track ThumbView:thumb backgroundView:background];
    slideLock.delegate = self;
    [self.view addSubview:slideLock];
    [self setPoisition:CGPointMake(0, 480-95) forView:slideLock];
}

-(void)slideLockDidSlideComplete:(AAMSlideLock*)theSlideLock
{
    /*
     Here is a delegate for SlideLock Completion.
     Customize as you like.
     */
    [UIView animateWithDuration:1 animations:
     ^(void){
         theSlideLock.userInteractionEnabled = NO;
         CGRect f = theSlideLock.frame;
         f.origin.y = 480;
         theSlideLock.frame = f;
     } completion:
     ^(BOOL finished){
         //Lock the slide again
         theSlideLock.isLocked = YES;
         [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:
          ^{
              [self setPoisition:CGPointMake(0, 480-95) forView:theSlideLock];
          } completion:
          ^(BOOL finished){
              theSlideLock.userInteractionEnabled = YES;
          }];
     }];
}



@end
