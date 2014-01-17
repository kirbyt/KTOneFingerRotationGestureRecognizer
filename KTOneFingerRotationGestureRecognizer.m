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

@interface KTOneFingerRotationGestureRecognizer()
@property (unsafe_unretained, nonatomic) NSMutableArray * previousTimes;
@property (unsafe_unretained, nonatomic) NSMutableArray * previousRotations;
@property (nonatomic, assign) CGFloat lastRawRotation;
@end

@implementation KTOneFingerRotationGestureRecognizer

@synthesize rotation = rotation_;

-(id)initWithTarget:(id)target action:(SEL)action
{
   self = [super initWithTarget:target action:action];
   if ( self )
   {
      self.velocitySampleSmoothingCount = 10;
   }
   return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // Fail when more than 1 finger detected.
   if ([[event touchesForGestureRecognizer:self] count] > 1) {
      [self setState:UIGestureRecognizerStateFailed];
   }
   
   self.previousTimes = [NSMutableArray array];
   self.previousRotations = [NSMutableArray array];
   self.velocity = 0;
   self.lastRawRotation = 0;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   if ([self state] == UIGestureRecognizerStatePossible) {
      [self setState:UIGestureRecognizerStateBegan];
   } else {
      [self setState:UIGestureRecognizerStateChanged];
   }
   
   // We can look at any touch object since we know we
   // have only 1. If there were more than 1 then
   // touchesBegan:withEvent: would have failed the recognizer.
   UITouch *touch = [touches anyObject];
   
   // To rotate with one finger, we simulate a second finger.
   // The second figure is on the opposite side of the virtual
   // circle that represents the rotation gesture.
   
   UIView *view = [self view];
   CGPoint center = CGPointMake(CGRectGetMidX([view bounds]), CGRectGetMidY([view bounds]));
   CGPoint currentTouchPoint = [touch locationInView:view];
   CGPoint previousTouchPoint = [touch previousLocationInView:view];
   
   CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
   
   [self updateVelocityTracking:angleInRadians];
   
   if(fabs(angleInRadians) > M_PI)
   {
      if(angleInRadians > 0)
      {
         angleInRadians -= 2 * M_PI;
      }
      else
      {
         angleInRadians += 2 * M_PI;
      }
   }
   
   [self setRotation:angleInRadians];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   // Perform final check to make sure a tap was not misinterpreted.
   if ([self state] == UIGestureRecognizerStateChanged) {
      [self setState:UIGestureRecognizerStateEnded];
   } else {
      [self setState:UIGestureRecognizerStateFailed];
   }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   [self setState:UIGestureRecognizerStateFailed];
}

- (void)updateVelocityTracking:(CGFloat)angleInRadians
{
   CGFloat change = angleInRadians + self.lastRawRotation;
   self.lastRawRotation = angleInRadians;
   NSDate * now = [NSDate date];
   [self.previousTimes addObject:now];
   [self.previousRotations addObject:@(change)];
   
   while ( self.previousTimes.count > self.velocitySampleSmoothingCount )
   {
      [self.previousTimes removeObjectAtIndex:0];
   }
   
   while ( self.previousRotations.count > self.velocitySampleSmoothingCount )
   {
      [self.previousRotations removeObjectAtIndex:0];
   }
   
   NSAssert( self.previousRotations.count == self.previousTimes.count, @"Number of samples must match" );
   
   if ( self.previousTimes.count > 1 )
   {
      __block CGFloat totalRotation = 0;
      [self.previousRotations enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
         totalRotation += [obj floatValue];
      }];
      
      double totalTime = [[self.previousTimes lastObject] timeIntervalSinceDate:[self.previousTimes objectAtIndex:0]];
      
      self.velocity = totalRotation / totalTime;
   }
}

@end
