//
//  Reminder.m
//  locationReminders
//
//  Created by David Livingstone on 7/27/16.
//  Copyright © 2016 David Livingstone. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

@dynamic name; // getters and setters from superclass
@dynamic location;
@dynamic radius;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Reminder"; // make sure this is consistent with subclass name
}

@end
