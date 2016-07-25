//
//  ViewController.m
//  locationReminders
//
//  Created by David Livingstone on 7/25/16.
//  Copyright © 2016 David Livingstone. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@import MapKit;

@interface ViewController ()

@property(strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    
    testObject[@"foo"] = @"bar";
    
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"Succeeded: %i, Error: %@", succeeded, error);
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Objects: %@", objects);
            }];
        }
    }];
    
    [self requestPermissions];
    [self.mapView.layer setCornerRadius:20.0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestPermissions {
    [self setLocationManager:[[CLLocationManager alloc]init]];
    [self.locationManager requestAlwaysAuthorization];
}

- (IBAction)firstLocationButtonPresssed:(UIButton *)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(53, -126);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 153000.0, 153000.0);
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)secondLocationButtonPressed:(UIButton *)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(48, -123);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 153000.0, 153000.0);
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)thirdLocationButtonPressed:(UIButton *)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(49, -113);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 153000.0, 153000.0);
    
    [self.mapView setRegion:region animated:YES];
}




@end
