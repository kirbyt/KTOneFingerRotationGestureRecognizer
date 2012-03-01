//
//  ViewController.m
//  KnobSample
//
//  Created by Kirby Turner on 3/1/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "ViewController.h"
#import "KTOneFingerRotationGestureRecognizer.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize knobImageView = _knobImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
   KTOneFingerRotationGestureRecognizer *spin = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
   [[self knobImageView] addGestureRecognizer:spin];
   [[self knobImageView] setUserInteractionEnabled:YES];
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

- (void)rotated:(KTOneFingerRotationGestureRecognizer *)recognizer
{
   UIView *view = [recognizer view];
   [view setTransform:CGAffineTransformRotate([view transform], [recognizer rotation])];
}

@end
