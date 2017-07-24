//
//  HWCollectionView.h
//  图文混排
//
//  Created by hw on 16/1/12.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWCollectionViewCell;

@protocol HWCollectionViewDelegate <UICollectionViewDelegate>

- (void)collectionViewDidSelectedCell:(HWCollectionViewCell *)cell;

@end

@interface HWCollectionView : UICollectionView


@end
