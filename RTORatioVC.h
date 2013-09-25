//
//  RTORatioVC.h
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTORatio.h"

@interface RTORatioVC : UIViewController
@property (nonatomic, strong) RTORatio *ratio;
@property (nonatomic) CGPoint animationCenter;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSelectSegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *ratioCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *calculateTableView;
@property (weak, nonatomic) IBOutlet UITextView *instructionsTextView;
- (void)changeRatioViewWithIndex:(NSInteger)index animated:(BOOL)animated;
@end
