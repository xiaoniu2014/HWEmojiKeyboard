//
//  HWEmotionKeyboard.h
//  图文混排
//
//  Created by hw on 16/1/7.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWEmotionKeyboardDelegate <NSObject>

- (void)emotionKeyboardDidSelectedText:(NSString *)text;
- (void)emotionKeyboardDidSelectedBackspace;
@end

@interface HWEmotionKeyboard : UIView

@property (weak, nonatomic) id<HWEmotionKeyboardDelegate> delegate;

@end
