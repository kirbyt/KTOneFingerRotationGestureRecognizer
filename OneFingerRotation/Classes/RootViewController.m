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

- (void)addRotationGestureToView:(UIView *)view
{
   KTOneFingerRotationGestureRecognizer *rotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
   [view addGestureRecognizer:rotation];
   [rotation release];
}

- (void)addTapGestureToView:(UIView *)view numberOfTaps:(NSInteger)numberOfTaps
{
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
   [tap setNumberOfTapsRequired:numberOfTaps];
   [view addGestureRecognizer:tap];
   [tap release];
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

- (void)rotating:(KTOneFingerRotationGestureRecognizer *)recognizer
{
   UIView *view = [recognizer view];
   [view setTransform:CGAffineTransformRotate([view transform], [recognizer rotation])];
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
   UIView *view = [recognizer view];
   [view setTransform:CGAffineTransformMakeRotation(0)];
}

@end
