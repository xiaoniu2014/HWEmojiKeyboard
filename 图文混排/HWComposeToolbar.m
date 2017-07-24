//
//  HWComposeToolbar.m
//  图文混排
//
//  Created by hw on 16/1/6.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import "HWComposeToolbar.h"
#import "UIView+Extension.h"

@interface HWComposeToolbar()
@property (nonatomic, weak) UIButton *emotionButton;
@end
@implementation HWComposeToolbar


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化按钮
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:HWComposeToolbarButtonTypeCamera];
        
        [self setupBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:HWComposeToolbarButtonTypePicture];
        
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:HWComposeToolbarButtonTypeMention];
        
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:HWComposeToolbarButtonTypeTrend];
        
        self.emotionButton = [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:HWComposeToolbarButtonTypeEmotion];
    }
    return self;
}

- (UIButton *)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(HWComposeToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    return btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    CGFloat buttonW = self.width / count;
    CGFloat buttonH = self.height;
    for (int i = 0; i < count; i++) {
        UIButton *button = self.subviews[i];
        button.y = 0;
        button.x = i * buttonW;
        button.width = buttonW;
        button.height = buttonH;
    }
}

- (void)buttonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
        [self.delegate composeToolbar:self didClickButton:button.tag];
    }
    
    self.showKeyboardButton = !self.showKeyboardButton;
    if (button.tag == HWComposeToolbarButtonTypeEmotion) {
        NSString *image = @"compose_emoticonbutton_background";
        NSString *highImage = @"compose_emoticonbutton_background_highlighted";
        if (self.showKeyboardButton) {
            image = @"compose_keyboardbutton_background";
            highImage = @"compose_keyboardbutton_background_highlighted";
        }
        
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateSelected];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
