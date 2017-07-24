//
//  HWEmotionKeyboard.m
//  图文混排
//
//  Created by hw on 16/1/7.
//  Copyright © 2016年 hongw. All rights reserved.
//

#define kOnePageCount 20

#import "HWEmotionKeyboard.h"
#import "HWEmotionTabBar.h"
#import "UIView+Extension.h"
#import "HWCollectionView.h"
#import "HWCollectionViewCell.h"
#import "HWKit.h"
#import "HWEmotionTool.h"
#import "HWEmotion.h"
#import "NSString+Emoji.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"


@interface HWEmotionKeyboard()<HWCollectionViewDelegate,UICollectionViewDataSource,HWEmotionTabBarDelegate,UIInputViewAudioFeedback>
@property (strong, nonatomic) HWEmotionTabBar *tabBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UILabel *pageLabel;

@property (strong, nonatomic) NSMutableArray *emotions;

@property (strong, nonatomic) NSMutableArray *groupPages;

@property (strong, nonatomic) NSMutableArray *groupIndexs;

@property (assign, nonatomic) NSUInteger page;
@end

@implementation HWEmotionKeyboard
static NSString *identifier = @"cellIdentifier";


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
    }
    return self;
}

- (void)initData{
    self.page = 0;
    self.groupPages = [NSMutableArray array];
    self.groupIndexs = [NSMutableArray array];
    
    [self updateArray:[HWEmotionTool recentEmotions]];
    [self updateArray:[HWEmotionTool defaultEmotions]];
    [self updateArray:[HWEmotionTool emojiEmotions]];
    [self updateArray:[HWEmotionTool lxhEmotions]];
}

- (void)updateArray:(NSArray *)emotionArray{
    NSArray *array = [self creatGroupArrayWithArray:emotionArray];
    [self.groupPages addObject:[NSNumber numberWithInteger:array.count]];
    self.page++;
}

- (NSMutableArray *)creatGroupArrayWithArray:(NSArray *)array{
    NSMutableArray *partArray = [NSMutableArray array];
    if (array.count != 0) {
        NSUInteger count = array.count / kOnePageCount;
        NSUInteger num = array.count % kOnePageCount;
        int i;
        if (num != 0) {
            count += 1;
        }
        
        NSUInteger loc = 0;
        NSUInteger len = kOnePageCount;
        for (i = 0; i < count; i++) {
            if (i == count-1 && num != 0) {
                len =  num;
            }
            loc = i * kOnePageCount;
            NSRange range = NSMakeRange(loc, len);
            NSArray *subArray = [array subarrayWithRange:range];
            [self.emotions addObject:subArray];
            [partArray addObject:subArray];
            [self.groupIndexs addObject:[NSNumber numberWithInteger:self.page]];
        }
    }else{
        [self.emotions addObject:[NSArray array]];
        [self.groupIndexs addObject:[NSNumber numberWithInteger:self.page]];
    }
    
    return partArray;
}

- (NSMutableArray *)emotions{
    if (!_emotions) {
        _emotions = [NSMutableArray array];
    }
    return _emotions;
}

- (void)setupUI{
    HWCollectionView *collectionview = [[HWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [collectionview registerNib:[UINib nibWithNibName:@"HWCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [self addSubview:collectionview];
    self.collectionView = collectionview;
    
    HWEmotionTabBar *tabBar = [[HWEmotionTabBar alloc] init];
    tabBar.type = HWEmotionTabBarButtonTypeDefault;
    tabBar.delegate = self;
    [self addSubview:tabBar];
    self.tabBar = tabBar;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled = NO;
    [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
    [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    self.pageLabel = [[UILabel alloc] init];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.text = @"最近使用的表情";
    self.pageLabel.font = [UIFont systemFontOfSize:14];
    self.pageLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.pageLabel];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.emotions.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 21;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.imageView.image = nil;
    cell.isDelete = NO;
    if (indexPath.item == kOnePageCount) {
        cell.isDelete = YES;
    }else{
        NSArray *array = self.emotions[indexPath.section];
        NSInteger index = [self indexTransform:indexPath.item];
        if (index < array.count) {
            HWEmotion *emotion = array[index];
            cell.emotion = emotion;
        }
    }
    
//    0 3 6 9
//    1 4 7 10
//    2 5 8 11
//    z = 3*x +y
//    
//    0 1 2 3
//    4 5 6 7
//    8 9 10 11
//    z = 4*y + x
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected:%d===%d",indexPath.item,[self indexTransform:indexPath.item]);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)collectionViewDidSelectedCell:(HWCollectionViewCell *)cell{
    if (!cell) return;
    if (cell.isDelete) {
        if ([self.delegate respondsToSelector:@selector(emotionKeyboardDidSelectedBackspace)]) {
            [self.delegate emotionKeyboardDidSelectedBackspace];
        }
    }else{
        HWEmotion *emotion = cell.emotion;
        if (emotion) {
            NSString *text = emotion.chs;
            if (emotion.code) {
//                text = emotion.code;
                NSNumber *num = [NSNumber numberWithString:emotion.code];
                text = [NSString stringWithUTF32Char:num.unsignedIntValue];
            }
            if (text) {
                if ([self.delegate respondsToSelector:@selector(emotionKeyboardDidSelectedText:)]) {
                    [self.delegate emotionKeyboardDidSelectedText:text];
                }
            }
        }
    }
}

- (NSInteger)indexTransform:(NSInteger)index{
    // transpose line/row
    NSUInteger ip = index / kOnePageCount;
    NSUInteger ii = index % kOnePageCount;
    NSUInteger reIndex = (ii % 3) * 7 + (ii / 3);
    index = reIndex + ip * kOnePageCount;
    return index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = round(scrollView.contentOffset.x / scrollView.width);
    NSInteger i =[[self.groupIndexs objectAtIndex:page] integerValue];
    if (i != NSNotFound) {
        [self.tabBar scrollToButtonType:(HWEmotionTabBarButtonType)(i + kButtonTag)];
        if (page == 0) {
            self.pageControl.hidden = YES;
            self.pageLabel.hidden = NO;
        }else{
            self.pageControl.hidden = NO;
            self.pageLabel.hidden = YES;
            NSUInteger pages = [self.groupPages[i] integerValue];
            self.pageControl.numberOfPages = pages;
            self.pageControl.currentPage = [self currentPage:page];
        }
    }
}

- (NSUInteger)currentPage:(NSInteger)page{
    NSInteger i =[[self.groupIndexs objectAtIndex:page] integerValue];
    NSArray *subArray = [self.groupPages subarrayWithRange:NSMakeRange(0, i)];
    NSNumber *num = [subArray valueForKeyPath:@"@sum.floatValue"];
    NSUInteger number = [num integerValue];
    if ([[subArray objectAtIndex:0] integerValue] == 0) number += 1;
    NSInteger currentPage = page - number;
    return currentPage;
}

- (void)emotionTabBar:(HWEmotionTabBar *)tabbar didSeletedType:(HWEmotionTabBarButtonType)type{
    NSUInteger index = type - kButtonTag;
    NSInteger num = [self.groupIndexs indexOfObject:[NSNumber numberWithInteger:index]];
    CGPoint offset = CGPointMake(num*self.collectionView.width, 0);
    [self.collectionView setContentOffset:offset animated:NO];
    switch (type) {
        case HWEmotionTabBarButtonTypeRecent:{
            
        }
            break;
        case HWEmotionTabBarButtonTypeDefault:{
            
        }
            break;
        case HWEmotionTabBarButtonTypeEmoji:{
            
        }
            break;
        case HWEmotionTabBarButtonTypeLxh:{
            
        }
            break;
            
        default:
            break;
    }
}

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        CGFloat padding = 10.0f;
        CGFloat itemW = (kScreenWidth - 2 * padding) / 7.0f;
        CGFloat itemH = 50.0f;
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(itemW, itemH);
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
    
    
    self.pageControl.x = 0;
    self.pageControl.height = 25;
    self.pageControl.y = self.height - self.tabBar.height - self.pageControl.height;
    self.pageControl.width = self.width;
    
    self.collectionView.x = 0;
    self.collectionView.y = 0;
    self.collectionView.width = self.width;
    self.collectionView.height = self.height - self.tabBar.height - self.pageControl.height;
    [self.collectionView reloadData];
    self.pageLabel.frame = self.pageControl.frame;
}

#pragma mark - UIInputViewAudioFeedback ??
- (BOOL)enableInputClicksWhenVisible{
    return YES;
}

@end
