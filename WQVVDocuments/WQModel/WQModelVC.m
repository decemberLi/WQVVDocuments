//
//  WQModelVC.m
//  WQVVDocuments
//
//  Created by December on 16/3/14.
//  Copyright © 2016年 Shanesun. All rights reserved.
//

#import "WQModelVC.h"
#import "NSString+com.h"
#import "XCFXcodePrivate.h"
#import "VVProject.h"
#import <objc/runtime.h>

@interface WQModelVC ()
@property(weak)NSWindow *xcodeWindow;
@property (weak) IBOutlet NSTextField *nameField;
@property (strong) IBOutlet NSTextView *dataView;
@end

@implementation WQModelVC

-(instancetype)initWithXCodeWindow:(NSWindow *)xcodeWindow
{
    self = [super initWithWindowNibName:NSStringFromClass(self.class)];
    if (self) {
        self.xcodeWindow = xcodeWindow;
    }
    return self;
}

-(NSDictionary *)getSelectedItemPathAndParentItem
{
    
    NSURL *tempURL = nil;
    IDENavigableItem *parent = nil;
    id currentWindowController = [self.xcodeWindow windowController];
    
    if ([currentWindowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        IDEWorkspaceWindowController *workspaceController = currentWindowController;
        IDEWorkspaceTabController *workspaceTabController = [workspaceController activeWorkspaceTabController];
        IDENavigatorArea *navigatorArea = [workspaceTabController navigatorArea];
        id currentNavigator = [navigatorArea currentNavigator];
        
        if ([currentNavigator isKindOfClass:NSClassFromString(@"IDEStructureNavigator")]) {
            IDEStructureNavigator *structureNavigator = currentNavigator;
            id selectedObject = [structureNavigator.selectedObjects firstObject];
            
            if ([selectedObject isKindOfClass:NSClassFromString(@"IDEGroupNavigableItem")]) {
                // || [selectedObject isKindOfClass:NSClassFromString(@"IDEContainerFileReferenceNavigableItem")]) { //disallow project
                IDEGroupNavigableItem *groupNavigableItem = (IDEGroupNavigableItem *)selectedObject;
                tempURL = [[groupNavigableItem.representedObject resolvedFilePath] fileURL];
                parent = groupNavigableItem;
            }
            else if ([selectedObject isKindOfClass:NSClassFromString(@"IDEFileNavigableItem")]) {
                IDEFileNavigableItem *fileNavigableItem = (IDEFileNavigableItem *)selectedObject;
                tempURL = [[fileNavigableItem.parentItem.representedObject resolvedFilePath] fileURL];
                parent = fileNavigableItem.parentItem;
            }
        }
    }
    NSString *path = [tempURL path];
    if (path==nil) {
        return nil;
    }
    return @{@"path":path,@"parent":parent};
}

-(void)close
{
    [super close];
}

-(NSDictionary *)creatFile:(NSDictionary *)data path:(NSString *)name
{
    
    NSMutableString *temp = [NSMutableString stringWithFormat:@"@interface %@ : WBaseContent\n",[name onlyCapitalizedFistString]];
    NSMutableString *imTemp = [NSMutableString stringWithFormat:@"@implementation %@\n\n-(void)parse:(NSMutableDictionary*)info\n{\n     [super parse:info];\n     if(![info isKindOfClass:[NSDictionary class]]){\n          self.extrInfo = info;\n          return;\n     }else{\n          info = [NSMutableDictionary dictionaryWithDictionary:info];\n          self.extrInfo = info;\n     }\n",[name onlyCapitalizedFistString]];
    
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            if ([obj count]>0) {
                
                id subTemp = obj[0];
                while ([subTemp isKindOfClass:[NSArray class]]) {
                    if ([subTemp count]>0) {
                        subTemp = subTemp[0];
                    }else{
                        subTemp=@"";
                    }
                }
                NSString *subName = @"NSString";
                if ([subTemp isKindOfClass:[NSDictionary class]]) {
                    subName = [NSString stringWithFormat:@"%@%@",[name onlyCapitalizedFistString],[key onlyCapitalizedFistString]];
                    NSDictionary *tempDic = [self creatFile:subTemp path:subName];
                    NSString *subTemp = tempDic[@"interface"];
                    NSString *subImpTemp = tempDic[@"implementation"];
                    [temp insertString:subTemp atIndex:0];
                    [imTemp insertString:subImpTemp atIndex:0];
                    
                }else{
                    
                }
                [imTemp appendFormat:@"     self.%@ = [NSMutableArray new];\n     [self addDicValues:info[@\"%@\"] toArray:self.%@ className:@\"%@\"];\n",key,key,key,subName];
                [imTemp appendFormat:@"     if(self.%@.count>0){\n          [info removeObjectForKey:@\"%@\"];\n     }\n",key,key];
            }
            
            [temp appendFormat:@"@property (strong,nonatomic) NSMutableArray *%@;\n",key];
        }else if([obj isKindOfClass:[NSDictionary class]]){
            NSString *subName = [NSString stringWithFormat:@"%@%@",[name onlyCapitalizedFistString],[key onlyCapitalizedFistString]];
            NSDictionary *tempDic = [self creatFile:obj path:subName];
            NSString *subTemp = tempDic[@"interface"];
            NSString *subImpTemp = tempDic[@"implementation"];
            [temp insertString:subTemp atIndex:0];
            [imTemp insertString:subImpTemp atIndex:0];
            [temp appendFormat:@"@property (strong,nonatomic) %@ *%@;\n",subName,key];
            [imTemp appendFormat:@"     self.%@ = [[%@ alloc] initWithDictionary:info[@\"%@\"]];\n",key,subName,key];
            [imTemp appendFormat:@"     [info removeObjectForKey:@\"%@\"];\n",key];
        }else{
            [temp appendFormat:@"@property (strong,nonatomic) NSString *%@;\n",key];
            [imTemp appendFormat:@"     self.%@ = [self getDicValueForKey:info[@\"%@\"]];\n",key,key];
            [imTemp appendFormat:@"     [info removeObjectForKey:@\"%@\"];\n",key];
        }
        
    }];
    [temp appendString:@"\n@end\n\n"];
    
    [imTemp appendFormat:@"\n}\n@end\n\n"];
    
    return @{@"interface":temp,@"implementation":imTemp};
    
}

-(void)addFileToProjectWithFileName:(NSString *)fileName parentItem:(NSDictionary *)info;
{
    IDENavigableItem *parent = info[@"parent"];
    NSString *path = info[@"path"];
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") valueForKey:@"workspaceWindowControllers"];
    id workspace = nil;
    for (id controller in workspaceWindowControllers) {
        if ([[controller valueForKey:@"window"] isEqual:self.xcodeWindow]) {
            workspace = [controller valueForKey:@"_workspace"];
            break;
        }
    }
    id contextManager = [workspace valueForKey:@"_runContextManager"];
    NSString *workspacePath = [[workspace valueForKey:@"representingFilePath"] valueForKey:@"_pathString"];
    NSString *pbxprojPath = nil;
    for (id scheme in[contextManager valueForKey:@"runContexts"]) {
        NSString *schemeName = [scheme valueForKey:@"name"];
        if (![schemeName hasPrefix:@"Pods-"]) {
            if ([[contextManager valueForKey:@"runContexts"] count]==1) {
                pbxprojPath = [workspacePath stringByAppendingPathComponent:[NSString stringWithFormat:@"project.pbxproj"]];
            }else{
                pbxprojPath = [workspacePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xcodeproj/project.pbxproj",schemeName]];
            }
            
            break;
        }
    }
    NSString *xbxprojContent = [[NSString alloc] initWithContentsOfFile:pbxprojPath encoding:NSUTF8StringEncoding error:nil];
    NSString *key = [[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] md5String];
    NSString *hKey = [[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] md5String];
    NSString *buildKey = [[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] md5String];
    NSRange range = [xbxprojContent rangeOfString:@"/* End PBXBuildFile section */"];
    NSMutableString *mutableContent = [xbxprojContent mutableCopy];
    NSString *buildString = [NSString stringWithFormat:@"%@ /* %@.m in Sources */ = {isa = PBXBuildFile; fileRef = %@ /* %@.m */; };\n",buildKey,fileName,key,fileName];
    [mutableContent insertString:buildString atIndex:range.location];
    range = [mutableContent rangeOfString:@"/* End PBXFileReference section */"];
    NSString *fileStringH = [NSString stringWithFormat:@"%@ /* %@.h */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.c.h; path = %@.h; sourceTree = \"<group>\"; };\n",hKey,fileName,fileName];
    [mutableContent insertString:fileStringH atIndex:range.location];
    range = [mutableContent rangeOfString:@"/* End PBXFileReference section */"];
    NSString *fileStringM = [NSString stringWithFormat:@"%@ /* %@.m */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.c.objc; path = %@.m; sourceTree = \"<group>\"; };\n",key,fileName,fileName];
    [mutableContent insertString:fileStringM atIndex:range.location];
    id reference = [parent.representedObject valueForKey:@"reference"];
    NSString *objectID = [reference valueForKey:@"objectID"];
    
    NSString *addString = [NSString stringWithFormat:@"\n%@ /* %@.h */,\n%@ /* %@.m*/,",hKey,fileName,key,fileName];
    NSString *regularString = [NSString stringWithFormat:@"%@[\\w\\W]*?children = \\(([\\w\\W]*?)\\)",objectID];
    
    NSRange subRange = [mutableContent rangeOfString:regularString options:NSRegularExpressionSearch];
    if (subRange.location!=NSNotFound) {
        NSString *subString = [mutableContent substringWithRange:subRange];
        NSRange insertRange = [subString rangeOfString:@"children = ("];
        if (insertRange.location!=NSNotFound) {
            subString = [subString stringByReplacingCharactersInRange:NSMakeRange(insertRange.location+insertRange.length, 0) withString:addString];
        }
        [mutableContent replaceCharactersInRange:subRange withString:subString];
        [mutableContent writeToFile:pbxprojPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [[NSWorkspace sharedWorkspace] selectFile:[NSString stringWithFormat:@"%@.h",fileName] inFileViewerRootedAtPath:[NSString stringWithFormat:@"%@/%@.m",path,fileName]];
    }
    
}

#pragma mark - action

-(IBAction)onCreat:(id)sender
{
    NSData *data = nil;
    data = [self.dataView.string dataUsingEncoding:NSUTF8StringEncoding];
    if (data==nil) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"json错误";
        [alert beginSheetModalForWindow:self.window completionHandler:nil];
        return;
    }
    NSString *fileName = self.nameField.stringValue;
    if (fileName.length==0) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"请输入名字";
        [alert beginSheetModalForWindow:self.window completionHandler:nil];
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (dic==nil) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"json错误";
        [alert beginSheetModalForWindow:self.window completionHandler:nil];
        return;
    }
    NSDictionary *seletedInfo = [self getSelectedItemPathAndParentItem];
    NSString *path = [seletedInfo[@"path"] stringByAppendingFormat:@"/%@",fileName];
    NSDictionary *result = [self creatFile:dic path:fileName];
    NSString *interFace = result[@"interface"];
    interFace = [NSString stringWithFormat:@"#import \"WBaseContent.h\"\n\n%@",interFace];
    NSString *implace = result[@"implementation"];
    implace = [NSString stringWithFormat:@"#import \"%@.h\"\n#import \"WBaseContent+Private.h\"\n\n%@",[fileName onlyCapitalizedFistString],implace];
    NSString *interpath = [NSString stringWithFormat:@"%@.h",path];
    NSString *imPath = [NSString stringWithFormat:@"%@.m",path];
   BOOL canWriteInder = [interFace writeToFile:interpath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (canWriteInder) {
        BOOL canwriteImplace = [implace writeToFile:imPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        if (!canwriteImplace) {
            [[NSFileManager defaultManager] removeItemAtPath:interpath error:nil];
        }else{
            [self addFileToProjectWithFileName:fileName parentItem:seletedInfo];
        }
    }
    
    [self close];
}

-(IBAction)onCancel:(id)sender
{
    [self close];
}

#pragma mark - drage view delegate
- (BOOL)dragFileURL:(NSURL *)fileURL
{
    NSString *path = [fileURL path];
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (isDir) {
        return NO;
    }
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (string==nil || string.length==0) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"json错误";
        [alert beginSheetModalForWindow:self.window completionHandler:nil];
        return YES;
    }else{
        self.dataView.string = string;
    }
    
    return YES;
}
@end
