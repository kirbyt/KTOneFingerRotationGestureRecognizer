//
//  ViewController.h
//  KnobSample
//
//  Created by Kirby Turner on 3/1/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *knobImageView;

- (IBAction)resetKnob:(id)sender;

@end
