//
//  HWTextPart.m
//  图文混排
//
//  Created by hw on 16/1/5.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import "HWTextPart.h"

@implementation HWTextPart

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.text, NSStringFromRange(self.range)];
}

@end
