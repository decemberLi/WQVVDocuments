//
//  WQVVDocuments.h
//  WQVVDocuments
//
//  Created by Jason on 16/3/8.
//  Copyright © 2016年 Shanesun. All rights reserved.
//

#import <AppKit/AppKit.h>

@class WQVVDocuments;

static WQVVDocuments *sharedPlugin;

@interface WQVVDocuments : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end