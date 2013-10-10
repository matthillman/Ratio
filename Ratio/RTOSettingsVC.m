//
//  RTOSettingsVC.m
//  Ratio
//
//  Created by Matthew Hillman on 10/8/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOSettingsVC.h"
#import "RTOSettings.h"

@interface RTOSettingsVC ()
@property (weak, nonatomic) IBOutlet UISwitch *useMetricSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *useWeightSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *useEggsSwitch;
@end

@implementation RTOSettingsVC

- (IBAction)metricSwitchToggle
{
    [RTOSettings setUseMetric:self.useMetricSwitch.on];
    [self.delegate defaultsChanged];
}

- (IBAction)weightSwitchToggle
{
    [RTOSettings setUseWeight:self.useWeightSwitch.on];
    [self.delegate defaultsChanged];
}

- (IBAction)eggSwitchToggle
{
    [RTOSettings setUseEggs:self.useEggsSwitch.on];
    [self.delegate defaultsChanged];
}

- (void)setup
{
    self.useMetricSwitch.on = [RTOSettings useMetric];
    self.useWeightSwitch.on = [RTOSettings useWeight];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setup];
}

@end
