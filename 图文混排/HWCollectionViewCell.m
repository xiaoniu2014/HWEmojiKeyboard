//
//  HWCollectionViewCell.m
//  图文混排
//
//  Created by hw on 16/1/8.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import "HWCollectionViewCell.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
#import "UIImage+Extension.h"
#import "UIView+Extension.h"

@implementation HWCollectionViewCell

- (void)awakeFromNib {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
    if (isDelete) {
        self.imageView.image = [UIImage imageNamed:@"compose_emotion_delete_highlighted"];
    }else{
        self.imageView.image = nil;
    }
    
}

- (void)setEmotion:(HWEmotion *)emotion{
    _emotion = emotion;
    
    if (emotion.code) {
        NSNumber *num = [NSNumber numberWithString:emotion.code];
        NSString *str = [NSString stringWithUTF32Char:num.unsignedIntValue];
        if (str) {
            UIImage *img = [UIImage imageWithEmoji:str size:self.imageView.width];
            self.imageView.image = img;
        }
    }else{
        NSString *imageName = emotion.png;
        self.imageView.image = [UIImage imageNamed:imageName];
    }
}

@end
