//
//  HWEmotion.h
//  图文混排
//
//  Created by hw on 16/1/8.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWEmotion : NSObject

/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的16进制编码 */
@property (nonatomic, copy) NSString *code;


@property (nonatomic, copy) NSString *cht;
@property (nonatomic, copy) NSString *gif;
@property (nonatomic, copy) NSString *type;

@end
