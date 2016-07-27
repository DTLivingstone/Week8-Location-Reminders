//
//  AnagramFinder.h
//  locationReminders
//
//  Created by David Livingstone on 7/27/16.
//  Copyright © 2016 David Livingstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnagramFinder : NSObject

- (BOOL)isAnagram:(NSString *)string1 string2:(NSString *)string2;

@end
