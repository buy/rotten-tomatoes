//
//  Helpers.m
//  rotten-tomatoes
//
//  Created by Chang Liu on 10/25/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+ (NSURL *)getHighResImageURL:(NSDictionary *)movie {
    NSString *originalUrlString = movie[@"posters"][@"original"];
    NSRange range = [originalUrlString rangeOfString:@".*cloudfront.net/"
                                             options:NSRegularExpressionSearch];
    NSString *newUrlString = [originalUrlString stringByReplacingCharactersInRange:range
                                                                        withString:@"https://content6.flixster.com/"];
    NSURL *originalImageURL = [[NSURL alloc] initWithString: newUrlString];
    
    return originalImageURL;
}

@end
