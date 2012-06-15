//
//  ViewController.m
//  Animations
//
//  Created by Marian PAUL on 22/03/12.
//  Copyright (c) 2012 IPuP SARL. All rights reserved.
//

#import "ViewController.h"
#import "AnimationsViewController.h"
#import "LayersViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *buttonForViewAnimations = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonForViewAnimations setFrame:CGRectMake(30, 30, 130, 30)];
    [buttonForViewAnimations setTitle:@"View animations" forState:UIControlStateNormal];
    [buttonForViewAnimations addTarget:self action:@selector(displayViewAnimations:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonForViewAnimations];
    
    UIButton *buttonForLayersAnimations = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonForLayersAnimations setFrame:CGRectMake(30, 80, 180, 30)];
    [buttonForLayersAnimations setTitle:@"Layers animations" forState:UIControlStateNormal];
    [buttonForLayersAnimations addTarget:self action:@selector(displayLayersAnimations:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonForLayersAnimations];
}

- (void) displayViewAnimations:(id)sender 
{
    if (!_animationsViewController)
        _animationsViewController = [[AnimationsViewController alloc] initWithNibName:@"AnimationsViewController" bundle:nil];
    [self.view addSubview:_animationsViewController.view];
}

- (void) displayLayersAnimations:(id)sender 
{
    if (!_layerViewController)
        _layerViewController = [[LayersViewController alloc] initWithNibName:@"LayersViewController" bundle:nil];
    [self.view addSubview:_layerViewController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
