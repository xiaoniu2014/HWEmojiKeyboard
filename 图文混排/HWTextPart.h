//
//  HWTextPart.h
//  图文混排
//
//  Created by hw on 16/1/5.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTextPart : NSObject

/** 这段文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isSpecical) BOOL special;
/** 是否为表情 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;

@end
