//
//  HWDevice.h
//  图文混排
//
//  Created by hw on 16/1/8.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface HWDevice : NSObject


CGFloat HWScreenScale();

CGSize HWScreenSize();


// main screen's scale
#ifndef kScreenScale
#define kScreenScale HWScreenScale()
#endif

// main screen's size (portrait)
#ifndef kScreenSize
#define kScreenSize HWScreenSize()
#endif

// main screen's width (portrait)
#ifndef kScreenWidth
#define kScreenWidth HWScreenSize().width
#endif

// main screen's height (portrait)
#ifndef kScreenHeight
#define kScreenHeight HWScreenSize().height
#endif

@end
