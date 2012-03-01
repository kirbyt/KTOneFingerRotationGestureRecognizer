//
//  ViewController.m
//  KnobSample
//
//  Created by Kirby Turner on 3/1/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "ViewController.h"
#import "KTOneFingerRotationGestureRecognizer.h"

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180 / M_PI)


@interface ViewController ()
@property (nonatomic, assign) CGFloat currentAngle;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat stopAngle;
@end

@implementation ViewController

@synthesize knobImageView = _knobImageView;
@synthesize currentAngle = _currentAngle;
@synthesize startAngle = _startAngle;
@synthesize stopAngle = _stopAngle;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
   KTOneFingerRotationGestureRecognizer *spin = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
   [[self knobImageView] addGestureRecognizer:spin];
   [[self knobImageView] setUserInteractionEnabled:YES];

   [self setStartAngle:90.0];
   [self setStopAngle:360.0];
   
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
   CGFloat degrees = radiansToDegrees([recognizer rotation]);
   CGFloat currentAngle = [self currentAngle] + degrees;
   CGFloat relativeAngle = fabsf(fmodf(currentAngle, 360.0));  // Converts to angle between 0 and 360 degrees.

   if (relativeAngle >= [self startAngle] && relativeAngle <= [self stopAngle]) {
      [self setCurrentAngle:currentAngle];
      UIView *view = [recognizer view];
      [view setTransform:CGAffineTransformRotate([view transform], [recognizer rotation])];
   }
}

- (IBAction)resetKnob:(id)sender
{
   CGFloat startAngleInRadians = degreesToRadians([self startAngle]);
   [[self knobImageView] setUserInteractionEnabled:NO];
   [UIView animateWithDuration:0.20 animations:^{
      [[self knobImageView] setTransform:CGAffineTransformMakeRotation(startAngleInRadians)];
   } completion:^(BOOL finished) {
      [[self knobImageView] setUserInteractionEnabled:YES];
      [self setCurrentAngle:[self startAngle]];
   }];
}

@end
