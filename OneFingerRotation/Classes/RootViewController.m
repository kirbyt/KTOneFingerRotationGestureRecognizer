//
//  RootViewController.m
//  OneFingerRotation
//
//  Created by Kirby Turner on 4/22/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"
#import "HFRotationalPanRecognizer.h"


@implementation RootViewController

@synthesize imageView1 = imageView1_;
@synthesize imageView2 = imageView2_;
@synthesize imageView3 = imageView3_;

- (void)dealloc
{
   
   imageView1_ = nil;
   imageView2_ = nil;
   imageView3_ = nil;
}

- (id)init
{
   self = [super initWithNibName:@"RootView" bundle:nil];
   if (self) {
      
   }
   return self;
}

- (void)addRotationGestureToView:(UIView *)view
{
   HFRotationalPanRecognizer *rotation = [[HFRotationalPanRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
   [view addGestureRecognizer:rotation];
    rotation.rotationCentre = view.center;// Would be default anyway
    rotation.useViewCenterForRotationCentre = NO; // Needs to be set if
                                                  //rotationCentre  control is to be effective
}

- (void)addTapGestureToView:(UIView *)view numberOfTaps:(NSInteger)numberOfTaps
{
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
   [tap setNumberOfTapsRequired:numberOfTaps];
   [view addGestureRecognizer:tap];
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   // UIImageView sets userInteractionEnabled to NO by default.
   [[self imageView1] setUserInteractionEnabled:YES];
   [[self imageView2] setUserInteractionEnabled:YES];
   [[self imageView3] setUserInteractionEnabled:YES];
   
   [self addRotationGestureToView:[self view]];
   [self addTapGestureToView:[self view] numberOfTaps:1];
   
   [self addRotationGestureToView:[self imageView1]];
   [self addTapGestureToView:[self imageView1] numberOfTaps:1];

   [self addRotationGestureToView:[self imageView2]];
   [self addTapGestureToView:[self imageView2] numberOfTaps:2];
   
   [self addRotationGestureToView:[self imageView3]];
   [self addTapGestureToView:[self imageView3] numberOfTaps:3];
}

- (void)viewDidUnload
{
   [self setImageView1:nil];
   [self setImageView2:nil];
   [self setImageView3:nil];
   [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
   return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)rotating:(HFRotationalPanRecognizer *)recognizer
{
   UIView *view = [recognizer view];
   [view setTransform:CGAffineTransformRotate([view transform], [recognizer rotationAngle])];
    recognizer.rotationAngle = 0.0;
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
   UIView *view = [recognizer view];
   [view setTransform:CGAffineTransformMakeRotation(0)];
}

@end
