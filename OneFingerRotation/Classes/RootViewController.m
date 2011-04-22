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

@synthesize imageView = imageView_;

- (void)dealloc
{
   [imageView_ release], imageView_ = nil;
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
   
   // Add the one finger rotation gesture recongnizer to the 
   // current view. It can be added it to [self imageView]
   // if we want. Just remember to the userInteractionEnabled
   // flag to YES on the imageView.
   
   KTOneFingerRotationGestureRecognizer *rotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
   [[self view] addGestureRecognizer:rotation];
   [rotation release];
}

- (void)viewDidUnload
{
   [super viewDidUnload];
   [self setImageView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
   return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)rotating:(KTOneFingerRotationGestureRecognizer *)recognizer
{
   UIView *view = [self imageView];
   [view setTransform:CGAffineTransformRotate([view transform], [recognizer rotation])];
}


@end
