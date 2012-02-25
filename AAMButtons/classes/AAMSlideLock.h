//
//  AAMSlideLock.h
//  AAMButtons
//
//  Created by Takayuki Fukatsu on 12/02/25.
//  Copyright (c) 2012年 artandmobile.com, fladdict.net All rights reserved.
//

#import <Foundation/Foundation.h>

@class AAMSlideLock;
@protocol AAMSlideLockDelegate
@optional
-(void)slideLockDidSlideBegin:(AAMSlideLock*)theSlideLock;
-(void)slideLockDidSlideComplete:(AAMSlideLock*)theSlideLock;
-(void)slideLockDidSlideCancel:(AAMSlideLock*)theSlideLoc;
-(void)slideLockDidSlide:(AAMSlideLock*)theSlideLock;
@end


/*
 
 */
@interface AAMSlideLock : UIView
{
    CGPoint dragOffset;
}

@property (assign,nonatomic) id <AAMSlideLockDelegate> delegate;
@property (retain,nonatomic) UIView *thumbView;
@property (retain,nonatomic) UIView *trackView;
@property (retain,nonatomic) UIView *backgroundView;
@property (assign,nonatomic) BOOL isLocked;
@property (readonly, nonatomic) BOOL isDragging;
@property (readonly, nonatomic) float unlockProgress;   //0-1 value of unlock progress.

-(id)initWithTrackView:(UIView*)theTrack ThumbView:(UIView*)theThumb;
-(id)initWithTrackView:(UIView*)theTrack ThumbView:(UIView*)theThumb backgroundView:(UIView*)theBackground;

-(void)setIsLocked:(BOOL)isLocked animated:(BOOL)theBool;

-(void)moveThumbToLockedPosition:(BOOL)animated;
-(void)moveThumbToUnlockedPosition:(BOOL)animated;

@end
