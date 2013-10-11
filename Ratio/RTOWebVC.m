//
//  RTOWebVC.m
//  Ratio
//
//  Created by Matthew Hillman on 10/10/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOWebVC.h"

@interface RTOWebVC () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@end

@implementation RTOWebVC
- (IBAction)done:(UIBarButtonItem *)sender
{
    [self.delegate dismiss];
}

- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (void)setup
{
    self.webView.delegate = self;
    self.navbar.topItem.title = self.barTitle;
    self.navbar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:24],
                                NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.webView loadHTMLString:self.htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
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
