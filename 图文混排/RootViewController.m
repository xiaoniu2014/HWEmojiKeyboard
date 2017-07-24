//
//  RootViewController.m
//  图文混排
//
//  Created by hw on 16/1/13.
//  Copyright © 2016年 hongw. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *classNames;
@end

@implementation RootViewController
static NSString *identifier = @"rootCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    
    [self addTitle:@"demo" viewController:@"DemoViewController"];
    [self addTitle:@"emotion" viewController:@"SendViewController"];
    [self addTitle:@"textBinding" viewController:@"HWTextBindingExample"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = self.classNames[indexPath.row];
    Class class = NSClassFromString(name);
    if (class) {
        UIViewController *vc = [[class alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)addTitle:(NSString *)title viewController:(NSString *)vcName{
    [self.titles addObject:title];
    [self.classNames addObject:vcName];
}

@end
