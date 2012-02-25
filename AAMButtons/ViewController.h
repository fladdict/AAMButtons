//
//  ViewController.h
//  AAMButtons
//
//  Created by 深津 貴之 on 12/02/26.
//  Copyright (c) 2012年 Art & Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAMSlideLock.h"

@interface ViewController : UIViewController <AAMSlideLockDelegate>

-(void)initSlideLock;
-(void)slideLockDidSlideComplete:(AAMSlideLock*)theSlideLock;

@end
