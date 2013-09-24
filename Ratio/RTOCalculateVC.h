//
//  RTOCalculateVC.h
//  Ratio
//
//  Created by Matthew Hillman on 9/24/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTORatio.h"
@interface RTOCalculateVC : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSelectSegmentedControl;
@property (nonatomic, strong) RTORatio *ratio;
@end
