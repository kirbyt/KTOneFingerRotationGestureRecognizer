//
//  KTOneFingerRotationGestureRecognizer.m
//
//  Created by Kirby Turner on 4/22/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "KTOneFingerRotationGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@implementation KTOneFingerRotationGestureRecognizer

@synthesize rotation = rotation_;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // Fail when more than 1 finger detected.
   if ([[event touchesForGestureRecognizer:self] count] > 1) {
      [self setState:UIGestureRecognizerStateFailed];
   }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   // We can look at any touch object since we know we 
   // have only 1. If there were more than 1 then 
   // touchesBegan:withEvent: would have failed the recognizer.
   UITouch *touch = [touches anyObject];

   // A tap can have slight movement, but we're not interested
   // in a tap. We want more movement. So if a tap is detected
   // fail the recognizer. 
   if ([self state] == UIGestureRecognizerStatePossible) {
      [self setState:UIGestureRecognizerStateBegan];
   } else {
      [self setState:UIGestureRecognizerStateChanged];
   }

   // To rotate with one finger, we simulate a second finger.
   // The second figure is on the opposite side of the virtual
   // circle that represents the rotation gesture.

   UIView *view = [self view];
   CGPoint center = CGPointMake(CGRectGetMidX([view bounds]), CGRectGetMidY([view bounds]));
   CGPoint currentTouchPoint = [touch locationInView:view];
   CGPoint previousTouchPoint = [touch previousLocationInView:view];
   
   // use the movement of the touch to decide
   // how much to rotate the carousel
   CGPoint line2Start = currentTouchPoint;
   CGPoint line1Start = previousTouchPoint;
   CGPoint line2End = CGPointMake(center.x + (center.x - line2Start.x), center.y + (center.y - line2Start.y));
   CGPoint line1End = CGPointMake(center.x + (center.x - line1Start.x), center.y + (center.y - line1Start.y));
   
   //////
   // Calculate the angle in radians.
   // (From: http://iphonedevelopment.blogspot.com/2009/12/better-two-finger-rotate-gesture.html )
   CGFloat a = line1End.x - line1Start.x;
	CGFloat b = line1End.y - line1Start.y;
	CGFloat c = line2End.x - line2Start.x;
	CGFloat d = line2End.y - line2Start.y;
   
   CGFloat line1Slope = (line1End.y - line1Start.y) / (line1End.x - line1Start.x);
   CGFloat line2Slope = (line2End.y - line2Start.y) / (line2End.x - line2Start.x);
	
	CGFloat degs = acosf(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));

   CGFloat angleInRadians = (line2Slope > line1Slope) ? degs : -degs;
   //////
   
   [self setRotation:angleInRadians];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   [self setState:UIGestureRecognizerStateEnded];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   [self setState:UIGestureRecognizerStateFailed];
}

@end
