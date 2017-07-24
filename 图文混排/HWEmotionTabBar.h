//
//  HWEmotionTabBar.h
//  图文混排
//
//  Created by hw on 16/1/7.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kButtonTag 999
typedef enum{
    HWEmotionTabBarButtonTypeRecent = kButtonTag, // 最近
    HWEmotionTabBarButtonTypeDefault, // 默认
    HWEmotionTabBarButtonTypeEmoji, // emoji
    HWEmotionTabBarButtonTypeLxh, // 浪小花
}HWEmotionTabBarButtonType;

@class HWEmotionTabBar;
@protocol HWEmotionTabBarDelegate <NSObject>
@optional
- (void)emotionTabBar:(HWEmotionTabBar *)tabbar didSeletedType:(HWEmotionTabBarButtonType)type;

@end

@interface HWEmotionTabBar : UIView

@property (assign,nonatomic) HWEmotionTabBarButtonType type;

@property (weak, nonatomic) id<HWEmotionTabBarDelegate> delegate;
- (void)scrollToButtonType:(HWEmotionTabBarButtonType)type;
@end
