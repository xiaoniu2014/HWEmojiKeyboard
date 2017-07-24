//
//  HWCollectionViewCell.h
//  图文混排
//
//  Created by hw on 16/1/8.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWEmotion.h"

@interface HWCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) HWEmotion *emotion;
@property (assign,nonatomic) BOOL isDelete;

@end
