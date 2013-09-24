//
//  RTOCalculateVC.m
//  Ratio
//
//  Created by Matthew Hillman on 9/24/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOCalculateVC.h"

@interface RTOCalculateVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *calculateTableView;
@end

@implementation RTOCalculateVC
- (IBAction)changeView
{
    switch (self.viewSelectSegmentedControl.selectedSegmentIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2:
        case 1:
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ratio.ingredients count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.ratio.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.calculateTableView dequeueReusableCellWithIdentifier:indexPath.item == 0 ? @"calcHeading" : @"calcRow"];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewSelectSegmentedControl.selectedSegmentIndex = 1;
}

@end
