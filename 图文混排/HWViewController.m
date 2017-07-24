//
//  HWViewController.m
//  图文混排
//
//  Created by hw on 16/1/22.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import "HWViewController.h"
#import "SendViewController.h"
#import "RootViewController.h"

@interface HWViewController ()

@end

@implementation HWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:true completion:^{
        SendViewController *vc = [[SendViewController alloc] init];
        [self.demoVC presentViewController:vc animated:true completion:nil];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
