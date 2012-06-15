//
//  LayersViewController.m
//  Animations
//
//  Created by Marian PAUL on 22/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "LayersViewController.h"
#import <QuartzCore/QuartzCore.h>

#define LargeurMax 148.0
#define HauteurMax 156.0f
#define XPosition 86.0f
#define YPosition 20.0f
#define nombreDeCarreX 10.0f
#define nombreDeCarreY 10.0f

@interface LayersViewController ()
- (CAAnimation *)animationForX:(NSInteger)x Y:(NSInteger)y imageSize:(CGSize)size;
- (CGPoint)randomDestinationX:(CGFloat)x Y:(CGFloat)y imageSize:(CGSize)size;
@end

@implementation LayersViewController
@synthesize imageLayer = _imageLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Construction du layer qui va recevoir l'animation
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = CGRectMake(XPosition, YPosition, LargeurMax, HauteurMax);
        self.imageLayer.contentsGravity = kCAGravityResizeAspectFill;
        self.imageLayer.masksToBounds = NO;

        [self.view.layer addSublayer:self.imageLayer];
                
        // image que l'on va transformer
        UIImage *image = [UIImage imageNamed:@"logo_ipup_carre.png"];
        // on redimensionne l'image et renvoie un CGImageRef
        _imageRef = [self scaleAndCropImage:image];
        // on place l'image dans le layer
        _imageLayer.contents = (__bridge id)_imageRef;
        
        // bouton pour lancer l'animation
        UIButton *buttonToPop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonToPop setFrame:CGRectMake(130, 400, 70, 30)];
        [buttonToPop setTitle:@"Pop" forState:UIControlStateNormal];
        [buttonToPop addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonToPop];

    }
    return self;
}

// Là où tout commence...
- (void)pop:(id)sender {
    if(nil != _imageLayer.contents) 
    {
        
        //on récupère la taille de l'image à découper
        CGSize imageSize = CGSizeMake(CGImageGetWidth(_imageRef), CGImageGetHeight(_imageRef));
        NSMutableArray *layers = [NSMutableArray array];
        
        // on la découpe !    
        for(int x = 0;x < nombreDeCarreX;x++) 
        {
            for(int y = 0;y < nombreDeCarreY;y++) 
            {
                // création d'une nouvelle Frame (la taille du petit carré)
                CGRect frame = CGRectMake((imageSize.width / nombreDeCarreX) * x, (imageSize.height / nombreDeCarreY) * y, imageSize.width / nombreDeCarreX, imageSize.height / nombreDeCarreY);
                
                //on crée un layer pour ce petit carré
                CALayer *layer = [CALayer layer];
                layer.frame = frame;
                // définition de l'action (l'animation)
                layer.actions = [NSDictionary dictionaryWithObject:[self animationForX:x Y:y imageSize:imageSize] forKey:@"opacity"];
                // on crée une mini image pour ce petit carré
                CGImageRef subimage = CGImageCreateWithImageInRect(_imageRef, frame);
                layer.contents = (__bridge id)subimage;
                CFRelease(subimage);
                [layers addObject:layer];
            }
        }
        
        // on ajoute les petits layers créés à notre imageLayer
        for(CALayer *layer in layers) 
        {
            [_imageLayer addSublayer:layer];
            layer.opacity = 0.0f;
        }
        
        // maintenant que l'on a reconstitué l'image avec nos petits carrés, on supprime le contenu (l'image originale) de imageLayer
        _imageLayer.contents = nil;

    }
}

// Crée une animation pour chaque petit carré
- (CAAnimation *)animationForX:(NSInteger)x Y:(NSInteger)y imageSize:(CGSize)size 
{
    // On retourne un group d'animation qui comporte l'animation de l'opacité (transparence) et l'animation de la position (déplacement)
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = 4.0f;
    
    // animation pour la transparence
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = [NSNumber numberWithDouble:1.0f]; // transparence de départ
    opacity.toValue = [NSNumber numberWithDouble:0.0f]; // transparence de fin
    
    //animation du déplacement
    CABasicAnimation *position = [CABasicAnimation  animationWithKeyPath:@"position"];
    position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CGPoint dest = [self randomDestinationX:x Y:y imageSize:size]; // on choisit aléatoirement une position
    position.toValue = [NSValue valueWithCGPoint:dest];
    
    group.animations = [NSArray arrayWithObjects:opacity, position, nil]; // On crée un group d'animation 
    return group;
}

// Choisir une destination aléatoire pour le carré

- (CGPoint)randomDestinationX:(CGFloat)x Y:(CGFloat)y imageSize:(CGSize)size 
{
    CGPoint destination;
    
    // on tire au hasard une valeur (soit 0 soit 1)
    int sensX = random()%2;
    // Si c'est 0, alors le sens sera -1 sinon ce sera 1
    sensX = sensX == 0 ? -1 : 1;
    
    int sensY = random()%2;
    sensY = sensY == 0 ? -1 : 1;
    
    // on tire au sort une destination
    destination.x = (CGFloat)sensX * 50.0f * ((CGFloat)(random() % 10000)) / 2000.0f;
    destination.y = (CGFloat)sensY * 50.0f * ((CGFloat)(random() % 10000)) / 2000.0f;
    
    return destination;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

// méthode pour redimensionner l'image et la convertir en CGImageRef
- (CGImageRef)scaleAndCropImage:(UIImage *)fullImage {
    CGSize imageSize = fullImage.size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    imageSize.width = imageSize.width*scale;
    imageSize.height = imageSize.height*scale;
    CGImageRef subimage = NULL;
    
    if(imageSize.width > imageSize.height) {
        // La hauteur est plus petite que la largeur
        scale = HauteurMax / imageSize.height;
        CGFloat offsetX = ((scale * imageSize.width - LargeurMax) / 2.0f) / scale;
        CGRect subRect = CGRectMake(offsetX, 0.0f, imageSize.width - (2.0f * offsetX), imageSize.height);
        subimage = CGImageCreateWithImageInRect([fullImage CGImage], subRect);
    } else {
        // La largeur est plus petite que la hauteur
        scale = LargeurMax / imageSize.width;
        CGFloat offsetY = ((scale * imageSize.height - HauteurMax) / 2.0f) / scale;
        CGRect subRect = CGRectMake(0.0f, offsetY, imageSize.width, imageSize.height - (2.0f * offsetY));
        subimage = CGImageCreateWithImageInRect([fullImage CGImage], subRect);
    }
    
    // on zoom l'image selon LargeurMax et HauteurMax définis au dessus
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, LargeurMax, HauteurMax, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst); 
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGRect rect = CGRectMake(0.0f, 0.0f, LargeurMax, HauteurMax);
    CGContextDrawImage(context, rect, subimage);
    CGContextFlush(context);
    // on obtient la nouvelle image
    CGImageRef scaledImage = CGBitmapContextCreateImage(context);
    CGContextRelease (context);
    CGImageRelease(subimage);
    subimage = NULL;
    subimage = scaledImage;
    return subimage;
}

@end
