//
//  AnimationsViewController.m
//  Animations
//
//  Created by Marian PAUL on 22/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "AnimationsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AnimationsViewController ()

@end

@implementation AnimationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // vue pour l'animation de la couleur
    _viewForColorAnimation = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 60, 60)];
    [self.view addSubview:_viewForColorAnimation];
    
    UIButton *buttonToLaunchStopAnimations = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonToLaunchStopAnimations setFrame:CGRectMake(125, 420, 70, 30)];
    [buttonToLaunchStopAnimations addTarget:self action:@selector(launchStopAnim:) forControlEvents:UIControlEventTouchUpInside];
    [buttonToLaunchStopAnimations setTitle:@"Start" forState:UIControlStateNormal];
    [buttonToLaunchStopAnimations setTitle:@"Stop" forState:UIControlStateSelected];
    [self.view addSubview:buttonToLaunchStopAnimations];
    
    // vue pour l'animation de la transparence
    _viewForAlphaAnimation = [[UIView alloc] initWithFrame:CGRectMake(100, 30, 60, 60)];
    [_viewForAlphaAnimation setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_viewForAlphaAnimation];
    
    // bouton qui va trembler
    _buttonForWiggleAnimation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonForWiggleAnimation setFrame:CGRectMake(30, 100, 70, 30)];
    [_buttonForWiggleAnimation setTitle:@";-°" forState:UIControlStateNormal];
    [self.view addSubview:_buttonForWiggleAnimation];
    
    // vue pour le zoom
    _imageViewForZoomAnimation = [[UIImageView alloc] initWithFrame:CGRectMake(120, 100, 158, 61)];
    _imageViewForZoomAnimation.image = [UIImage imageNamed:@"logo-ipup.png"];
    [self.view addSubview:_imageViewForZoomAnimation];
    
    //vue pour l'animation multiple
    _viewForMultiplesAnimations = [[UIView alloc] initWithFrame:CGRectMake(0, 160, 40, 40)];
    _viewForMultiplesAnimations.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_viewForMultiplesAnimations];

    
}

- (void) launchStopAnim:(id)sender 
{
    UIButton *button = (UIButton*)sender;
    
    if (![button isSelected]) 
    {
        _canAnimate = YES;
        
        // on lance les anims
        // Couleur
        // On lance tout de suite une animation
        [self performSelector:@selector(changeColor:) withObject:nil];
        // on lance le timer    
        _timerForColorAnimation = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(changeColor:) userInfo:nil repeats:YES];
        
        [self startAlphaAnimation];
        [self startWiggleAnimation];
        [self startZoomAnimation];
        [self startMultipleAnimations];
    }
    else 
    {
        _canAnimate = NO;
        
        // on stoppe l'anim de la couleur
        [_timerForColorAnimation invalidate];
        _timerForColorAnimation = nil;  
        
        // on arrête toutes les animations        
        for (UIView *view in [self.view subviews]) 
        {
            [view.layer removeAllAnimations];
        }
        
    }    
    // on change l'état du bouton
    [button setSelected:![button isSelected]];
}

- (void)changeColor:(NSTimer*)theTimer 
{
    [UIView animateWithDuration:3.5 // [1]
                     animations:^{
                         CGFloat redLevel    = rand() / (float) RAND_MAX; // [2]
                         CGFloat greenLevel    = rand() / (float) RAND_MAX;
                         CGFloat blueLevel    = rand() / (float) RAND_MAX;
                         
                         _viewForColorAnimation.backgroundColor = [UIColor colorWithRed: redLevel green: greenLevel blue: blueLevel alpha: 1.0]; // [3]   
                     }];   
}

- (void) startAlphaAnimation 
{
#define alphaStart 0.9
#define alphaStop 0.1
    // point de départ
    _viewForAlphaAnimation.alpha = alphaStart;
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat // [1]
                     animations:^{
                         _viewForAlphaAnimation.alpha = alphaStop; // s'arrête ici et recommence
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void) startWiggleAnimation 
{
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
    
    CGAffineTransform initialPosition = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-7.0)); // [1]
    CGAffineTransform finalPosition = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(7.0));
    // point de départ :
    _buttonForWiggleAnimation.transform = initialPosition; // [2]
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         _buttonForWiggleAnimation.transform = finalPosition; // finit ici et recommence
                     } completion:^(BOOL finished) {}
     ];
}

- (void) startZoomAnimation 
{
    CGAffineTransform initialZoom = CGAffineTransformMakeScale(1.0, 1.0);
    CGAffineTransform finalZoom = CGAffineTransformMakeScale(0.6, 0.6);
    // point de départ :
    _imageViewForZoomAnimation.transform = initialZoom; 
    
    
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseIn // [1]
                     animations:^{
                         _imageViewForZoomAnimation.transform = finalZoom; // finit ici et recommence    
                     } completion:^(BOOL finished) {}
     ];
}

#pragma mark - multiple animations

- (void) startMultipleAnimations 
{
    CGPoint finalPosition = CGPointMake(300, 200);
    CGPoint initialPosition = CGPointMake(0, 160);
    
    _viewForMultiplesAnimations.center = initialPosition;
    
    [UIView animateWithDuration:3.0
                     animations:^{
                         // centrage de la vue
                         _viewForMultiplesAnimations.center = finalPosition;
                     }
                     completion:^(BOOL finished) {
                         // petite rotation
                         CGAffineTransform finalTransform = CGAffineTransformMakeRotation(RADIANS(180));
                         [UIView animateWithDuration:1.5
                                          animations:^{
                                              _viewForMultiplesAnimations.transform = finalTransform;
                                          }
                                          completion:^(BOOL finished) {
                                              // déplacement + changement de l'alpha
                                              CGPoint finalPosition = CGPointMake(30, 400);
                                              [UIView animateWithDuration:3.0
                                                               animations:^{
                                                                   _viewForMultiplesAnimations.center = finalPosition;
                                                                   _viewForMultiplesAnimations.alpha = 0.2;
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:3.0
                                                                                    animations:^{
                                                                                        // retour au début
                                                                                        _viewForMultiplesAnimations.center = initialPosition;
                                                                                        _viewForMultiplesAnimations.alpha = 1.0;
                                                                                        _viewForMultiplesAnimations.transform = CGAffineTransformIdentity;
                                                                                    }
                                                                                    completion:^(BOOL finished) {
                                                                                    // on recommence !
                                                                                        [self startMultipleAnimations];
                                                                                    }];

                                                               }];

                                          }];
                         
                     }];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
