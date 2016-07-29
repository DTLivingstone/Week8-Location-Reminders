//
//  ViewController.m
//  locationReminders
//
//  Created by David Livingstone on 7/25/16.
//  Copyright © 2016 David Livingstone. All rights reserved.
//

#import "ViewController.h"
#import "LocationController.h"
#import "DetailViewController.h"
#import "AnagramFinder.h"
#import "StringSum.h"
#import "Reminder.h"
@import Parse;
@import ParseUI;
@import MapKit;

@interface ViewController ()<MKMapViewDelegate, LocationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView.layer setCornerRadius:20.0];
    [self.mapView setDelegate: self];
    [self.mapView setShowsUserLocation:YES];
    [self login];
    
    //    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //
    //    testObject[@"foo"] = @"bar";
    //
    //    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    //        NSLog(@"Succeeded: %i, Error: %@", succeeded, error);
    //    }];
    //
    //    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    //
    //    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    //        if (!error) {
    //            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //                NSLog(@"Objects: %@", objects);
    //            }];
    //        }
    //    }];
    
    //    NSArray *spaceship = @[@"foo", @12.3, @213.2];
    //    NSArray *garage = @[@"foo", @12.3, @213.2];
    //    NSArray *moscone = @[@"foo", @12.3, @213.2];
    //    NSArray *bill_graham = @[@"foo", @12.3, @213.2];
    //    NSArray *hq = @[@"foo", @12.3, @213.2];
    //
    //    NSMutableArray *preloadedAnnotations;
    //
    //    [preloadedAnnotations addObject:spaceship];
    //    [preloadedAnnotations addObject:garage];
    //    [preloadedAnnotations addObject:moscone];
    //    [preloadedAnnotations addObject:bill_graham];
    //    [preloadedAnnotations addObject:hq];
    
    CLLocationCoordinate2D coordinate0 = CLLocationCoordinate2DMake(37.334806, -122.009007);
    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(37.340288, -122.068880);
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(37.783424, -122.400910);
    CLLocationCoordinate2D coordinate3 = CLLocationCoordinate2DMake(37.777724, -122.417330);
    CLLocationCoordinate2D coordinate4 = CLLocationCoordinate2DMake(37.331692, -122.030751);
    
    MKPointAnnotation *newPoint0 = [[MKPointAnnotation alloc]init];
    MKPointAnnotation *newPoint1 = [[MKPointAnnotation alloc]init];
    MKPointAnnotation *newPoint2 = [[MKPointAnnotation alloc]init];
    MKPointAnnotation *newPoint3 = [[MKPointAnnotation alloc]init];
    MKPointAnnotation *newPoint4 = [[MKPointAnnotation alloc]init];
    
    newPoint0.title = @"point 0";
    newPoint1.title = @"point 1";
    newPoint2.title = @"point 2";
    newPoint3.title = @"point 3";
    newPoint4.title = @"point 4";
    
    newPoint0.coordinate = coordinate0;
    newPoint1.coordinate = coordinate1;
    newPoint2.coordinate = coordinate2;
    newPoint3.coordinate = coordinate3;
    newPoint4.coordinate = coordinate4;
    
    [self.mapView addAnnotation:newPoint0];
    [self.mapView addAnnotation:newPoint1];
    [self.mapView addAnnotation:newPoint2];
    [self.mapView addAnnotation:newPoint3];
    [self.mapView addAnnotation:newPoint4];
    
    [self fetchAllReminders];
}

- (NSMutableArray <Reminder *>*)fetchAllReminders {
    NSMutableArray *reminders = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            __weak typeof (self) weakSelf = self;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [reminders addObjectsFromArray:objects];
                for (Reminder* reminder in objects) {
                    __weak typeof (self) strongSelf = weakSelf;
                    [strongSelf addReminder:reminder];
                }
            }];
        }
    }];
    return reminders;
}

- (void)addReminder:(Reminder *)reminder {
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        CLCircularRegion *circularRegion = [[CLCircularRegion alloc]initWithCenter:CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude) radius:reminder.radius.floatValue identifier:reminder.name];
        [[LocationController sharedController].locationManager startMonitoringForRegion:circularRegion];
        MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude) radius:reminder.radius.floatValue];
        [self.mapView addOverlay:circleOverlay];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[LocationController sharedController]setDelegate:self];
    
    [[[LocationController sharedController]locationManager]startUpdatingLocation];
    
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testObserverFired) name:@"TestNotification" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TestNotification" object:nil];
}

- (MKPinAnnotationView *)colorRandomizer:(MKPinAnnotationView *)point {
    point.animatesDrop = YES;
    
    switch (arc4random_uniform(5)) {
        case 0: // green
            point.pinTintColor = [UIColor colorWithRed:0.796  green:0.904  blue:0.134 alpha:1];
            break;
        case 1: // blue
            point.pinTintColor = [UIColor colorWithRed:0.244  green:0.613  blue:0.827 alpha:1];
            break;
        case 2: // purple
            point.pinTintColor = [UIColor colorWithRed:0.634  green:0.379  blue:0.664 alpha:1];
            break;
        case 3: // pink
            point.pinTintColor = [UIColor colorWithRed:0.889  green:0.286  blue:0.600 alpha:1];
            break;
        default: // dark blue
            point.pinTintColor = [UIColor colorWithRed:0.098  green:0.359  blue:0.602 alpha:1];
    }
    
    return point;
}

- (void)locationControllerDidUpdateLocation:(CLLocation *)location {
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0) animated:YES];
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

#pragma MARK MapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
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
    
    annotationView = [self colorRandomizer:annotationView];
    
    return annotationView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        if ([sender isKindOfClass:[MKPinAnnotationView class]]) {
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            
            DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
            
            detailViewController.annotationTitle = annotationView.annotation.title;
            detailViewController.coordinate = annotationView.annotation.coordinate;
            
            __weak typeof(self) weakSelf = self;
            detailViewController.completion = ^(MKCircle *circle)
            {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [weakSelf.mapView removeAnnotation:annotationView.annotation];
                [strongSelf.mapView addOverlay:circle];
            };
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"DetailViewController" sender:view];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc]initWithOverlay:overlay];
    circleRenderer.strokeColor = [UIColor blueColor];
    circleRenderer.fillColor = [UIColor redColor];
    
    circleRenderer.alpha = 0.2;
    
    return circleRenderer;
}

- (void)login {
    if (![PFUser currentUser])
    {
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc]init];
        
        loginViewController.delegate = self;
        loginViewController.signUpController.delegate = self;
        [self presentViewController:loginViewController animated:YES completion:nil];
    } else {
        [self setupAdditionalUI];
    }
}

- (void)setupAdditionalUI {
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut)];
    
    self.navigationItem.leftBarButtonItem = signOutButton;
}

- (void)signOut {
    [PFUser logOut];
    [self login];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupAdditionalUI];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupAdditionalUI];
}

@end
