//
//  ViewController.h
//  AAMButtons
//
//  Created by Takayuki Fukatsu on 12/02/25.
//  Copyright (c) 2012年 artandmobile.com, fladdict.net All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAMSlideLock.h"

@interface ViewController : UIViewController <AAMSlideLockDelegate>

-(void)initSlideLock;
-(void)slideLockDidSlideComplete:(AAMSlideLock*)theSlideLock;

@end
