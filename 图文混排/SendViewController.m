//
//  SendViewController.m
//  图文混排
//
//  Created by hw on 16/1/5.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import "SendViewController.h"
#import "HWComposeToolbar.h"
#import "UIView+Extension.h"
#import "HWEmotionKeyboard.h"
#import "NSAttributedString+Emotion.h"

@interface SendViewController ()<HWComposeToolbarDelegate,HWEmotionKeyboardDelegate,UITextViewDelegate>
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) HWComposeToolbar *toolBar;

@property (strong, nonatomic) HWEmotionKeyboard *emotionKeyboard;

/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;

@property (copy, nonatomic) NSString *text;
@property (nonatomic, strong) NSMutableArray *plistFaces;
@end

@implementation SendViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self setupTextView];
    [self setupToolBar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

#pragma mark - Private Method
- (void)click{
    [self.textView resignFirstResponder];
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.switchingKeybaord) return;
    
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolBar.y = self.view.height - self.toolBar.height;
        } else {
            self.toolBar.y = keyboardF.origin.y - self.toolBar.height;
        }
    }];
}



- (void)setupTextView{
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)setupToolBar{
    HWComposeToolbar *toolBar = [[HWComposeToolbar alloc] init];
    toolBar.x = 0;
    toolBar.width = [UIScreen mainScreen].bounds.size.width;
    toolBar.height = 44;
    toolBar.y = self.view.bounds.size.height - toolBar.height;
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
}

- (void)deleteEmojiStringAction{
    NSString *souceText = self.textView.text;
    NSRange range = self.textView.selectedRange;
    if (range.location == NSNotFound) {
        range.location = self.textView.text.length;
    }
    if (range.length > 0) {
        [self.textView deleteBackward];
        return;
    }else{
        NSString *pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSArray *resultArray = [re matchesInString:souceText options:0 range:NSMakeRange(0, souceText.length)];
        
        NSTextCheckingResult *checkingResult = resultArray.lastObject;
        
        
        if ([souceText hasSuffix:@"]"]) {
            if ([souceText substringWithRange:checkingResult.range]) {
                NSString *newText = [souceText substringToIndex:souceText.length - checkingResult.range.length];
                self.textView.text = newText;
                return;
            }
        }else{
            [self.textView deleteBackward];
            return;
        }
        
        
        //        for (NSString *faceName in self.plistFaces) {
        //            if ([souceText hasSuffix:@"]"]) {
        //                if ([[souceText substringWithRange:checkingResult.range] isEqualToString:faceName]) {
        //                    NSString *newText = [souceText substringToIndex:souceText.length - checkingResult.range.length];
        //                    self.textView.text = newText;
        //                    return;
        //                }
        //            }else{
        //                [self.textView deleteBackward];
        //                return;
        //            }
        //        }
    }
    
}

//- (void)leftItemClick:(UIBarButtonItem *)item{
//    [self.textView resignFirstResponder];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - Delegate
- (void)composeToolbar:(HWComposeToolbar *)toolbar didClickButton:(HWComposeToolbarButtonType)buttonType{
    if (buttonType == HWComposeToolbarButtonTypeEmotion) {
        
        if (self.textView.inputView == nil) {
            self.textView.inputView = self.emotionKeyboard;
        }else{
            self.textView.inputView = nil;
        }
        
        // 开始切换键盘
        self.switchingKeybaord = YES;
        
        // 退出键盘
        [self.textView endEditing:YES];
        
        // 结束切换键盘
        self.switchingKeybaord = NO;
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 弹出键盘
            [self.textView becomeFirstResponder];
        });
    }
}

- (void)emotionKeyboardDidSelectedBackspace{
    NSLog(@"backspace");
//    [self.textView deleteBackward];
//    self.text = self.textView.text;
    [self deleteEmojiStringAction];
}

- (void)emotionKeyboardDidSelectedText:(NSString *)text{
    NSLog(@"text:%@",text);
     NSLog(@"text:%lu",(unsigned long)text.length);
    if (text.length) {
        [_plistFaces addObject:text];
        [self.textView insertText:text];
        self.text = self.textView.text;
        self.textView.attributedText = [NSAttributedString attributeStringWithStr:self.text];
        
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"字数======%lu",(unsigned long)range.location);
    
    if (range.location > 19) {
        return NO;
    }
    return YES;
}

#pragma mark - Setter / Getter
- (UIView *)emotionKeyboard{
    if (!_emotionKeyboard) {
        _emotionKeyboard = [[HWEmotionKeyboard alloc] init];
        _emotionKeyboard.delegate = self;
        _emotionKeyboard.width = self.view.width;
        _emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}



- (NSMutableArray *)plistFaces{
    if (_plistFaces) {
        return _plistFaces;
    }
    _plistFaces = [NSMutableArray new];
    return _plistFaces;
}

@end
