//
//  NSString+Extension.h
//  图文混排
//
//  Created by hw on 16/1/12.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)stringByTrim;
+ (NSString *)stringWithUTF32Char:(UTF32Char)char32;
- (BOOL)containsEmoji;
@end
