//
//  WQVVDocuments.m
//  WQVVDocuments
//
//  Created by Jason on 16/3/8.
//  Copyright © 2016年 Shanesun. All rights reserved.
//

#import "WQVVDocuments.h"
<<<<<<< HEAD
#import "NSTextView+VVTextGetter.h"
#import "NSString+PDRegex.h"
#import "VVTextResult.h"
//
#import "WQModelVC.h"
=======
#import "WQModelVC.h"

>>>>>>> 483fad7b1684859408228654d1891a3342f2029a

@interface WQVVDocuments()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

// VVDocuments
@property (nonatomic, assign) BOOL prefixTyped;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textStorageDidChange:)
                                                 name:NSTextDidChangeNotification
                                               object:nil];
}

- (void)textStorageDidChange:(NSNotification *)noti
{
//    if ([[noti object] isKindOfClass:[NSTextView class]]) {
//        NSTextView *textView = (NSTextView *)[noti object];
//        VVTextResult *currentLineResult = [textView vv_textResultOfCurrentLine];
//        if (currentLineResult) {
//            
//            //Check if there is a "//" already typed in. We do this to solve the undo issue
//            //Otherwise when you press Cmd+Z, "///" will be recognized and trigger the doc inserting, so you can not perform an undo.
//            NSString *triggerString = [[VVDocumenterSetting defaultSetting] triggerString];
//            
//            if (triggerString.length > 1) {
//                NSString *preTypeString = [triggerString substringToIndex:triggerString.length - 2];
//                self.prefixTyped = [currentLineResult.string vv_matchesPatternRegexPattern:[NSString stringWithFormat:@"^\\s*%@$",[NSRegularExpression escapedPatternForString:preTypeString]]] | self.prefixTyped;
//            } else {
//                self.prefixTyped = YES;
//            }
//            
//            if ([currentLineResult.string vv_matchesPatternRegexPattern:[NSString stringWithFormat:@"^\\s*%@$",[NSRegularExpression escapedPatternForString:triggerString]]] && self.prefixTyped) {
//                VVTextResult *previousLineResult = [textView vv_textResultOfPreviousLine];
//                
//                // Previous line is a documentation comment, so ignore this
//                if ([previousLineResult.string vv_matchesPatternRegexPattern:@"^\\s*///"]) {
//                    return;
//                }
//                
//                VVTextResult *nextLineResult = [textView vv_textResultOfNextLine];
//                
//                // Next line is a documentation comment, so ignore this
//                if ([nextLineResult.string vv_matchesPatternRegexPattern:@"^\\s*///"]) {
//                    return;
//                }
//                
//                //Get a @"///" (triggerString) typed in by user. Do work!
//                self.prefixTyped = NO;
//                
//                __block BOOL shouldReplace = NO;
//                
//                //Decide which is closer to the cursor. A semicolon or a half brace.
//                //We just want to document the next valid line.
//                VVTextResult *resultUntilSemiColon = [textView vv_textResultUntilNextString:@";"];
//                VVTextResult *resultUntilBrace = [textView vv_textResultUntilNextString:@"{"];
//                VVTextResult *resultUntilFileEnd = [textView vv_textResultToEndOfFile];
//                
//                VVTextResult *resultToDocument = nil;
//                
//                if (resultUntilSemiColon && resultUntilBrace) {
//                    resultToDocument = (resultUntilSemiColon.range.length < resultUntilBrace.range.length) ? resultUntilSemiColon : resultUntilBrace;
//                } else if (resultUntilBrace) {
//                    resultToDocument = resultUntilBrace;
//                } else if (resultUntilSemiColon) {
//                    resultToDocument = resultUntilSemiColon;
//                } else {
//                    resultToDocument = resultUntilFileEnd;
//                }
    
//                //We always write document until semicolon for enum. (Maybe struct later)
//                if ([resultToDocument.string vv_isEnum]) {
//                    resultToDocument = resultUntilSemiColon;
//                    shouldReplace = YES;
//                }
//                
//                NSString *inputCode = nil;
//                if ([resultToDocument.string vv_isSwiftEnum]) {
//                    inputCode = [textView vv_textResultWithPairOpenString:@"{" closeString:@"}"].string;
//                } else {
//                    inputCode = [resultToDocument.string vv_stringByConvertingToUniform];
//                }
//                
//                VVDocumenter *doc = [[VVDocumenter alloc] initWithCode:inputCode];
//                NSString *documentationString = [doc document];
//                
//                if (!documentationString) {
//                    //Leave the user's input there.
//                    //It might be no need to parse doc or something wrong.
//                    return;
//                }
//                
//                //Now we are using a simulation of keyboard event to insert the docs, instead of using the IDE's private method.
//                //See more at https://github.com/onevcat/VVDocumenter-Xcode/issues/3
//                
//                //Save current content in paste board
//                NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
//                NSString *originPBString = [pasteBoard stringForType:NSPasteboardTypeString];
//                
//                //Set the doc comments in it
//                [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
//                [pasteBoard setString:documentationString forType:NSStringPboardType];
//                
//                //Begin to simulate keyborad pressing
//                VVKeyboardEventSender *kes = [[VVKeyboardEventSender alloc] init];
//                [kes beginKeyBoradEvents];
//                //Cmd+delete Delete current line
//                [kes sendKeyCode:kVK_Delete withModifierCommand:YES alt:NO shift:NO control:NO];
//                //if (shouldReplace) [textView setSelectedRange:resultToDocument.range];
//                //Cmd+V, paste (which key to actually use is based on the current keyboard layout)
//                NSInteger kKeyVCode = [[VVDocumenterSetting defaultSetting] keyVCode];
//                [kes sendKeyCode:kKeyVCode withModifierCommand:YES alt:NO shift:NO control:NO];
//                
//                //The key down is just a defined finish signal by me. When we receive this key, we know operation above is finished.
//                [kes sendKeyCode:kVK_F20];
//                
//                self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent *(NSEvent *incomingEvent) {
//                    if ([incomingEvent type] == NSKeyDown && [incomingEvent keyCode] == kVK_F20) {
//                        //Finish signal arrived, no need to observe the event
//                        [NSEvent removeMonitor:self.eventMonitor];
//                        self.eventMonitor = nil;
//                        
//                        //Restore previois patse board content
//                        [pasteBoard setString:originPBString forType:NSStringPboardType];
//                        
//                        //Set cursor before the inserted documentation. So we can use tab to begin edit.
//                        int baseIndentationLength = (int)[doc baseIndentation].length;
//                        [textView setSelectedRange:NSMakeRange(currentLineResult.range.location + baseIndentationLength, 0)];
//                        
//                        //Send a 'tab' after insert the doc. For our lazy programmers. :)
//                        [kes sendKeyCode:kVK_Tab];
//                        [kes endKeyBoradEvents];
//                        
//                        shouldReplace = NO;
//                        
//                        //Invalidate the finish signal, in case you set it to do some other thing.
//                        return nil;
//                    } else if ([incomingEvent type] == NSKeyDown && [incomingEvent keyCode] == kKeyVCode && shouldReplace == YES) {
//                        //Select input line and the define code block.
//                        NSRange r = [textView vv_textResultUntilNextString:@";"].range;
//                        
//                        //NSRange r begins from the starting of enum(struct) line. Select 1 character before to include the trigger input line.
//                        [textView setSelectedRange:NSMakeRange(r.location - 1, r.length + 1)];
//                        return incomingEvent;
//                    } else {
//                        return incomingEvent;
//                    }
//                }];
//            }
//        }
//    }
    
}

- (void)addSettingMenus
{
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
    WQModelVC *controller = [[WQModelVC alloc] initWithXCodeWindow:[NSApp keyWindow]];
    [controller showWindow:controller];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
