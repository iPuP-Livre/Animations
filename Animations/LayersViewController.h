//
//  LayersViewController.h
//  Animations
//
//  Created by Marian PAUL on 22/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayersViewController : UIViewController
{
    CGImageRef _imageRef;
}
@property (nonatomic, retain) CALayer *imageLayer;
- (CGImageRef)scaleAndCropImage:(UIImage *)fullImage;
@end
