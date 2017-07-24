//
//  HWCollectionView.m
//  图文混排
//
//  Created by hw on 16/1/12.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import "HWCollectionView.h"
#import "HWCollectionViewCell.h"
#import "UIView+Extension.h"

@interface HWCollectionView()
{
    UIImageView *_magnifier;
    UIImageView *_magnifierContent;
    HWCollectionViewCell *_cell;
    NSTimer *_timer;
}
@end

@implementation HWCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.clipsToBounds = NO;
        
        self.canCancelContentTouches = NO;
        self.multipleTouchEnabled = NO;
        
        _magnifier = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier"]];
        
        _magnifierContent = [[UIImageView alloc] init];
        _magnifierContent.size = CGSizeMake(40, 40);
        _magnifierContent.centerX = _magnifier.width / 2;
        
        [_magnifier addSubview:_magnifierContent];
        _magnifier.hidden = YES;
        [self addSubview:_magnifier];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan");
    HWCollectionViewCell *cell = [self cellForTouches:touches];
    _cell = cell;
    [self showMagnifierForCell:_cell];
    
    if (cell.imageView.image && !cell.isDelete) {
        [[UIDevice currentDevice] playInputClick];
    }
    
    if (cell.isDelete) {
        [self endBackspaceTimer];
        [self performSelector:@selector(startBackspaceTimer) withObject:nil afterDelay:0.5];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesMoved");
    HWCollectionViewCell *cell = [self cellForTouches:touches];
    if (_cell != cell) {
        _cell = cell;
        [self showMagnifierForCell:_cell];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesCancelled");
    _magnifier.hidden = YES;
    [self endBackspaceTimer];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesEnded");
    HWCollectionViewCell *cell = [self cellForTouches:touches];
    if ([self.delegate respondsToSelector:@selector(collectionViewDidSelectedCell:)]) {
        [(id<HWCollectionViewDelegate>)self.delegate collectionViewDidSelectedCell:cell];
    }
    _magnifier.hidden = YES;
    [self endBackspaceTimer];
}

- (void)showMagnifierForCell:(HWCollectionViewCell *)cell {
    
    if (!cell.imageView.image || cell.isDelete) {
        _magnifier.hidden = YES;
        return;
    }
    
    CGRect rect = [cell convertRect:cell.bounds toView:self];
    _magnifier.centerX = CGRectGetMidX(rect);
    _magnifier.bottom = CGRectGetMaxY(rect) - 9;
    _magnifier.hidden = NO;
    
    _magnifierContent.image = cell.imageView.image;
    _magnifierContent.top = 20;
    
    NSTimeInterval duration = 0.1;
    [_magnifierContent.layer removeAllAnimations];
    [UIView animateWithDuration:duration animations:^{
        _magnifierContent.top = 3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            _magnifierContent.top = 6;
        } completion:^(BOOL finished) {
            _magnifierContent.top = 5;
        }];
    }];
}

- (HWCollectionViewCell *)cellForTouches:(NSSet<UITouch *> *)touches{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    if (indexPath) {
        HWCollectionViewCell *cell = (HWCollectionViewCell *)[self cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)startBackspaceTimer {
    [self endBackspaceTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerHandle{
    if (_cell.isDelete) {
        if ([self.delegate respondsToSelector:@selector(collectionViewDidSelectedCell:)]) {
            [[UIDevice currentDevice] playInputClick];
            [(id<HWCollectionViewDelegate>)self.delegate collectionViewDidSelectedCell:_cell];
        }
    }
}

- (void)endBackspaceTimer{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startBackspaceTimer) object:nil];
    [_timer invalidate];
    _timer = nil;
}

@end
