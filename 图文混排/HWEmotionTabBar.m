//
//  HWEmotionTabBar.m
//  图文混排
//
//  Created by hw on 16/1/7.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import "HWEmotionTabBar.h"
#import "UIView+Extension.h"

@interface HWEmotionTabBar()

@property (strong, nonatomic) UIButton *selectedButton;
@end

@implementation HWEmotionTabBar


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatButton:@"默认" type:HWEmotionTabBarButtonTypeRecent];
        [self creatButton:@"最近" type:HWEmotionTabBarButtonTypeDefault];
        [self creatButton:@"emoji" type:HWEmotionTabBarButtonTypeEmoji];
        [self creatButton:@"浪小花" type:HWEmotionTabBarButtonTypeLxh];
    }
    return self;
}

- (UIButton *)creatButton:(NSString *)title type:(HWEmotionTabBarButtonType)type{
    UIButton *button = [[UIButton alloc] init];
    button.tag = type;
    NSString *imageName = @"compose_emotion_table_mid_normal";
    NSString *selectedImageName = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        imageName = @"compose_emotion_table_left_normal";
        selectedImageName = @"compose_emotion_table_left_selected";
    }else if (self.subviews.count == 4){
        imageName = @"compose_emotion_table_right_normal";
        selectedImageName = @"compose_emotion_table_right_selected";
    }
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width - 1) resizingMode:UIImageResizingModeStretch];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, selectedImage.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:button];
    return  button;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSUInteger num = self.subviews.count;
    CGFloat w = self.width / num;
    CGFloat h = self.height;
    for (int i = 0; i < num; i++) {
        UIView *view = self.subviews[i];
        view.x = w * i;
        view.y = 0;
        view.height = h;
        view.width = w;
    }
}

- (void)buttonClick:(UIButton *)button{
    if (self.selectedButton == button) return;
    button.enabled = NO;
    self.selectedButton.enabled = YES;
    self.selectedButton = button;
    
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSeletedType:)]) {
        [self.delegate emotionTabBar:self didSeletedType:button.tag];
    }
}

- (void)setType:(HWEmotionTabBarButtonType)type{
    _type = type;
//    UIButton *button = [self viewWithTag:type];
//    button.enabled = NO;
//    self.selectedButton.enabled = YES;
//    self.selectedButton = button;
    
}

- (void)scrollToButtonType:(HWEmotionTabBarButtonType)type{
    
    UIButton *button = [self viewWithTag:type];
    if (self.selectedButton == button) return;
    button.enabled = NO;
    self.selectedButton.enabled = YES;
    self.selectedButton = button;
}

@end
