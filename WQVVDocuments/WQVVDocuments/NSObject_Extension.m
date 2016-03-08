//
//  NSObject_Extension.m
//  WQVVDocuments
//
//  Created by Jason on 16/3/8.
//  Copyright © 2016年 Shanesun. All rights reserved.
//


#import "NSObject_Extension.h"
#import "WQVVDocuments.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[WQVVDocuments alloc] initWithBundle:plugin];
        });
    }
}
@end
