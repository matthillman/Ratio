//
//  RTOSettingsVC.m
//  Ratio
//
//  Created by Matthew Hillman on 10/8/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOSettingsVC.h"
#import "RTOSettings.h"
#import "BackButton.h"
#import "RTOWebVC.h"
#import "BouncingViewBehavior.h"

@interface RTOSettingsVC () <ModalWebViewDismiss>
@property (weak, nonatomic) IBOutlet UISwitch *useMetricSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *useWeightSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *useEggsSwitch;
@property (weak, nonatomic) IBOutlet UIButton *scaleButton;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) BouncingViewBehavior *b;
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
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

- (IBAction)showInfo:(UIButton *)sender
{
    NSString *path, *title;
    if (sender == self.scaleButton) {
        path = [[NSBundle mainBundle] pathForResource:@"scale" ofType:@"html"];
        title = @"The Scale";
    } else if (sender == self.bookButton) {
        path = [[NSBundle mainBundle] pathForResource:@"book" ofType:@"html"];
        title = @"About the Book";
    }
    
    if (path) {
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RTOWebVC *w = [sb instantiateViewControllerWithIdentifier:@"Info View"];
        w.htmlString = html;
        w.barTitle = title;
        w.delegate = self;
        [self.delegate moveOverlapping:YES];
        [self presentViewController:w animated:YES completion:nil];
    }
}

- (void)dismiss
{
    [self.delegate moveOverlapping:NO];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)setup
{
    self.useMetricSwitch.on = [RTOSettings useMetric];
    self.useWeightSwitch.on = [RTOSettings useWeight];
    self.useEggsSwitch.on = [RTOSettings useEggs];
    
    UIButton *arrow1 = [[BackButton alloc] initWithFrame:CGRectMake(204, 12, 25, 25)];
    arrow1.backgroundColor = [UIColor clearColor];
    arrow1.transform = CGAffineTransformMakeScale(-1, 1);
    UIButton *arrow2 = [[BackButton alloc] initWithFrame:CGRectMake(204, 12, 25, 25)];
    arrow2.backgroundColor = [UIColor clearColor];
    arrow2.transform = CGAffineTransformMakeScale(-1, 1);
    
    [self.scaleButton addSubview:arrow1];
    [self.bookButton addSubview:arrow2];
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
