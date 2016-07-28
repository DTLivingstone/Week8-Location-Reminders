//
//  stringSum.m
//  locationReminders
//
//  Created by David Livingstone on 7/27/16.
//  Copyright © 2016 David Livingstone. All rights reserved.
//

#import "stringSum.h"

@implementation StringSum

- (int)sumString:(NSString *)inputString {
    
    int accumulator = 0;
    
    for (int i = 0; i < [inputString length]; i++) {
        NSString *character = [inputString substringWithRange:NSMakeRange(i, 1)];
        int charInt = [character intValue];
        accumulator += charInt;
    }
    
    NSLog(@"Sum of individual numerals in '%@': %d", inputString, accumulator);
    
    return accumulator;
}

@end
