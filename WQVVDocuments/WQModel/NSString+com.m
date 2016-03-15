//
//  NSString+com.m
//  CreatClassFromJson
//
//  Created by liqz on 15/2/5.
//  Copyright (c) 2015年 anzogame. All rights reserved.
//

#import "NSString+com.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (com)
-(NSString *)onlyCapitalizedFistString
{
    if (self.length>0) {
        NSString *first = [self substringToIndex:1];
        first = [first uppercaseString];
        return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:first];
    }
    return self;
}
-(NSString *)md5String
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
