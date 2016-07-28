//
//  main.m
//  locationReminders
//
//  Created by David Livingstone on 7/25/16.
//  Copyright © 2016 David Livingstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@import Parse;
@import ParseUI;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}


#pragma MARK Parse Login/Signup

//- (void)login {
//    if (![PFUser currentUser]) {
//        PFLogInViewController *loginViewController = [[PFLogInViewController alloc]init];
//        
//        PFLogInViewController.delegate = self;
//        
//        loginViewController.PFSignUpView.delegate = self;
//        
//        [self presentViewController:loginViewController animated:YES completion:nil];
//    } else {
//        [self setupAdditionalUI];
//    }
//}
//
//- (void)setupAdditionalUI {
//    UIBarButtonItem *signOutButton = [UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut)];
//    
//    self.navigationItem.leftBarButton = signOutButton;
//}
//
//- (void)signout {
//    [PFUser logOut];
//    [self login];
//}
//
//- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self ];
//}
