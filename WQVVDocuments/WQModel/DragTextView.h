//
//  DragTextView.h
//  WQVVDocuments
//
//  Created by December on 16/3/14.
//  Copyright © 2016年 Shanesun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DragTextView;

@protocol DragViewDelagate<NSObject>

@optional
- (BOOL)dragFileURL:(NSURL *)fileURL;

@end

@interface DragTextView : NSTextView
@property (nonatomic)IBOutlet id <DragViewDelagate> dragDelegate;
@end
