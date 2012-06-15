//
//  AnimationsViewController.h
//  Animations
//
//  Created by Marian PAUL on 22/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationsViewController : UIViewController
{
    UIView *_viewForColorAnimation, *_viewForAlphaAnimation;
    UIButton *_buttonForWiggleAnimation;
    UIImageView *_imageViewForZoomAnimation;
    UIView *_viewForMultiplesAnimations;
    
    NSTimer *_timerForColorAnimation;
    
    BOOL _canAnimate;    
}

- (void) startAlphaAnimation;
- (void) startWiggleAnimation;
- (void) startZoomAnimation;
- (void) startMultipleAnimations;

@end
