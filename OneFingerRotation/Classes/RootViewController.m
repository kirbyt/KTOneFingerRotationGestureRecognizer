//
//  RootViewController.m
//  OneFingerRotation
//
//  Created by Kirby Turner on 4/22/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"
#import "KTOneFingerRotationGestureRecognizer.h"


@implementation RootViewController

@synthesize imageView1 = imageView1_;
@synthesize imageView2 = imageView2_;
@synthesize imageView3 = imageView3_;

- (void)dealloc
{
   
   [imageView1_ release], imageView1_ = nil;
   [imageView2_ release], imageView2_ = nil;
   [imageView3_ release], imageView3_ = nil;
   [super dealloc];
}

- (id)init
{
   self = [super initWithNibName:@"RootView" bundle:nil];
   if (self) {
      
   }
   return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   
//// Set #if to 1 to add the guester recognizer to the image view.
//// Set #if to 0 to add the gesture recognizer to the main view.
//#if 1
//   [[self imageView] setUserInteractionEnabled:YES];
//   KTOneFingerRotationGestureRecognizer *rotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
//   [[self imageView] addGestureRecognizer:rotation];
//   [rotation release];
//#else
//   KTOneFingerRotationGestureRecognizer *rotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
//   [[self view] addGestureRecognizer:rotation];
//   [rotation release];
//#endif
   
   // UIImageView sets userInteractionEnabled to NO by default.
   [[self imageView1] setUserInteractionEnabled:YES];
   [[self imageView2] setUserInteractionEnabled:YES];
   [[self imageView3] setUserInteractionEnabled:YES];
   
   KTOneFingerRotationGestureRecognizer *rotation;
   
   rotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
   [[self view] addGestureRecognizer:rotation];
   [rotation release];
   
   rotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
   [[self imageView1] addGestureRecognizer:rotation];
   [rotation release];
   
   rotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
   [[self imageView2] addGestureRecognizer:rotation];
   [rotation release];
   
   rotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
   [[self imageView3] addGestureRecognizer:rotation];
   [rotation release];
   
}

- (void)viewDidUnload
{
   [super viewDidUnload];
   [self setImageView1:nil];
   [self setImageView2:nil];
   [self setImageView3:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
   return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)rotating:(KTOneFingerRotationGestureRecognizer *)recognizer
{
   UIView *view = [recognizer view];
   [view setTransform:CGAffineTransformRotate([view transform], [recognizer rotation])];
}


@end
