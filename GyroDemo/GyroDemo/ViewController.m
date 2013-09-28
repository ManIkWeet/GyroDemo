//
//  ViewController.m
//  GyroDemo
//
//  Created by ManIkWeet on 28-09-13.
//  Copyright (c) 2013 RoKan. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;
@end

@implementation ViewController
@synthesize accelerometerLabel;
@synthesize gyroscopeLabel;
@synthesize wisselaar;
@synthesize update;

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.motionManager = [[CMMotionManager alloc] init];
    self.queue = [[NSOperationQueue alloc] init];
    [self automatisch];
}

- (IBAction)tap:(id)sender
{
    if (self.motionManager.accelerometerAvailable) {
        CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
        self.accelerometerLabel.text = [NSString stringWithFormat:@"Accelerometer:\nX: %+.2f\nY: %+.2f\nZ: %+.2f", accelerometerData.acceleration.x, accelerometerData.acceleration.y,accelerometerData.acceleration.z];
        [accelerometerData release];
    }
    if (self.motionManager.gyroAvailable) {
        CMGyroData *gyroData = self.motionManager.gyroData;
        self.gyroscopeLabel.text = [NSString stringWithFormat:@"Gyroscoop:\nX: %+.2f\nY: %+.2f\nZ: %+.2f", gyroData.rotationRate.x, gyroData.rotationRate.y,gyroData.rotationRate.z];
        [gyroData release];
    }
}

- (IBAction)wissel:(id)sender
{
    if(wisselaar.selectedSegmentIndex == 0) {
        self.update.hidden = YES;
        [self automatisch];
    } else {
        self.update.hidden = NO;
        [self handmatig];
    }
}

- (void)handmatig
{
    if (self.motionManager.accelerometerAvailable) {
        [self.motionManager stopAccelerometerUpdates];
        self.motionManager.accelerometerUpdateInterval = 1.0 / 10.0;
        [self.motionManager startAccelerometerUpdates];
    } else {
        self.accelerometerLabel.text = @"Ik heb geen accelerometer!";
    }
    if (self.motionManager.gyroAvailable) {
        [self.motionManager stopGyroUpdates];
        self.motionManager.gyroUpdateInterval = 1.0 / 10.0;
        [self.motionManager startGyroUpdates];
    } else {
        self.gyroscopeLabel.text = @"Ik heb geen gyroscoop!";
    }
}

- (void)automatisch
{
    if (self.motionManager.accelerometerAvailable) {
        [self.motionManager stopAccelerometerUpdates];
        self.motionManager.accelerometerUpdateInterval = 1.0 / 10.0;
        [self.motionManager startAccelerometerUpdatesToQueue:self.queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            NSString *labelText;
            if (error) {
                [self.motionManager stopAccelerometerUpdates];
                labelText = [NSString stringWithFormat:@"Accelerometer heeft een fout: %@", error];
            } else {
                labelText = [NSString stringWithFormat:@"Accelerometer:\nX: %+.2f\nY: %+.2f\nZ: %+.2f", accelerometerData.acceleration.x, accelerometerData.acceleration.y,accelerometerData.acceleration.z];
            }
            [self.accelerometerLabel performSelectorOnMainThread:@selector(setText:) withObject:labelText waitUntilDone:NO];
            [labelText release];
            [accelerometerData release];
            [error release];
        }];
    } else {
        self.accelerometerLabel.text = @"Ik heb geen accelerometer!";
    }
    
    if(self.motionManager.gyroAvailable) {
        [self.motionManager stopGyroUpdates];
        self.motionManager.gyroUpdateInterval = 1.0 / 10.0;
        [self.motionManager startGyroUpdatesToQueue:self.queue withHandler:^(CMGyroData *gyroData, NSError *error) {
            NSString *labelText;
            if (error) {
                [self.motionManager stopGyroUpdates];
                labelText = [NSString stringWithFormat:@"Gyroscoop heeft een fout: %@", error];
            } else {
                labelText = [NSString stringWithFormat:@"Gyroscoop:\nX: %+.2f\nY: %+.2f\nZ: %+.2f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z];
            }
            [self.gyroscopeLabel performSelectorOnMainThread:@selector(setText:) withObject:labelText waitUntilDone:NO];
            [labelText release];
            [gyroData release];
            [error release];
        }];
    } else {
        self.gyroscopeLabel.text = @"Ik heb geen gyroscoop!";
    }
}

- (void)dealloc
{
    [accelerometerLabel dealloc];
    [gyroscopeLabel dealloc];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
