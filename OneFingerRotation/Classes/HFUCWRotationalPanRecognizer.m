//
//  HFUCWRotationalPanRecognizer.m
//
//  Created by Joseph Lord on 15/01/2014.
//  Copyright (c) 2014 Human Friendly Ltd.
//  Licenced under the MIT License.
//  Please place a link to http://human-friendly.com somewhere in you user
//  facing documentation or website with a a note that are including software
//  developed by Human Friendly Ltd. (This is NOT a legal requirement but a
//  polite request. The MIT license provisions are the only legal license.
//

#import "HFUCWRotationalPanRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface AngleTime : NSObject
@property (nonatomic)NSTimeInterval time;
@property (nonatomic)CGFloat angle;

@end
@implementation AngleTime

+(AngleTime *)ad:(CGFloat)angle atTime:(NSTimeInterval)time {
    AngleTime * ad = [[AngleTime alloc]init];
    ad.angle = angle;
    ad.time = time;
    return ad;
}

@end

@interface HFUCWRotationalPanRecognizer()
{
    NSMutableArray * angleDates;
    //CGPoint touchOrigin; // Keep the same origin for the duration of the touch?
    CGFloat previousTouchAngle;
}

@end

@implementation HFUCWRotationalPanRecognizer

#pragma mark init

-(id)init {
    self = [super init];
    if (self) {
        angleDates = [NSMutableArray array];
        _excludeRadius = 40.0;
        _useViewCenterForRotationCentre = YES;
    }
    return self;
}
#pragma mark UIGestureRecognizer overides

-(void)reset {
    [angleDates removeAllObjects];
}

#pragma mark Touch handlers

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (touches.count > 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    UITouch * touch = [touches anyObject];
    if(![self touchInsideTouchArea:touch]) {
        self.state = UIGestureRecognizerStateFailed;
    }
    previousTouchAngle = [self angleForTouch:touch];
    AngleTime * ad = [AngleTime ad:previousTouchAngle atTime:event.timestamp];
    [angleDates addObject:ad];
    self.rotationAngle = 0.0;
    self.state = UIGestureRecognizerStateBegan;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (touches.count > 1) {
           self.state = UIGestureRecognizerStateCancelled;
        return;
    }
    UITouch * touch = [touches anyObject];
    if(![self touchInsideTouchArea:touch]) {
        self.state = UIGestureRecognizerStateEnded;
        return;
    }
    if (_useViewCenterForRotationCentre) {
        _rotationCentre = self.view.center;
    }
    CGFloat newAngle = [self angleForTouch:touch];
    if (newAngle == previousTouchAngle) {
        return; // No rotation no state update.
    }
    AngleTime * ad = [AngleTime ad:newAngle atTime:event.timestamp];
    [angleDates addObject:ad];
    self.rotationAngle = self.rotationAngle + newAngle - previousTouchAngle;
    previousTouchAngle = newAngle;
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
    }
    else {
        self.state = UIGestureRecognizerStateChanged;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
}


#pragma mark property Getters

// Currently only uses last two touches but they are all available so could be
// used if you need to extend this.
-(CGFloat)rotationVelocity {
    if (angleDates.count < 2) {
        return 0.0;
    }
    AngleTime *last = [angleDates lastObject];
    AngleTime *previous = angleDates[angleDates.count - 2];
    NSTimeInterval tDelta = last.time - previous.time;
    if (tDelta > 0.25) {
        return 0.0;
    }
    CGFloat aDelta = last.angle - previous.angle;
    if (tDelta <= 0.0) {
    }
    return aDelta/tDelta;
}

#pragma mark Internal

-(BOOL)touchInsideTouchArea:(UITouch *)touch
{
    if (![self.view pointInside:[touch locationInView:self.view] withEvent:nil]) {
        return NO;
    }
    CGPoint pointInSuper = [touch locationInView:self.view.superview];
    pointInSuper.x -= _rotationCentre.x;
    pointInSuper.y -= _rotationCentre.y;
    CGFloat distanceFromCentre = sqrt(pointInSuper.x * pointInSuper.x + pointInSuper.y * pointInSuper.y);
    return (distanceFromCentre > _excludeRadius);
}

-(CGFloat)angleForTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.view.superview];
    // C atan2 returns a value even for 0,0 (probably 0)
    CGFloat x = point.x - _rotationCentre.x;
    CGFloat y = point.y - _rotationCentre.y;
    CGFloat angle = atan2(y, x);
    return angle;
}

@end
