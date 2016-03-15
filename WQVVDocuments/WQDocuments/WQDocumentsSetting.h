//
//  WQDocumentsSetting.h
//  WQVVDocuments
//
//  Created by Jason on 16/3/15.
//  Copyright © 2016年 Shanesun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VVDSinceOption) {
    VVDSinceOptionPlaceholder,
    VVDSinceOptionProjectVersion,
    VVDSinceOptionSpecificVersion,
};

extern NSString *const VVDDefaultTriggerString;
extern NSString *const VVDDefaultAuthorString;
extern NSString *const VVDDefaultDateInfomationFormat;

@interface WQDocumentsSetting : NSObject
+ (WQDocumentsSetting *)defaultSetting;

@property (readonly) NSInteger keyVCode;
@property BOOL useSpaces;
@property NSInteger spaceCount;
@property NSString *triggerString;
@property VVDSinceOption sinceOption;
@property BOOL prefixWithStar;
@property BOOL prefixWithSlashes;
@property BOOL addSinceToComments;
@property NSString *sinceVersion;
@property BOOL briefDescription;
@property BOOL useHeaderDoc;
@property BOOL blankLinesBetweenSections;
@property BOOL alignArgumentComments;
@property BOOL useAuthorInformation;
@property NSString *authorInformation;
@property BOOL useDateInformation;
@property NSString *dateInformationFormat;
@property (readonly) NSString *spacesString;
@end


