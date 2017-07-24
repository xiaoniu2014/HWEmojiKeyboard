//
//  HWTextBindingExample.m
//  图文混排
//
//  Created by hw on 16/1/13.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import "HWTextBindingExample.h"

@interface HWTextBindingExample ()
@property (strong, nonatomic) UITextView *textView;
@end

@implementation HWTextBindingExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"sjobs@apple.com, apple@apple.com, banana@banana.com, pear@pear.com "];
    self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.attributedText = text;
    [self.textView setSelectedRange:NSMakeRange(0, text.length)];
    [self.view addSubview:self.textView];
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}


@end
