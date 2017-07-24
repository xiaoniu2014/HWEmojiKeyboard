//
//  ViewController.m
//  图文混排
//
//  Created by hw on 16/1/5.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import "DemoViewController.h"
#import "RegexKitLite.h"
#import "HWTextPart.h"
#import "HWTextView.h"
#import "SendViewController.h"
#import "HWSpecial.h"
#import "HWViewController.h"

#import "NSAttributedString+Emotion.h"
#import <MediaPlayer/MediaPlayer.h>
@interface DemoViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UITextView *textView;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSString *str = @"#呵呵呵#[偷笑] http://foo.com/blah_blah #解放军#//http://foo.com/blah_blah @Ring花椰菜:就#范德萨发生的#舍不得打[test] 就惯#急急急#着他吧[挖鼻屎]//@崔西狮:小拳头举起又放下了 说点啥好呢…… //@toto97:@崔西狮 蹦米咋不揍他#哈哈哈# http://foo.com/blah_blah";
    
//    NSAttributedString *attributeStr = [self attributeStringWithStr:str];
    NSAttributedString *attributeStr = [NSAttributedString attributeStringWithStr:str];
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 40;
    CGSize size = [attributeStr boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGRect rect = {{20,100},size};
    HWTextView *textView = [[HWTextView alloc] initWithFrame:rect];
    textView.delegate = self;
    textView.attributedText = attributeStr;
    [self.view addSubview:textView];
    self.textView = textView;
    
//    UITextField *tx = [[UITextField alloc] initWithFrame:rect];
//    [self.view addSubview:tx];
//    tx.attributedText = attributeStr;
//    [self test0];
}

- (IBAction)rightBarbuttonClick:(UIBarButtonItem *)sender {
    SendViewController *vc = [[SendViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)test1{
    
}





- (void)test0{
    NSString *str = @"#呵呵呵#[偷笑] http://foo.com/blah_blah #解放军#//http://foo.com/blah_blah @Ring花椰菜:就#范德萨发生的#舍不得打[test] 就惯#急急急#着他吧[挖鼻屎]//@崔西狮:小拳头举起又放下了 说点啥好呢…… //@toto97:@崔西狮 蹦米咋不揍他#哈哈哈# http://foo.com/blah_blah";
    str = @"我的女朋友有[2]个";
    
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    
    NSString *allPattern = [NSString stringWithFormat:@"%@|%@|%@|%@",emotionPattern,atPattern,topicPattern,urlPattern];
    
    allPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:allPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regex matchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    
    if (results.count > 0) {
        NSTextCheckingResult *result = results[0];
        NSString *numStr = [str substringWithRange:result.range];
        if (numStr.length > 2 && [numStr hasPrefix:@"["] && [numStr hasSuffix:@"]"]) {
            numStr = [numStr substringWithRange:NSMakeRange(1, numStr.length - 2)];
        }
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr replaceCharactersInRange:result.range withString:numStr];
        
        [attributeStr setAttributes:@{NSForegroundColorAttributeName :[UIColor redColor]} range:NSMakeRange(result.range.location, result.range.length - 2)];
        
        
        CGFloat w = [UIScreen mainScreen].bounds.size.width - 40;
        CGSize size = [attributeStr boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGRect rect = {{20,100},size};
        HWTextView *textView = [[HWTextView alloc] initWithFrame:rect];
        textView.delegate = self;
        textView.attributedText = attributeStr;
        [self.view addSubview:textView];
        self.textView = textView;
        
    }
    
    
    for (NSTextCheckingResult *result in results) {
        NSLog(@"%@  %@",NSStringFromRange(result.range),[str substringWithRange:result.range]);
    }
    
    return;
    [str enumerateStringsMatchedByRegex:allPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        NSLog(@"%@  %@",NSStringFromRange(*capturedRanges),*capturedStrings);
    }];
    
    [str enumerateStringsSeparatedByRegex:allPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        NSLog(@"%@  %@",NSStringFromRange(*capturedRanges),*capturedStrings);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
//    NSLog(@"==%@",NSStringFromRange(characterRange));
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    NSLog(@"==%@",NSStringFromRange(characterRange));
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    HWViewController *vc = [[HWViewController alloc] init];
    vc.demoVC = self;
    [self presentViewController:vc animated:true completion:nil];
}



@end
