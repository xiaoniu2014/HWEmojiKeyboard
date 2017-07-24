//
//  HWEmotionTool.h
//  图文混排
//
//  Created by hw on 16/1/8.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HWEmotion;
@interface HWEmotionTool : NSObject

+ (NSArray *)recentEmotions;
+ (NSArray *)defaultEmotions;
+ (NSArray *)lxhEmotions;
+ (NSArray *)emojiEmotions;
+ (HWEmotion *)emotionWithChs:(NSString *)chs;

@end
