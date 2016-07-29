//
//  DetailViewController.m
//  locationReminders
//
//  Created by David Livingstone on 7/26/16.
//  Copyright © 2016 David Livingstone. All rights reserved.
//

#import "DetailViewController.h"
#import "Reminder.h"
#import "LocationController.h"

@import CoreLocation;

@interface DetailViewController ()

- (IBAction)createReminderButtonSelected:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *reminderText;
@property (weak, nonatomic) IBOutlet UITextField *radiusText;

@end

@implementation DetailViewController //

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"title: %@", self.annotationTitle);
    NSLog(@"Coordinate: %f, %f", self.coordinate.latitude, self.coordinate.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)createReminderButtonSelected:(UIButton *)sender {
    NSString *reminderName = _reminderText.text;
    NSNumber *radius = [NSNumber numberWithFloat:_radiusText.text.floatValue];
    
    Reminder *reminder = [Reminder object];
    
    reminder.name = reminderName;
    reminder.radius = radius;
    
    NSLog(@"New reminder: %@, %@ ", reminder.name, reminder.radius);
    
    reminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    //    if (self.completion) {
    //        self.completion([MKCircle circleWithCenterCoordinate:self.coordinate radius:radius.floatValue]);
    //        [self.navigationController popViewControllerAnimated:YES];
    
    __weak typeof(self) weakSelf = self; // avoiding retain cycle
    
    [reminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"reminder saved to Parse");
        
        if (strongSelf.completion) {
            if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                CLCircularRegion *circularRegion = [[CLCircularRegion alloc]initWithCenter:strongSelf.coordinate radius:radius.floatValue identifier:reminderName];
            [[LocationController sharedController].locationManager startMonitoringForRegion:circularRegion];
            
                
            strongSelf.completion([MKCircle circleWithCenterCoordinate:strongSelf.coordinate radius:radius.floatValue]);
            }
        }
        
    }];
}
@end
