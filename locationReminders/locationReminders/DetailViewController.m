//
//  DetailViewController.m
//  locationReminders
//
//  Created by David Livingstone on 7/26/16.
//  Copyright © 2016 David Livingstone. All rights reserved.
//

#import "DetailViewController.h"
#import "Reminder.h"

@interface DetailViewController ()

- (IBAction)createReminderButtonSelected:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *reminderText;

@property (weak, nonatomic) IBOutlet UITextField *radiusText;

@end

@implementation DetailViewController

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
    
//    NSLog(@"New reminder: %@, %@ ", reminder.name, reminder.radius);
    
    reminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    if (self.completion) {
        self.completion([MKCircle circleWithCenterCoordinate:self.coordinate radius:radius.floatValue]);
    }
}
@end
