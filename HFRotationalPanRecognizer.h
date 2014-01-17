//
//  HFRotationalPanRecognizer.m
//
//  Created by Joseph Lord on 15/01/2014.
//  Copyright (c) 2014 Human Friendly Ltd.
//  Licenced under the MIT License.
//  Please place a link to http://human-friendly.com somewhere in you user
//  facing documentation or website with a a note that are including software
//  developed by Human Friendly Ltd. (This is NOT a legal requirement but a
//  polite request. The MIT license provisions are the only legal license.
//

#import <UIKit/UIKit.h>

@interface HFRotationalPanRecognizer : UIGestureRecognizer

// If you want incremental updates you can reset this to zero during the gesture
@property (nonatomic)CGFloat rotationAngle;

// Only available at the end of the gesture (UIGestureRecognizerStateEnded or
// UIGestureRecognizer
@property (nonatomic, readonly)CGFloat rotationVelocity;


// In superview co-ordinate system. Expected to be consistent through a gesture
// no consideration has been given to behaviour if the rotationCentre shifts mid
// gesture.
@property (nonatomic)CGPoint rotationCentre;
@property (nonatomic)BOOL useViewCenterForRotationCentre;

// Don't process touches within this distance of the rotation centre
@property (nonatomic)CGFloat excludeRadius;

@end
