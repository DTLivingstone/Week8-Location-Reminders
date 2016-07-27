//
//  AnagramFinder.m
//  locationReminders
//
//  Created by David Livingstone on 7/27/16.
//  Copyright © 2016 David Livingstone. All rights reserved.
//

#import "AnagramFinder.h"

@implementation AnagramFinder

- (BOOL)isAnagram:(NSString *)string1 string2:(NSString *)string2
{
    if ([string1 length] != [string2 length]) {
        NSLog(@"These strings are different lenghts");
        return NO;
    }
    
    NSMutableArray *CharacterString1 = [[NSMutableArray alloc]init];
    NSMutableArray *CharacterString2 = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [string1 length]; i++) {
        NSString *ch1 = [string1 substringWithRange:NSMakeRange(i, 1)];
        [CharacterString1 addObject:ch1];
//        NSLog(@"%@", CharacterString1);
        NSString *ch2 = [string2 substringWithRange:NSMakeRange(i, 1)];
        [CharacterString2 addObject:ch2];
//        NSLog(@"%@", CharacterString2);
    }
    
    for (NSString *ch in CharacterString2) {
        if ([CharacterString1 containsObject:ch]) {
            [CharacterString1 removeObject:ch];
        }
    }
    
    if (CharacterString1.count == 0) {
        NSLog(@"'%@' is an anagram of '%@'", string1, string2);
        return YES;
    } else {
        NSLog(@"'%@' is NOT an anagram of '%@'", string1, string2);
        return NO;
    }
}

@end
