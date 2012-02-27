//
//  AAMSlideLock.m
//  AAMButtons
//
//  Created by Takayuki Fukatsu on 12/02/25.
//  Copyright (c) 2012年 artandmobile.com, fladdict.net All rights reserved.
//

#import "AAMSlideLock.h"

@interface AAMSlideLock (private)
@end

@implementation AAMSlideLock

@synthesize delegate;
@synthesize trackView, thumbView, backgroundView;
@synthesize isLocked;
@synthesize isDragging, unlockProgress;


#pragma mark - initialization


-(id)initWithTrackView:(UIView*)theTrack ThumbView:(UIView*)theThumb
{
    return [self initWithTrackView:theTrack ThumbView:theThumb backgroundView:nil];
}

-(id)initWithTrackView:(UIView*)theTrack ThumbView:(UIView*)theThumb backgroundView:(UIView*)theBackground{
    self = [super initWithFrame:theBackground.bounds];
    if(self){
        isDragging = NO;
        isLocked = YES;
        
        [self addSubview:theBackground];
        [self addSubview:theTrack];
        [self addSubview:theThumb];
        
        theTrack.userInteractionEnabled = NO;
        theThumb.userInteractionEnabled = NO;
        theBackground.userInteractionEnabled = NO;
        theTrack.center = theThumb.center = theBackground.center;
        
        self.trackView = theTrack;
        self.thumbView = theThumb;
        self.backgroundView = theBackground;
        [self moveThumbToLockedPosition:NO];
    }
    return self;
}


#pragma mark - getter / setter


-(void)setIsLocked:(BOOL)theIsLocked
{
    [self setIsLocked:theIsLocked animated:YES];
}

-(void)setIsLocked:(BOOL)theIsLocked animated:(BOOL)theBool
{
    if(isLocked==theIsLocked)
        return;
    
    isLocked = theIsLocked;
    if(isLocked){
        //locked animation
        [self moveThumbToLockedPosition:theBool];
    }else{
        //unlocked animation
        [self moveThumbToUnlockedPosition:theBool];
    }

}

-(float)unlockProgress
{
    float startX = self.trackView.frame.origin.x; 
    float destX = self.trackView.frame.origin.x + self.trackView.frame.size.width - self.thumbView.frame.size.width;
    float crntX = self.thumbView.frame.origin.x;
    
    return (crntX - startX) / (destX - startX);
}

-(BOOL)isDraggingComplete
{
    return (thumbView.frame.origin.x + thumbView.frame.size.width == trackView.frame.origin.x + trackView.frame.size.width)? YES : NO;
}


#pragma mark - internal functions


-(void)moveThumbToLockedPosition:(BOOL)animated
{
    CGRect r = thumbView.frame;
    r.origin.x = trackView.frame.origin.x;
    if(animated){
        [UIView beginAnimations:nil context:nil];
        thumbView.frame = r;
        [UIView commitAnimations];
    }else{
        thumbView.frame = r;
    }
}

-(void)moveThumbToUnlockedPosition:(BOOL)animated;
{
    CGRect r = thumbView.frame;
    r.origin.x = trackView.frame.origin.x + trackView.frame.size.width - thumbView.frame.size.width;
    if(animated){
        [UIView beginAnimations:nil context:nil];
        thumbView.frame = r;
        [UIView commitAnimations];
    }else{
        thumbView.frame = r;
    }
}

-(void)dispatchDelegate:(SEL)theSelector
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if([((NSObject*)self.delegate) respondsToSelector:theSelector]){
        [((NSObject*)self.delegate) performSelector:theSelector withObject:self];
    }
    if([((NSObject*)self.thumbView) respondsToSelector:theSelector]){
        [((NSObject*)self.thumbView) performSelector:theSelector withObject:self];
    }
    if([((NSObject*)self.trackView) respondsToSelector:theSelector]){
        [((NSObject*)self.trackView) performSelector:theSelector withObject:self];
    }
    if([((NSObject*)self.backgroundView) respondsToSelector:theSelector]){
        [((NSObject*)self.backgroundView) performSelector:theSelector withObject:self];
    }
    #pragma clang diagnostic pop
}


#pragma mark - delegate


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch){
        //check touching thumb
        CGPoint pt = [touch locationInView:self];
        if( CGRectContainsPoint(thumbView.frame, pt)){
            dragOffset = [touch locationInView:thumbView];
            isDragging = YES;
            [self dispatchDelegate:@selector(slideLockDidSlideBegin:)];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch){
        if(isDragging){
            CGPoint pt = [touch locationInView:self];
            CGRect r = thumbView.frame;
            float x = pt.x - dragOffset.x;
            if(x+r.size.width > trackView.frame.origin.x + trackView.frame.size.width){
                x = trackView.frame.origin.x + trackView.frame.size.width - r.size.width;
            }else if(x<trackView.frame.origin.x){
                x = trackView.frame.origin.x;
            }
            r.origin.x = x;
            thumbView.frame = r;
            [self dispatchDelegate:@selector(slideLockDidSlide:)];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch){
        //Check unlocked or not
        isDragging = NO;
        if([self unlockProgress]==1.0f){
            isLocked = NO;
            [self dispatchDelegate:@selector(slideLockDidSlideComplete:)];
        }else{
            //Failed to unloack and returns to position.
            isLocked = YES;
            [self moveThumbToLockedPosition:YES];
            [self dispatchDelegate:@selector(slideLockDidSlideCanceled:)];
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

@end
