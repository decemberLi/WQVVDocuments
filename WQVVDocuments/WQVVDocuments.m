//
//  WQVVDocuments.m
//  WQVVDocuments
//
//  Created by Jason on 16/3/8.
//  Copyright © 2016年 Shanesun. All rights reserved.
//

#import "WQVVDocuments.h"

@interface WQVVDocuments()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation WQVVDocuments

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    NSLog(@"======== Plugin in ");
    NSMenuItem *windowItem = [[NSApp mainMenu] itemWithTitle:@"Window"];

    if (!windowItem)  return;
    
    [[windowItem submenu] addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *WQVVDocuments = [[NSMenuItem alloc] initWithTitle:@"WQDocuments" action:@selector(clickedDocuments) keyEquivalent:@""];
    WQVVDocuments.target = self;
    [[windowItem submenu] addItem:WQVVDocuments];
    
    NSMenuItem *WQCreateModelFormJson = [[NSMenuItem alloc] initWithTitle:@"WQModel" action:@selector(clickedCreateModel) keyEquivalent:@""];
    WQCreateModelFormJson.target = self;
    [[windowItem submenu] addItem:WQCreateModelFormJson];
    
}

// Sample Action, for menu item:
- (void)clickedDocuments
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"WQDocuments"];
    [alert runModal];
}

- (void)clickedCreateModel
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"WQModel"];
    [alert runModal];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
