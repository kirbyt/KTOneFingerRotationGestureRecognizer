/**
 **   KnobSample
 **
 **   Created by Kirby Turner.
 **   Copyright (c) 2012 White Peak Software. All rights reserved.
 **
 **   Permission is hereby granted, free of charge, to any person obtaining 
 **   a copy of this software and associated documentation files (the 
 **   "Software"), to deal in the Software without restriction, including 
 **   without limitation the rights to use, copy, modify, merge, publish, 
 **   distribute, sublicense, and/or sell copies of the Software, and to permit 
 **   persons to whom the Software is furnished to do so, subject to the 
 **   following conditions:
 **
 **   The above copyright notice and this permission notice shall be included 
 **   in all copies or substantial portions of the Software.
 **
 **   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
 **   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 **   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 **   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 **   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 **   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 **   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **
 **/

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
   
   KTOneFingerRotationGestureRecognizer *spin = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
   [[self knobImageView] addGestureRecognizer:spin];
   [[self knobImageView] setUserInteractionEnabled:YES];

   // Allow rotation between the start and stop angles.
   [self setStartAngle:-90.0];
   [self setStopAngle:90.0];
   
   [self resetKnob:self];
}

- (void)rotated:(KTOneFingerRotationGestureRecognizer *)recognizer
{
   CGFloat degrees = radiansToDegrees([recognizer rotation]);
   CGFloat currentAngle = [self currentAngle] + degrees;
   CGFloat relativeAngle = fmodf(currentAngle, 360.0);  // Converts to angle between 0 and 360 degrees.

   BOOL shouldRotate = NO;
   if ([self startAngle] <= [self stopAngle]) {
      shouldRotate = (relativeAngle >= [self startAngle] && relativeAngle <= [self stopAngle]);
   } else if ([self startAngle] > [self stopAngle]) {
      shouldRotate = (relativeAngle >= [self startAngle] || relativeAngle <= [self stopAngle]);
   }
   
   if (shouldRotate) {
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
