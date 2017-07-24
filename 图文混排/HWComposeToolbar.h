//
//  HWComposeToolbar.h
//  图文混排
//
//  Created by hw on 16/1/6.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    HWComposeToolbarButtonTypeCamera, // 拍照
    HWComposeToolbarButtonTypePicture, // 相册
    HWComposeToolbarButtonTypeMention, // @
    HWComposeToolbarButtonTypeTrend, // #
    HWComposeToolbarButtonTypeEmotion // 表情
} HWComposeToolbarButtonType;

@class HWComposeToolbar;
@protocol HWComposeToolbarDelegate <NSObject>

- (void)composeToolbar:(HWComposeToolbar *)toolbar didClickButton:(HWComposeToolbarButtonType)buttonType;

@end

@interface HWComposeToolbar : UIView

@property (assign,nonatomic) BOOL showKeyboardButton;
@property (weak,nonatomic) id<HWComposeToolbarDelegate> delegate;
@end
