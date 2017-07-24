//
//  NSAttributedString+Emotion.m
//  图文混排
//
//  Created by hw on 16/1/13.
//  Copyright © 2016年 hongw. All rights reserved.
//


#import "NSAttributedString+Emotion.h"
#import "RegexKitLite.h"
#import "HWTextPart.h"
#import "HWSpecial.h"
#import "HWEmotionTool.h"
#import "HWEmotion.h"

@implementation NSAttributedString (Emotion)


+ (NSAttributedString *)attributeStringWithStr:(NSString *)str{
    
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *allPattern = [NSString stringWithFormat:@"%@|%@|%@|%@",emotionPattern,atPattern,topicPattern,urlPattern];
    allPattern = emotionPattern;
    NSMutableArray *parts = [NSMutableArray array];
    
    [str enumerateStringsMatchedByRegex:allPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        HWTextPart *part = [[HWTextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        [parts addObject:part];
    }];
    
    
    [str enumerateStringsSeparatedByRegex:allPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        HWTextPart *part = [[HWTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    [parts sortUsingComparator:^NSComparisonResult(HWTextPart *part1, HWTextPart *part2) {
        if (part1.range.location > part2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] init];
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableArray *specials = [NSMutableArray array];
    for (HWTextPart *part in parts) {
        NSAttributedString *subStr = nil;
        if (part.emotion) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            NSString *emotionName = [HWEmotionTool emotionWithChs:part.text].png;
            if (emotionName) {
                attach.image = [UIImage imageNamed:emotionName];
                attach.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                subStr = [NSAttributedString attributedStringWithAttachment:attach];
            }else{
                subStr = [[NSAttributedString alloc] initWithString:part.text];
            }
        }else if (part.special){
            subStr = [[NSAttributedString alloc] initWithString:part.text attributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
            
            // 创建特殊对象
            HWSpecial *s = [[HWSpecial alloc] init];
            s.text = part.text;
            NSUInteger loc = attributeStr.length;
            NSUInteger len = part.text.length;
            s.range = NSMakeRange(loc, len);
            //            s.range = part.range;
            [specials addObject:s];
            
        }else{
            subStr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attributeStr appendAttributedString:subStr];
    }
    [attributeStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributeStr.length)];
    [attributeStr addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    return attributeStr;
}


@end
