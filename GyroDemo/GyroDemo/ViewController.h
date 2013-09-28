//
//  ViewController.h
//  GyroDemo
//
//  Created by ManIkWeet on 28-09-13.
//  Copyright (c) 2013 RoKan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *accelerometerLabel;
@property (strong, nonatomic) IBOutlet UILabel *gyroscopeLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *wisselaar;
@property (strong, nonatomic) IBOutlet UIButton *update;

- (IBAction)tap:(id)sender;
- (IBAction)wissel:(id)sender;
- (void)handmatig;
- (void)automatisch;
@end
