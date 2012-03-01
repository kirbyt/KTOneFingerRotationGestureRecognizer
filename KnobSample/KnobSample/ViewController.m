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
@property (nonatomic, assign) CGFloat currentAngle;
@end

@implementation ViewController

@synthesize knobImageView = _knobImageView;
@synthesize currentAngle = _currentAngle;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
   KTOneFingerRotationGestureRecognizer *spin = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
   [[self knobImageView] addGestureRecognizer:spin];
   [[self knobImageView] setUserInteractionEnabled:YES];

   [self resetKnob:self];
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

- (IBAction)resetKnob:(id)sender
{
   [[self knobImageView] setUserInteractionEnabled:NO];
   [UIView animateWithDuration:0.20 animations:^{
      [[self knobImageView] setTransform:CGAffineTransformMakeRotation(0)];
   } completion:^(BOOL finished) {
      [[self knobImageView] setUserInteractionEnabled:YES];
      [self setCurrentAngle:0];
   }];
}

@end
