//
//  ViewController.m
//  locationReminders
//
//  Created by David Livingstone on 7/25/16.
//  Copyright © 2016 David Livingstone. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "LocationController.h"
#import "DetailViewController.h"



@import MapKit;

@interface ViewController ()<MKMapViewDelegate, LocationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender;

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
    
    [self.mapView.layer setCornerRadius:20.0];
    [self.mapView setDelegate: self];
    [self.mapView setShowsUserLocation:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[LocationController sharedController]setDelegate:self];
    
    [[[LocationController sharedController]locationManager]startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)firstLocationButtonPresssed:(UIButton *)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(41.422650, -122.386127);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 15100.0, 15100.0);
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)secondLocationButtonPressed:(UIButton *)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(41.758961, -70.493932);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 6000.0, 6000.0);
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)thirdLocationButtonPressed:(UIButton *)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(35.850655, -95.318298);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 1530.0, 1530.0);
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        newPoint.coordinate = touchMapCoordinate;
        
        newPoint.title = @"New Location";
        newPoint.subtitle = @"This is where you long-pressed";
        
        [self.mapView addAnnotation:newPoint];
    }
}

- (void)locationControllerDidUpdateLocation:(CLLocation *)location {
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0) animated:YES];
}

#pragma MARK MapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    
    annotationView.canShowCallout = YES;
    
    UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    annotationView.rightCalloutAccessoryView = rightCalloutButton;
    
    return annotationView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        if ([sender isKindOfClass:[MKPinAnnotationView class]]) {
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            
            DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
            
            detailViewController.annotationTitle = annotationView.annotation.title;
            detailViewController.coordinate = annotationView.annotation.coordinate;
        }
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"DetailViewController" sender:view];
}

@end
