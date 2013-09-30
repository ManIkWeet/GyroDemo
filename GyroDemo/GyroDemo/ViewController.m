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
@property (strong, nonatomic) NSTimer *updateTimer;
@property (strong, nonatomic) CMAccelerometerData *old;
@end

@implementation ViewController
@synthesize accelerometerLabel;
@synthesize gyroscopeLabel;
@synthesize wisselaar;
@synthesize update;
@synthesize image;

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
    [self updateBall:nil];
}

- (IBAction)wissel:(id)sender
{
    if (wisselaar.selectedSegmentIndex == 0) {
        self.update.hidden = YES;
        [self automatisch];
    } else if (wisselaar.selectedSegmentIndex == 1) {
        self.update.hidden = NO;
        [self handmatig];
    } else if (wisselaar.selectedSegmentIndex == 2) {
        self.update.hidden = YES;
        [self handmatig];
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 target:self selector:@selector(updateBall:) userInfo:nil repeats:YES];
    }
}

- (void) updateBall:(NSTimer*)timer
{
    if (self.motionManager.accelerometerAvailable) {
        CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
        self.accelerometerLabel.text = [NSString stringWithFormat:@"Accelerometer:\nX: %+.2f\nY: %+.2f\nZ: %+.2f", accelerometerData.acceleration.x, accelerometerData.acceleration.y,accelerometerData.acceleration.z];
        //[accelerometerData release];
        if (timer) {
            if(self.old) {
//                float xDifference = self.old.acceleration.x - self.motionManager.accelerometerData.acceleration.x;
//                float yDifference = self.old.acceleration.y - self.motionManager.accelerometerData.acceleration.y;
//                float zDifference = self.old.acceleration.z - self.motionManager.accelerometerData.acceleration.z;
                CGPoint temp = CGPointMake(image.frame.origin.x + self.motionManager.accelerometerData.acceleration.x*50, image.frame.origin.y - self.motionManager.accelerometerData.acceleration.y*50);
                if(temp.x < 0) {
                    temp.x = 0;
                }
                if(temp.x > self.view.frame.size.width - image.frame.size.width) {
                    temp.x = self.view.frame.size.width - image.frame.size.width;
                }
                if(temp.y < 0) {
                    temp.y = 0;
                }
                if(temp.y > self.view.frame.size.height - image.frame.size.height) {
                    temp.y = self.view.frame.size.height - image.frame.size.height;
                }
                CGRect temp2 = image.frame;
                temp2.origin = temp;
                image.frame = temp2;
            }
            self.old = self.motionManager.accelerometerData;
        }
        
    }
    if (self.motionManager.gyroAvailable) {
        CMGyroData *gyroData = self.motionManager.gyroData;
        self.gyroscopeLabel.text = [NSString stringWithFormat:@"Gyroscoop:\nX: %+.2f\nY: %+.2f\nZ: %+.2f", gyroData.rotationRate.x, gyroData.rotationRate.y,gyroData.rotationRate.z];
        //[gyroData release];
    }
}

- (void)handmatig
{
    if(self.updateTimer) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        self.old = nil;
    }
    if (self.motionManager.accelerometerAvailable) {
        [self.motionManager stopAccelerometerUpdates];
        self.motionManager.accelerometerUpdateInterval = 1.0 / 30.0;
        [self.motionManager startAccelerometerUpdates];
    } else {
        self.accelerometerLabel.text = @"Ik heb geen accelerometer!";
    }
    if (self.motionManager.gyroAvailable) {
        [self.motionManager stopGyroUpdates];
        self.motionManager.gyroUpdateInterval = 1.0 / 30.0;
        [self.motionManager startGyroUpdates];
    } else {
        self.gyroscopeLabel.text = @"Ik heb geen gyroscoop!";
    }
}

- (void)automatisch
{
    if(self.updateTimer) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
    if (self.motionManager.accelerometerAvailable) {
        [self.motionManager stopAccelerometerUpdates];
        self.motionManager.accelerometerUpdateInterval = 1.0 / 30.0;
        [self.motionManager startAccelerometerUpdatesToQueue:self.queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            NSString *labelText;
            if (error) {
                [self.motionManager stopAccelerometerUpdates];
                labelText = [NSString stringWithFormat:@"Accelerometer heeft een fout: %@", error];
            } else {
                labelText = [NSString stringWithFormat:@"Accelerometer:\nX: %+.2f\nY: %+.2f\nZ: %+.2f", accelerometerData.acceleration.x, accelerometerData.acceleration.y,accelerometerData.acceleration.z];
            }
            [self.accelerometerLabel performSelectorOnMainThread:@selector(setText:) withObject:labelText waitUntilDone:NO];
            //[labelText release];
            //[accelerometerData release];
            //[error release];
        }];
    } else {
        self.accelerometerLabel.text = @"Ik heb geen accelerometer!";
    }
    
    if(self.motionManager.gyroAvailable) {
        [self.motionManager stopGyroUpdates];
        self.motionManager.gyroUpdateInterval = 1.0 / 30.0;
        [self.motionManager startGyroUpdatesToQueue:self.queue withHandler:^(CMGyroData *gyroData, NSError *error) {
            NSString *labelText;
            if (error) {
                [self.motionManager stopGyroUpdates];
                labelText = [NSString stringWithFormat:@"Gyroscoop heeft een fout: %@", error];
            } else {
                labelText = [NSString stringWithFormat:@"Gyroscoop:\nX: %+.2f\nY: %+.2f\nZ: %+.2f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z];
            }
            [self.gyroscopeLabel performSelectorOnMainThread:@selector(setText:) withObject:labelText waitUntilDone:NO];
            //[labelText release];
            //[gyroData release];
            //[error release];
        }];
    } else {
        self.gyroscopeLabel.text = @"Ik heb geen gyroscoop!";
    }
}

- (void)dealloc
{
    [accelerometerLabel dealloc];
    [gyroscopeLabel dealloc];
    [[self motionManager] dealloc];
    [[self queue] dealloc];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
